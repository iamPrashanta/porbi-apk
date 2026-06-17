import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/models/chapter.dart';

class HtmlParser {
  final FileService _fileService;

  HtmlParser(this._fileService);

  Future<List<Chapter>> parse(String filePath) async {
    final content = await _fileService.readFileContent(filePath);

    // Extract title
    String title = 'HTML Document';
    final titleMatch = RegExp(
      r'<title[^>]*>([^<]+)</title>',
      caseSensitive: false,
    ).firstMatch(content);
    if (titleMatch != null) {
      title = titleMatch.group(1)!.trim();
    }

    // Extract body content
    String bodyContent = content;
    final bodyMatch = RegExp(
      r'<body[^>]*>([\s\S]*)</body>',
      caseSensitive: false,
    ).firstMatch(content);
    if (bodyMatch != null) {
      bodyContent = bodyMatch.group(1)!.trim();
    }

    return [
      Chapter(index: 0, title: title, content: bodyContent, filePath: filePath),
    ];
  }

  /// Get raw HTML for rendering.
  Future<String> getRawContent(String filePath) async {
    return _fileService.readFileContent(filePath);
  }

  /// Search within HTML content (strips tags for matching).
  List<int> searchPositions(String content, String query) {
    final plainText = _stripHtml(content);
    final positions = <int>[];
    final lowerContent = plainText.toLowerCase();
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

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
