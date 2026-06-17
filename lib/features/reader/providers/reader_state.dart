import 'package:porbi/models/book.dart';
import 'package:porbi/models/chapter.dart';

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
