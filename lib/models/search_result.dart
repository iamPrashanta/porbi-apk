class SearchResult {
  final String bookId;
  final String bookTitle;
  final String matchText;
  final String surroundingText;
  final int position;
  final int? chapterIndex;
  final String? chapterTitle;

  const SearchResult({
    required this.bookId,
    required this.bookTitle,
    required this.matchText,
    required this.surroundingText,
    required this.position,
    this.chapterIndex,
    this.chapterTitle,
  });
}
