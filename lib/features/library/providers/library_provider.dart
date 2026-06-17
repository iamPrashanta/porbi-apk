import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/providers/database_provider.dart';
import 'package:porbi/features/reader/services/epub_parser.dart';
import 'package:porbi/core/utils/file_utils.dart';

final libraryBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllBooks();
});

final recentBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRecentBooks(limit: 30).map((books) {
    return _deduplicateRecentBooks(books).take(10).toList();
  });
});

final allRecentBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRecentBooks(limit: 100).map((books) {
    return _deduplicateRecentBooks(books);
  });
});

final favoriteBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchFavoriteBooks();
});

final recentTempBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRecentTempBooks();
});

List<Book> _deduplicateRecentBooks(List<Book> books) {
  final Map<String, Book> uniqueBooks = {};
  for (final book in books) {
    final uri = FileUtils.getOriginalUri(book);
    final hash = FileUtils.getContentHash(book);
    
    // Merge rule: duplicate if same originalUri OR same fileHash.
    // We will key them by originalUri if available, else contentHash, else bookId.
    final key = uri ?? hash ?? book.id;
    
    final existing = uniqueBooks[key];
    if (existing == null) {
      uniqueBooks[key] = book;
    } else {
      final existingTime = existing.lastOpened ?? existing.addedAt;
      final bookTime = book.lastOpened ?? book.addedAt;
      if (bookTime.isAfter(existingTime)) {
        uniqueBooks[key] = book;
      }
    }
  }

  return uniqueBooks.values.toList()
    ..sort((a, b) {
      // Pinned books first
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      
      final aTime = a.lastOpened ?? a.addedAt;
      final bTime = b.lastOpened ?? b.addedAt;
      return bTime.compareTo(aTime);
    });
}

enum LibrarySort { name, date, recent }

enum LibraryView { recent, grid, list, folders }

final librarySortProvider = StateProvider<LibrarySort>(
  (ref) => LibrarySort.recent,
);
final libraryViewProvider = StateProvider<LibraryView>(
  (ref) => LibraryView.recent,
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

  Future<void> removeFromRecent(Book book) async {
    try {
      final updated = book.clearLastOpened();
      await _db.updateBook(updated);

      // Also clear lastOpened on duplicate books (same originalUri or contentHash)
      final targetUri = FileUtils.getOriginalUri(book);
      final targetHash = FileUtils.getContentHash(book);
      final allBooks = await _db.getAllBooks();
      for (final b in allBooks) {
        if (b.id != book.id && b.lastOpened != null) {
          final bUri = FileUtils.getOriginalUri(b);
          final bHash = FileUtils.getContentHash(b);
          final isDup = (targetUri != null && bUri == targetUri) || 
                       (targetHash != null && bHash == targetHash);
          if (isDup) {
            await _db.updateBook(b.clearLastOpened());
          }
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> restoreToRecent(Book book, DateTime originalLastOpened) async {
    try {
      final updated = book.copyWith(lastOpened: originalLastOpened);
      await _db.updateBook(updated);

      // Also restore lastOpened on duplicate books (same originalUri or contentHash)
      final targetUri = FileUtils.getOriginalUri(book);
      final targetHash = FileUtils.getContentHash(book);
      final allBooks = await _db.getAllBooks();
      for (final b in allBooks) {
        if (b.id != book.id) {
          final bUri = FileUtils.getOriginalUri(b);
          final bHash = FileUtils.getContentHash(b);
          final isDup = (targetUri != null && bUri == targetUri) || 
                       (targetHash != null && bHash == targetHash);
          if (isDup) {
            await _db.updateBook(b.copyWith(lastOpened: originalLastOpened));
          }
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> togglePinned(Book book) async {
    try {
      final updated = book.copyWith(isPinned: !book.isPinned);
      await _db.updateBook(updated);

      // Also toggle isPinned on duplicate books (same originalUri or contentHash)
      final targetUri = FileUtils.getOriginalUri(book);
      final targetHash = FileUtils.getContentHash(book);
      final allBooks = await _db.getAllBooks();
      for (final b in allBooks) {
        if (b.id != book.id) {
          final bUri = FileUtils.getOriginalUri(b);
          final bHash = FileUtils.getContentHash(b);
          final isDup = (targetUri != null && bUri == targetUri) || 
                       (targetHash != null && bHash == targetHash);
          if (isDup) {
            await _db.updateBook(b.copyWith(isPinned: !book.isPinned));
          }
        }
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final libraryNotifierProvider =
    StateNotifierProvider<LibraryNotifier, AsyncValue<void>>((ref) {
      return LibraryNotifier(
        ref.watch(databaseProvider),
        ref.watch(fileServiceProvider),
      );
    });
