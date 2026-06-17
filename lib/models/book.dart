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
  final String? author;
  final String filePath;
  final FileType fileType;
  final int fileSize;
  final String? coverPath;
  final String? fileHash;
  final DateTime? lastOpened;
  final DateTime addedAt;
  final bool isFavorite;
  final bool isPinned;
  final int totalPages;
  final int currentPage;
  final double readingProgress;

  const Book({
    required this.id,
    required this.title,
    this.author,
    required this.filePath,
    required this.fileType,
    this.fileSize = 0,
    this.coverPath,
    this.fileHash,
    this.lastOpened,
    required this.addedAt,
    this.isFavorite = false,
    this.isPinned = false,
    this.totalPages = 0,
    this.currentPage = 0,
    this.readingProgress = 0.0,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? filePath,
    FileType? fileType,
    int? fileSize,
    String? coverPath,
    String? fileHash,
    DateTime? lastOpened,
    DateTime? addedAt,
    bool? isFavorite,
    bool? isPinned,
    int? totalPages,
    int? currentPage,
    double? readingProgress,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      coverPath: coverPath ?? this.coverPath,
      fileHash: fileHash ?? this.fileHash,
      lastOpened: lastOpened ?? this.lastOpened,
      addedAt: addedAt ?? this.addedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      readingProgress: readingProgress ?? this.readingProgress,
    );
  }

  Book clearLastOpened() {
    return Book(
      id: id,
      title: title,
      author: author,
      filePath: filePath,
      fileType: fileType,
      fileSize: fileSize,
      coverPath: coverPath,
      fileHash: fileHash,
      lastOpened: null,
      addedAt: addedAt,
      isFavorite: isFavorite,
      isPinned: isPinned,
      totalPages: totalPages,
      currentPage: currentPage,
      readingProgress: readingProgress,
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}
