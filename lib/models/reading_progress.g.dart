// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    ReadingProgress(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      position: (json['position'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      lastRead: DateTime.parse(json['lastRead'] as String),
      chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
      scrollOffset: (json['scrollOffset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReadingProgressToJson(ReadingProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'position': instance.position,
      'percentage': instance.percentage,
      'lastRead': instance.lastRead.toIso8601String(),
      'chapterIndex': instance.chapterIndex,
      'scrollOffset': instance.scrollOffset,
    };
