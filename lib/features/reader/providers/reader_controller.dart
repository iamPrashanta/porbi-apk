import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/features/reader/providers/reader_state.dart';
import 'package:porbi/features/reader/services/epub_parser.dart';
import 'package:porbi/features/reader/services/html_parser.dart';
import 'package:porbi/features/reader/services/markdown_parser.dart';
import 'package:porbi/features/reader/services/txt_parser.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/models/chapter.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:porbi/providers/database_provider.dart';

class ReaderController extends StateNotifier<ReaderState> {
  final AppDatabase _db;
  final FileService _fileService;
  final EpubParser _epubParser = EpubParser();

  ReaderController(this._db, this._fileService) : super(const ReaderState());

  Future<void> loadBook(String bookId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      debugPrint('[ReaderController] Loading book ID: $bookId');
      final book = await _db.getBookById(bookId);
      if (book == null) {
        debugPrint('[ReaderController] Book not found: $bookId');
        state = state.copyWith(isLoading: false, error: 'Book not found');
        return;
      }

      debugPrint('[ReaderController] Book Title: ${book.title}, File Type: ${book.fileType.name}, File Path: ${book.filePath}');

      final progress = await _db.getProgressForBook(bookId);
      final savedChapterIndex = progress?.chapterIndex ?? 0;
      final savedScrollOffset = progress?.scrollOffset ?? 0;

      // Parse based on file type
      List<Chapter> chapters;
      if (book.fileType == FileType.epub) {
        chapters = await _epubParser.parse(book.filePath);
        // If epub has a cover, update the book
        if (_epubParser.coverPath != null && book.coverPath == null) {
          final updated = book.copyWith(coverPath: _epubParser.coverPath);
          await _db.updateBook(updated);
        }
      } else if (book.fileType == FileType.txt) {
        final parser = TxtParser();
        chapters = await parser.parse(book.filePath);
      } else if (book.fileType == FileType.markdown) {
        final parser = MarkdownParser(_fileService);
        chapters = await parser.parse(book.filePath);
      } else if (book.fileType == FileType.html) {
        final parser = HtmlParser(_fileService);
        chapters = await parser.parse(book.filePath);
      } else {
        throw Exception('Unsupported file type');
      }

      debugPrint('[ReaderController] Parsed ${chapters.length} chapters.');

      if (chapters.isEmpty) {
        debugPrint('[ReaderController] Warning: Parsed 0 chapters. Creating fallback chapter.');
        chapters = const [
          Chapter(
            index: 0,
            title: 'Content',
            content: 'The document appears to be empty or could not be fully parsed.',
          )
        ];
      }

      // Update last opened
      final updatedBook = book.copyWith(
        lastOpened: DateTime.now(),
        totalPages: chapters.length,
      );
      await _db.updateBook(updatedBook);

      state = state.copyWith(
        book: updatedBook,
        chapters: chapters,
        currentChapterIndex: savedChapterIndex.clamp(0, chapters.length - 1),
        scrollPosition: savedScrollOffset.toDouble(),
        isLoading: false,
      );
    } catch (e, st) {
      debugPrint('[ReaderController] Error loading book: $e\n$st');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load book: $e',
      );
    }
  }

  Future<void> loadFromFile(String filePath, String bookId, {String? originalUri}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      debugPrint('=== READER CONTROLLER AUDIT ===');
      debugPrint('BOOK ID: $bookId');
      debugPrint('FILE PATH: $filePath');
      debugPrint('ORIGINAL URI: $originalUri');

      final file = File(filePath);
      debugPrint('Exists=${await file.exists()}');
      debugPrint('Size=${await file.length()}');
      
      final fileExists = await file.exists();
      debugPrint('FILE EXISTS: $fileExists');
      if (!fileExists) {
        throw Exception('File does not exist: $filePath');
      }

      final fileSize = await file.length();
      debugPrint('FILE SIZE: $fileSize bytes');

      final ext = filePath.split('.').last.toLowerCase();
      final fileType = _getFileTypeFromExtension(ext);
      debugPrint('RESOLVED FILE TYPE: $fileType');
      
      final contentHash = await _fileService.hashFile(file);
      
      var book = await _db.getBookById(bookId);
      
      String compositeHash = contentHash;
      if (originalUri != null) {
        compositeHash = '$originalUri|$contentHash';
      } else if (book != null && book.fileHash != null) {
        if (book.fileHash!.contains('|')) {
          final existingUri = book.fileHash!.split('|').first;
          compositeHash = '$existingUri|$contentHash';
        } else if (book.fileHash!.startsWith('content://')) {
          compositeHash = '${book.fileHash}|$contentHash';
        }
      }

      if (book == null) {
        book = Book(
          id: bookId,
          title: filePath.split('/').last.split('\\').last,
          author: 'Unknown',
          filePath: filePath,
          fileType: fileType,
          addedAt: DateTime.now(),
          fileSize: fileSize,
          fileHash: compositeHash,
        );
        await _db.insertBook(book);
        debugPrint('INSERTED NEW TEMP BOOK IN DB WITH COMPOSITE HASH: $compositeHash');
      } else {
        book = book.copyWith(
          filePath: filePath,
          fileSize: fileSize,
          lastOpened: DateTime.now(),
          fileHash: compositeHash,
        );
        await _db.updateBook(book);
        debugPrint('UPDATED TEMP BOOK IN DB WITH COMPOSITE HASH: $compositeHash');
      }

      List<Chapter> chapters;
      if (fileType == FileType.epub) {
        chapters = await _epubParser.parse(filePath);
        if (_epubParser.coverPath != null && book.coverPath == null) {
          book = book.copyWith(coverPath: _epubParser.coverPath);
          await _db.updateBook(book);
        }
      } else if (fileType == FileType.txt) {
        chapters = await TxtParser().parse(filePath);
      } else if (fileType == FileType.markdown) {
        chapters = await MarkdownParser(_fileService).parse(filePath);
      } else if (fileType == FileType.html) {
        chapters = await HtmlParser(_fileService).parse(filePath);
      } else {
        throw Exception('Unsupported file type');
      }

      debugPrint('Chapter count=${chapters.length}');
      if (chapters.isNotEmpty) {
        debugPrint('Content length=${chapters.first.content.length}');
      }

      debugPrint('CHAPTER COUNT: ${chapters.length}');
      if (chapters.isNotEmpty) {
        debugPrint('CONTENT LENGTH: ${chapters.first.content.length}');
      }

      if (chapters.isEmpty) {
        chapters = const [Chapter(index: 0, title: 'Content', content: 'No content')];
      }

      final progress = await _db.getProgressForBook(bookId);
      final savedChapterIndex = progress?.chapterIndex ?? 0;
      final savedScrollOffset = progress?.scrollOffset ?? 0;
      debugPrint('SAVED PROGRESS - CHAPTER: $savedChapterIndex, OFFSET: $savedScrollOffset');

      book = book.copyWith(
        lastOpened: DateTime.now(),
        totalPages: chapters.length,
      );
      await _db.updateBook(book);

      final currentChapter = chapters[savedChapterIndex.clamp(0, chapters.length - 1)];
      debugPrint('isLoading=false');
      debugPrint('chapters=${chapters.length}');
      debugPrint('currentChapter=${currentChapter.content.length}');

      state = state.copyWith(
        book: book,
        chapters: chapters,
        currentChapterIndex: savedChapterIndex.clamp(0, chapters.length - 1),
        scrollPosition: savedScrollOffset.toDouble(),
        isLoading: false,
      );
      debugPrint('STATE UPDATED: isLoading=${state.isLoading}, error=${state.error}, book=${state.book?.title}');
      debugPrint('================================');
    } catch(e, st) {
      debugPrint('[ReaderController] Error loading from file: $e\n$st');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  FileType _getFileTypeFromExtension(String ext) {
    switch (ext) {
      case 'epub': return FileType.epub;
      case 'md':
      case 'markdown': return FileType.markdown;
      case 'html':
      case 'htm': return FileType.html;
      case 'txt':
      default: return FileType.txt;
    }
  }

  void nextChapter() {
    final currentState = state;
    if (!currentState.hasNextChapter) return;
    
    state = currentState.copyWith(
      currentChapterIndex: currentState.currentChapterIndex + 1,
    );
    _saveProgress();
  }

  void previousChapter() {
    final currentState = state;
    if (!currentState.hasPreviousChapter) return;
    
    state = currentState.copyWith(
      currentChapterIndex: currentState.currentChapterIndex - 1,
    );
    _saveProgress();
  }

  void goToChapter(int index) {
    final currentState = state;
    if (index < 0 || index >= currentState.chapters.length) return;
    
    state = currentState.copyWith(currentChapterIndex: index);
    _saveProgress();
  }

  Future<void> saveScrollPositionToDb(double position) async {
    final currentState = state;
    if (currentState.book == null) return;

    final percentage = currentState.chapters.isEmpty
        ? 0.0
        : (currentState.currentChapterIndex + 1) / currentState.chapters.length;

    await _db.upsertProgress(
      ReadingProgressesCompanion(
        id: Value(currentState.book!.id),
        bookId: Value(currentState.book!.id),
        position: Value(currentState.currentChapterIndex),
        percentage: Value(percentage),
        lastRead: Value(DateTime.now()),
        chapterIndex: Value(currentState.currentChapterIndex),
        scrollOffset: Value(position.toInt()),
      ),
    );
  }

  Future<void> _saveProgress([double? currentScrollOffset]) async {
    final currentState = state;
    if (currentState.book == null) return;

    final percentage = currentState.chapters.isEmpty
        ? 0.0
        : (currentState.currentChapterIndex + 1) / currentState.chapters.length;

    await _db.upsertProgress(
      ReadingProgressesCompanion(
        id: Value(currentState.book!.id),
        bookId: Value(currentState.book!.id),
        position: Value(currentState.currentChapterIndex),
        percentage: Value(percentage),
        lastRead: Value(DateTime.now()),
        chapterIndex: Value(currentState.currentChapterIndex),
        scrollOffset: Value(currentScrollOffset?.toInt() ?? currentState.scrollPosition.toInt()),
      ),
    );

    await _db.updateBook(
      currentState.book!.copyWith(
        currentPage: currentState.currentChapterIndex,
        readingProgress: percentage,
      ),
    );
  }

  Future<void> saveProgressOnExit(double currentScrollOffset) async {
    await _saveProgress(currentScrollOffset);
  }

  @override
  void dispose() {
    // If disposing without an explicit exit save, we don't have the scroll controller.
    // It's safer to not overwrite the DB's scroll offset here unless we track it locally.
    _saveProgress();
    super.dispose();
  }
}

final readerControllerProvider =
    StateNotifierProvider.autoDispose<ReaderController, ReaderState>((ref) {
      return ReaderController(
        ref.watch(databaseProvider),
        ref.watch(fileServiceProvider),
      );
    });

// Alias for migration
final readerProvider = readerControllerProvider;
