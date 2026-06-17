import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/providers/database_provider.dart';
import 'package:porbi/features/reader/services/epub_parser.dart';

final fileServiceProvider = Provider<FileService>((ref) => FileService());

final libraryBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllBooks();
});

final recentBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRecentBooks();
});

final favoriteBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchFavoriteBooks();
});

enum LibrarySort { name, date, recent }

enum LibraryView { grid, list }

final librarySortProvider = StateProvider<LibrarySort>(
  (ref) => LibrarySort.recent,
);
final libraryViewProvider = StateProvider<LibraryView>(
  (ref) => LibraryView.grid,
);

final sortedLibraryBooksProvider = Provider<AsyncValue<List<Book>>>((ref) {
  final booksAsync = ref.watch(libraryBooksProvider);
  final sort = ref.watch(librarySortProvider);

  return booksAsync.whenData((books) {
    final sorted = [...books];
    switch (sort) {
      case LibrarySort.name:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case LibrarySort.date:
        sorted.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
      case LibrarySort.recent:
        sorted.sort((a, b) {
          final aTime = a.lastOpened ?? a.addedAt;
          final bTime = b.lastOpened ?? b.addedAt;
          return bTime.compareTo(aTime);
        });
        break;
    }
    return sorted;
  });
});

class LibraryNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;
  final FileService _fileService;

  LibraryNotifier(this._db, this._fileService) : super(const AsyncData(null));

  Future<Book?> importFile() async {
    state = const AsyncLoading();
    try {
      final file = await _fileService.pickFile();
      if (file == null) {
        state = const AsyncData(null);
        return null;
      }

      return await _processAndInsertFile(file);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Book?> importFromUri(String uri) async {
    state = const AsyncLoading();
    try {
      final file = await _fileService.importFromUri(uri);
      if (file == null) {
        state = const AsyncData(null);
        return null;
      }
      return await _processAndInsertFile(file);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<Book> _processAndInsertFile(File sourceFile) async {
    // 1. Hash the file for deduplication
    final hash = await _fileService.hashFile(sourceFile);
    
    // 2. Check if DB already has it
    final existingBook = await _db.getBookByHash(hash);
    if (existingBook != null) {
      state = const AsyncData(null);
      return existingBook;
    }

    // 3. Otherwise import and insert
    var book = await _fileService.importFile(sourceFile);
    
    // 4. Extract metadata if EPUB
    if (book.fileType == FileType.epub) {
      try {
        final parser = EpubParser();
        await parser.parse(book.filePath);
        book = book.copyWith(
          title: parser.metadata['title'] ?? book.title,
          author: parser.metadata['author'],
          coverPath: parser.coverPath,
        );
      } catch (e) {
        // Fallback to basic book if parsing fails
      }
    }
    
    await _db.insertBook(book);
    state = const AsyncData(null);
    return book;
  }

  Future<void> addBook(Book book) async {
    try {
      await _fileService.deleteFile(book.filePath);
      await _db.deleteBook(book.id);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      await _fileService.deleteFile(book.filePath);
      await _db.deleteBook(book.id);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleFavorite(String bookId) async {
    await _db.toggleFavorite(bookId);
  }
}

final libraryNotifierProvider =
    StateNotifierProvider<LibraryNotifier, AsyncValue<void>>((ref) {
      return LibraryNotifier(
        ref.watch(databaseProvider),
        ref.watch(fileServiceProvider),
      );
    });
