import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

enum FileType { txt, markdown, epub, html }

extension FileTypeExtension on FileType {
  String get displayName {
    switch (this) {
      case FileType.txt:
        return 'Text';
      case FileType.markdown:
        return 'Markdown';
      case FileType.epub:
        return 'EPUB';
      case FileType.html:
        return 'HTML';
    }
  }

  List<String> get extensions {
    switch (this) {
      case FileType.txt:
        return ['.txt'];
      case FileType.markdown:
        return ['.md', '.markdown'];
      case FileType.epub:
        return ['.epub'];
      case FileType.html:
        return ['.html', '.htm'];
    }
  }

  static FileType? fromExtension(String ext) {
    final lower = ext.toLowerCase();
    for (final type in FileType.values) {
      if (type.extensions.contains(lower)) return type;
    }
    return null;
  }
}

@JsonSerializable()
class Book {
  final String id;
  final String title;
  final String filePath;
  final FileType fileType;
  final String? coverPath;
  final DateTime? lastOpened;
  final DateTime addedAt;
  final bool isFavorite;
  final int totalPages;
  final int currentPage;
  final double readingProgress;

  const Book({
    required this.id,
    required this.title,
    required this.filePath,
    required this.fileType,
    this.coverPath,
    this.lastOpened,
    required this.addedAt,
    this.isFavorite = false,
    this.totalPages = 0,
    this.currentPage = 0,
    this.readingProgress = 0.0,
  });

  Book copyWith({
    String? id,
    String? title,
    String? filePath,
    FileType? fileType,
    String? coverPath,
    DateTime? lastOpened,
    DateTime? addedAt,
    bool? isFavorite,
    int? totalPages,
    int? currentPage,
    double? readingProgress,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      coverPath: coverPath ?? this.coverPath,
      lastOpened: lastOpened ?? this.lastOpened,
      addedAt: addedAt ?? this.addedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      readingProgress: readingProgress ?? this.readingProgress,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}
