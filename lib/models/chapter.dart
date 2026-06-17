class Chapter {
  final int index;
  final String title;
  final String content;
  final String? filePath;

  const Chapter({
    required this.index,
    required this.title,
    required this.content,
    this.filePath,
  });

  Chapter copyWith({
    int? index,
    String? title,
    String? content,
    String? filePath,
  }) {
    return Chapter(
      index: index ?? this.index,
      title: title ?? this.title,
      content: content ?? this.content,
      filePath: filePath ?? this.filePath,
    );
  }
}
