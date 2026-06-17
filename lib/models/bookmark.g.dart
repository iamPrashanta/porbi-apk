// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      position: (json['position'] as num).toInt(),
      chapterIndex: (json['chapterIndex'] as num?)?.toInt(),
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'position': instance.position,
      'chapterIndex': instance.chapterIndex,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'createdAt': instance.createdAt.toIso8601String(),
    };
