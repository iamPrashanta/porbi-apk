import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String id;
  final String bookId;
  final String selectedText;
  final String noteContent;
  final int position;
  final int? chapterIndex;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Note({
    required this.id,
    required this.bookId,
    required this.selectedText,
    required this.noteContent,
    required this.position,
    this.chapterIndex,
    required this.createdAt,
    this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? bookId,
    String? selectedText,
    String? noteContent,
    int? position,
    int? chapterIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      selectedText: selectedText ?? this.selectedText,
      noteContent: noteContent ?? this.noteContent,
      position: position ?? this.position,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
