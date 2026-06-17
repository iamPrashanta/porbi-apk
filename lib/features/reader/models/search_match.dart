class SearchMatch {
  final int startOffset;
  final int endOffset;
  final String previewText;
  final int? chapterIndex;
  final String? chapterTitle;

  SearchMatch({
    required this.startOffset,
    required this.endOffset,
    required this.previewText,
    this.chapterIndex,
    this.chapterTitle,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchMatch &&
          runtimeType == other.runtimeType &&
          startOffset == other.startOffset &&
          endOffset == other.endOffset &&
          previewText == other.previewText &&
          chapterIndex == other.chapterIndex &&
          chapterTitle == other.chapterTitle;

  @override
  int get hashCode =>
      startOffset.hashCode ^
      endOffset.hashCode ^
      previewText.hashCode ^
      chapterIndex.hashCode ^
      chapterTitle.hashCode;
}
