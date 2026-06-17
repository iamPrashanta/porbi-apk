import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:porbi/models/chapter.dart';

class EpubParser {
  String? _extractedPath;
  String? _coverPath;
  List<Chapter> _chapters = [];
  Map<String, String> _metadata = {};

  String? get coverPath => _coverPath;
  List<Chapter> get chapters => _chapters;
  Map<String, String> get metadata => _metadata;

  Future<List<Chapter>> parse(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract to temp directory
    final appDir = await getApplicationDocumentsDirectory();
    final bookHash = filePath.hashCode.toRadixString(16);
    _extractedPath = p.join(appDir.path, 'epub_cache', bookHash);
    final extractDir = Directory(_extractedPath!);

    if (!await extractDir.exists()) {
      await extractDir.create(recursive: true);
      for (final file in archive) {
        final filename = p.join(_extractedPath!, file.name);
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(filename).create(recursive: true);
        }
      }
    }

    // Parse container.xml to find the OPF file
    final containerPath = p.join(_extractedPath!, 'META-INF', 'container.xml');
    final containerFile = File(containerPath);
    if (!await containerFile.exists()) {
      return _fallbackParse(archive);
    }

    final containerContent = await containerFile.readAsString();
    final opfPath = _extractOpfPath(containerContent);
    if (opfPath == null) {
      return _fallbackParse(archive);
    }

    final opfFullPath = p.join(_extractedPath!, opfPath);
    final opfFile = File(opfFullPath);
    if (!await opfFile.exists()) {
      return _fallbackParse(archive);
    }

    final opfContent = await opfFile.readAsString();
    final opfDir = p.dirname(opfFullPath);

    // Parse metadata
    _metadata = _parseMetadata(opfContent);

    // Parse manifest
    final manifest = _parseManifest(opfContent, opfDir);

    // Parse spine
    final spineIds = _parseSpine(opfContent);

    // Extract cover
    _coverPath = _extractCover(opfContent, manifest, opfDir);

    // Build chapters from spine order
    _chapters = await _buildChapters(spineIds, manifest);

    // If no chapters found, try fallback
    if (_chapters.isEmpty) {
      return _fallbackParse(archive);
    }

    return _chapters;
  }

  String? _extractOpfPath(String containerXml) {
    final regex = RegExp(r'full-path="([^"]+)"');
    final match = regex.firstMatch(containerXml);
    return match?.group(1);
  }

  Map<String, String> _parseMetadata(String opfContent) {
    final meta = <String, String>{};

    final titleMatch = RegExp(
      r'<dc:title[^>]*>([^<]+)</dc:title>',
    ).firstMatch(opfContent);
    if (titleMatch != null) meta['title'] = titleMatch.group(1)!.trim();

    final authorMatch = RegExp(
      r'<dc:creator[^>]*>([^<]+)</dc:creator>',
    ).firstMatch(opfContent);
    if (authorMatch != null) meta['author'] = authorMatch.group(1)!.trim();

    final langMatch = RegExp(
      r'<dc:language[^>]*>([^<]+)</dc:language>',
    ).firstMatch(opfContent);
    if (langMatch != null) meta['language'] = langMatch.group(1)!.trim();

    return meta;
  }

  Map<String, _ManifestItem> _parseManifest(String opfContent, String opfDir) {
    final manifest = <String, _ManifestItem>{};
    final regex = RegExp(
      r'<item\s+[^>]*id="([^"]+)"[^>]*href="([^"]+)"[^>]*media-type="([^"]+)"[^>]*/?>',
    );

    for (final match in regex.allMatches(opfContent)) {
      final id = match.group(1)!;
      final href = match.group(2)!;
      final mediaType = match.group(3)!;
      manifest[id] = _ManifestItem(
        id: id,
        href: Uri.decodeFull(href),
        mediaType: mediaType,
        fullPath: p.join(opfDir, Uri.decodeFull(href)),
      );
    }

    return manifest;
  }

  List<String> _parseSpine(String opfContent) {
    final spineIds = <String>[];
    final regex = RegExp(r'<itemref\s+[^>]*idref="([^"]+)"[^>]*/?>');

    for (final match in regex.allMatches(opfContent)) {
      spineIds.add(match.group(1)!);
    }

    return spineIds;
  }

  String? _extractCover(
    String opfContent,
    Map<String, _ManifestItem> manifest,
    String opfDir,
  ) {
    // Try to find cover from meta
    final coverMetaMatch = RegExp(
      r'<meta\s+[^>]*name="cover"\s+content="([^"]+)"[^>]*/?>',
    ).firstMatch(opfContent);

    if (coverMetaMatch != null) {
      final coverId = coverMetaMatch.group(1)!;
      final coverItem = manifest[coverId];
      if (coverItem != null) return coverItem.fullPath;
    }

    // Try to find cover from properties
    final coverPropMatch = RegExp(
      r'<item\s+[^>]*properties="cover-image"[^>]*href="([^"]+)"[^>]*/?>',
    ).firstMatch(opfContent);

    if (coverPropMatch != null) {
      return p.join(opfDir, Uri.decodeFull(coverPropMatch.group(1)!));
    }

    // Look for common cover filenames
    for (final item in manifest.values) {
      if (item.mediaType.startsWith('image/') &&
          (item.href.toLowerCase().contains('cover') ||
              item.id.toLowerCase().contains('cover'))) {
        return item.fullPath;
      }
    }

    return null;
  }

  Future<List<Chapter>> _buildChapters(
    List<String> spineIds,
    Map<String, _ManifestItem> manifest,
  ) async {
    final chapters = <Chapter>[];
    int index = 0;

    for (final id in spineIds) {
      final item = manifest[id];
      if (item == null) continue;
      if (!item.mediaType.contains('html') && !item.mediaType.contains('xml')) {
        continue;
      }

      final file = File(item.fullPath);
      if (!await file.exists()) continue;

      String content = await file.readAsString();

      // Extract title from the content
      final String title = _extractChapterTitle(content) ?? 'Chapter ${index + 1}';

      // Clean HTML for display
      content = _cleanHtmlContent(content);

      chapters.add(
        Chapter(
          index: index,
          title: title,
          content: content,
          filePath: item.fullPath,
        ),
      );
      index++;
    }

    return chapters;
  }

  String? _extractChapterTitle(String html) {
    // Try h1, h2, h3, title tags
    for (final tag in ['h1', 'h2', 'h3', 'title']) {
      final match = RegExp('<$tag[^>]*>([^<]+)</$tag>').firstMatch(html);
      if (match != null) {
        final title = match.group(1)!.trim();
        if (title.isNotEmpty) return title;
      }
    }
    return null;
  }

  String _cleanHtmlContent(String html) {
    // Remove XML declaration and doctype
    html = html.replaceAll(RegExp(r'<\?xml[^?]*\?>'), '');
    html = html.replaceAll(RegExp(r'<!DOCTYPE[^>]*>'), '');

    // Extract body content if present
    final bodyMatch = RegExp(
      r'<body[^>]*>([\s\S]*)</body>',
      caseSensitive: false,
    ).firstMatch(html);
    if (bodyMatch != null) {
      html = bodyMatch.group(1)!;
    }

    return html.trim();
  }

  Future<List<Chapter>> _fallbackParse(Archive archive) async {
    final chapters = <Chapter>[];
    int index = 0;

    final htmlFiles = archive.files.where((f) {
      final ext = p.extension(f.name).toLowerCase();
      return f.isFile && (ext == '.html' || ext == '.xhtml' || ext == '.htm');
    }).toList();

    // Sort by name for proper ordering
    htmlFiles.sort((a, b) => a.name.compareTo(b.name));

    for (final file in htmlFiles) {
      final content = String.fromCharCodes(file.content as Uint8List);
      final title = _extractChapterTitle(content) ?? 'Chapter ${index + 1}';
      final cleaned = _cleanHtmlContent(content);

      chapters.add(Chapter(index: index, title: title, content: cleaned));
      index++;
    }

    return chapters;
  }

  /// Search within all chapters.
  List<MapEntry<int, int>> searchPositions(String query) {
    final results = <MapEntry<int, int>>[];
    final lowerQuery = query.toLowerCase();

    for (final chapter in _chapters) {
      // Strip HTML tags for search
      final plainText = chapter.content
          .replaceAll(RegExp(r'<[^>]+>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ');
      final lowerContent = plainText.toLowerCase();

      int index = 0;
      while (true) {
        index = lowerContent.indexOf(lowerQuery, index);
        if (index == -1) break;
        results.add(MapEntry(chapter.index, index));
        index += lowerQuery.length;
      }
    }

    return results;
  }

  /// Get plain text from HTML content.
  static String htmlToPlainText(String html) {
    return html
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<p[^>]*>'), '\n')
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'&quot;'), '"')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  /// Clean up extracted EPUB cache.
  Future<void> cleanup() async {
    if (_extractedPath != null) {
      final dir = Directory(_extractedPath!);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    }
  }
}

class _ManifestItem {
  final String id;
  final String href;
  final String mediaType;
  final String fullPath;

  _ManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
    required this.fullPath,
  });
}
