import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/features/reader/services/epub_parser.dart';
import 'package:porbi/features/reader/services/html_parser.dart';
import 'package:porbi/features/reader/services/markdown_parser.dart';
import 'package:porbi/features/reader/services/txt_parser.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/models/chapter.dart';
import 'package:porbi/providers/database_provider.dart';

// ─── Reader State ───────────────────────────────────────────

class ReaderState {
  final Book? book;
  final List<Chapter> chapters;
  final int currentChapterIndex;
  final bool isLoading;
  final String? error;
  final double scrollPosition;

  const ReaderState({
    this.book,
    this.chapters = const [],
    this.currentChapterIndex = 0,
    this.isLoading = true,
    this.error,
    this.scrollPosition = 0.0,
  });

  ReaderState copyWith({
    Book? book,
    List<Chapter>? chapters,
    int? currentChapterIndex,
    bool? isLoading,
    String? error,
    double? scrollPosition,
  }) {
    return ReaderState(
      book: book ?? this.book,
      chapters: chapters ?? this.chapters,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      scrollPosition: scrollPosition ?? this.scrollPosition,
    );
  }

  Chapter? get currentChapter {
    if (chapters.isEmpty || currentChapterIndex >= chapters.length) {
      return null;
    }
    return chapters[currentChapterIndex];
  }

  bool get hasNextChapter => currentChapterIndex < chapters.length - 1;
  bool get hasPreviousChapter => currentChapterIndex > 0;
}

// ─── Reader Notifier ────────────────────────────────────────

class ReaderNotifier extends StateNotifier<ReaderState> {
  final AppDatabase _db;
  final FileService _fileService;
  final EpubParser _epubParser = EpubParser();

  ReaderNotifier(this._db, this._fileService) : super(const ReaderState());

  Future<void> loadBook(String bookId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final book = await _db.getBookById(bookId);
      if (book == null) {
        state = state.copyWith(isLoading: false, error: 'Book not found');
        return;
      }

      // Load reading progress
      final progress = await _db.getProgressForBook(bookId);
      final savedChapterIndex = progress?.chapterIndex ?? 0;

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
        final parser = TxtParser(_fileService);
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
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load book: $e',
      );
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

  void updateScrollPosition(double position) {
    state = state.copyWith(scrollPosition: position);
  }

  Future<void> _saveProgress() async {
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
      ),
    );

    await _db.updateBook(
      currentState.book!.copyWith(
        currentPage: currentState.currentChapterIndex,
        readingProgress: percentage,
      ),
    );
  }

  Future<void> saveProgressOnExit() async {
    await _saveProgress();
  }

  @override
  void dispose() {
    _saveProgress();
    super.dispose();
  }
}

// ─── Provider ───────────────────────────────────────────────

final readerNotifierProvider =
    StateNotifierProvider.autoDispose<ReaderNotifier, ReaderState>((ref) {
      return ReaderNotifier(
        ref.watch(databaseProvider),
        ref.watch(FileService.new as dynamic) is FileService
            ? FileService()
            : FileService(),
      );
    });

// Simpler version
final readerProvider =
    StateNotifierProvider.autoDispose<ReaderNotifier, ReaderState>((ref) {
      return ReaderNotifier(ref.watch(databaseProvider), FileService());
    });
