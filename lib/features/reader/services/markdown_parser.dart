import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/models/chapter.dart';

class MarkdownParser {
  final FileService _fileService;

  MarkdownParser(this._fileService);

  Future<List<Chapter>> parse(String filePath) async {
    final file = File(filePath);
    final fileSize = await file.length();
    final content = await _fileService.readFileContent(filePath);
    
    debugPrint('=== PARSER AUDIT ===');
    debugPrint('File Size: $fileSize bytes');
    debugPrint('Raw Content Length: ${content.length}');

    // Try to split by headings for chapter navigation
    var chapters = _splitByHeadings(content);

    if (chapters.isEmpty) {
      chapters = [Chapter(index: 0, title: 'Full Document', content: content)];
    }

    debugPrint('Parsed Chapter Count: ${chapters.length}');
    for (int i = 0; i < chapters.length; i++) {
      debugPrint('Chapter $i length: ${chapters[i].content.length}');
    }
    debugPrint('====================');

    return chapters;
  }

  List<Chapter> _splitByHeadings(String content) {
    final lines = content.split('\n');
    final chapters = <Chapter>[];
    final headingPattern = RegExp(r'^#{1,2}\s+(.+)$');

    String currentTitle = 'Introduction';
    final buffer = StringBuffer();
    int chapterIndex = 0;

    for (final line in lines) {
      final match = headingPattern.firstMatch(line);
      if (match != null && buffer.isNotEmpty) {
        chapters.add(
          Chapter(
            index: chapterIndex,
            title: currentTitle,
            content: buffer.toString().trim(),
          ),
        );
        buffer.clear();
        chapterIndex++;
        currentTitle = match.group(1)?.trim() ?? 'Section $chapterIndex';
      }
      buffer.writeln(line);
    }

    // Add the last section
    if (buffer.isNotEmpty) {
      chapters.add(
        Chapter(
          index: chapterIndex,
          title: currentTitle,
          content: buffer.toString().trim(),
        ),
      );
    }

    return chapters;
  }

  /// Get raw markdown content for rendering.
  Future<String> getRawContent(String filePath) async {
    return _fileService.readFileContent(filePath);
  }

  /// Search within markdown content (strips markdown syntax for matching).
  List<int> searchPositions(String content, String query) {
    final positions = <int>[];
    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int index = 0;
    while (true) {
      index = lowerContent.indexOf(lowerQuery, index);
      if (index == -1) break;
      positions.add(index);
      index += lowerQuery.length;
    }

    return positions;
  }
}
