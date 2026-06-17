import 'package:json_annotation/json_annotation.dart';

part 'reading_progress.g.dart';

@JsonSerializable()
class ReadingProgress {
  final String id;
  final String bookId;
  final int position;
  final double percentage;
  final DateTime lastRead;
  final int chapterIndex;
  final int? scrollOffset;

  const ReadingProgress({
    required this.id,
    required this.bookId,
    required this.position,
    required this.percentage,
    required this.lastRead,
    this.chapterIndex = 0,
    this.scrollOffset,
  });

  ReadingProgress copyWith({
    String? id,
    String? bookId,
    int? position,
    double? percentage,
    DateTime? lastRead,
    int? chapterIndex,
    int? scrollOffset,
  }) {
    return ReadingProgress(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      position: position ?? this.position,
      percentage: percentage ?? this.percentage,
      lastRead: lastRead ?? this.lastRead,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
    );
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ReadingProgressToJson(this);
}
