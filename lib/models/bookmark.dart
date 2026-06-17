import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark {
  final String id;
  final String bookId;
  final int position;
  final int? chapterIndex;
  final String title;
  final String? excerpt;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.bookId,
    required this.position,
    this.chapterIndex,
    required this.title,
    this.excerpt,
    required this.createdAt,
  });

  Bookmark copyWith({
    String? id,
    String? bookId,
    int? position,
    int? chapterIndex,
    String? title,
    String? excerpt,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      position: position ?? this.position,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
