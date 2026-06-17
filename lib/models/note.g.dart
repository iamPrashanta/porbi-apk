// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      selectedText: json['selectedText'] as String,
      noteContent: json['noteContent'] as String,
      position: (json['position'] as num).toInt(),
      chapterIndex: (json['chapterIndex'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'selectedText': instance.selectedText,
      'noteContent': instance.noteContent,
      'position': instance.position,
      'chapterIndex': instance.chapterIndex,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
