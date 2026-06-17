import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/models/search_result.dart';
import 'package:porbi/providers/database_provider.dart';
import 'package:porbi/core/services/file_service.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.family<List<SearchResult>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];

    final db = ref.watch(databaseProvider);
    final fileService = FileService();
    final books = await db.getAllBooks();
    final results = <SearchResult>[];

    for (final book in books) {
      // Search in title
      if (book.title.toLowerCase().contains(query.toLowerCase())) {
        results.add(
          SearchResult(
            bookId: book.id,
            bookTitle: book.title,
            matchText: book.title,
            surroundingText: 'Title match',
            position: 0,
          ),
        );
      }

      // Search in content (for text-based files)
      if (book.fileType != FileType.epub) {
        try {
          final content = await fileService.readFileContent(book.filePath);
          final lowerContent = content.toLowerCase();
          final lowerQuery = query.toLowerCase();

          int index = 0;
          int count = 0;
          while (count < 5) {
            // Limit results per book
            index = lowerContent.indexOf(lowerQuery, index);
            if (index == -1) break;

            final start = (index - 40).clamp(0, content.length);
            final end = (index + query.length + 40).clamp(0, content.length);
            final surrounding = content.substring(start, end);

            results.add(
              SearchResult(
                bookId: book.id,
                bookTitle: book.title,
                matchText: content.substring(index, index + query.length),
                surroundingText: '...$surrounding...',
                position: index,
              ),
            );

            index += query.length;
            count++;
          }
        } catch (_) {
          // Skip files that can't be read
        }
      }
    }

    return results;
  },
);

// In-book search
final inBookSearchQueryProvider = StateProvider<String>((ref) => '');

final inBookSearchResultsProvider = StateProvider<List<int>>((ref) => []);
final inBookCurrentResultProvider = StateProvider<int>((ref) => 0);
