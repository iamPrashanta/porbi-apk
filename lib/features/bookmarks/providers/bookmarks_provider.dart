import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/providers/database_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final bookBookmarksProvider =
    StreamProvider.family<List<BookmarksData>, String>((ref, bookId) {
      final db = ref.watch(databaseProvider);
      return db.watchBookmarksForBook(bookId);
    });

final allBookmarksProvider = FutureProvider<Map<String, List<BookmarksData>>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final books = await db.getAllBooks();
  final result = <String, List<BookmarksData>>{};
  for (final book in books) {
    final bookmarks = await db.getBookmarksForBook(book.id);
    if (bookmarks.isNotEmpty) {
      result[book.id] = bookmarks;
    }
  }
  return result;
});

class BookmarksNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  BookmarksNotifier(this._db) : super(const AsyncData(null));

  Future<void> addBookmark({
    required String bookId,
    required int position,
    required String title,
    int? chapterIndex,
    String? excerpt,
  }) async {
    try {
      await _db.insertBookmark(
        BookmarksCompanion.insert(
          id: _uuid.v4(),
          bookId: bookId,
          position: position,
          chapterIndex: Value(chapterIndex),
          title: title,
          excerpt: Value(excerpt),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> renameBookmark(String id, String newTitle) async {
    try {
      await _db.updateBookmark(
        BookmarksCompanion(id: Value(id), title: Value(newTitle)),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteBookmark(String id) async {
    try {
      await _db.deleteBookmark(id);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final bookmarksNotifierProvider =
    StateNotifierProvider<BookmarksNotifier, AsyncValue<void>>((ref) {
      return BookmarksNotifier(ref.watch(databaseProvider));
    });
