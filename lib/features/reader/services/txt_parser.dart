import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/models/chapter.dart';

class TxtParser {
  final FileService _fileService;

  TxtParser(this._fileService);

  Future<List<Chapter>> parse(String filePath) async {
    final content = await _fileService.readFileContent(filePath);

    // Split into pages of roughly 4000 characters each
    const pageSize = 4000;
    final chapters = <Chapter>[];

    if (content.length <= pageSize) {
      chapters.add(Chapter(index: 0, title: 'Full Text', content: content));
    } else {
      int start = 0;
      int pageIndex = 0;

      while (start < content.length) {
        int end = start + pageSize;
        if (end >= content.length) {
          end = content.length;
        } else {
          // Try to break at a paragraph or sentence boundary
          final lastNewline = content.lastIndexOf('\n', end);
          final lastPeriod = content.lastIndexOf('. ', end);

          if (lastNewline > start + (pageSize ~/ 2)) {
            end = lastNewline + 1;
          } else if (lastPeriod > start + (pageSize ~/ 2)) {
            end = lastPeriod + 2;
          }
        }

        chapters.add(
          Chapter(
            index: pageIndex,
            title: 'Page ${pageIndex + 1}',
            content: content.substring(start, end),
          ),
        );

        start = end;
        pageIndex++;
      }
    }

    return chapters;
  }

  /// Search within text content.
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
