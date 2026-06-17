import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/providers/database_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final bookNotesProvider = StreamProvider.family<List<NotesData>, String>((
  ref,
  bookId,
) {
  final db = ref.watch(databaseProvider);
  return db.watchNotesForBook(bookId);
});

class NotesNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  NotesNotifier(this._db) : super(const AsyncData(null));

  Future<void> addNote({
    required String bookId,
    required String selectedText,
    required String noteContent,
    required int position,
    int? chapterIndex,
  }) async {
    try {
      await _db.insertNote(
        NotesCompanion.insert(
          id: _uuid.v4(),
          bookId: bookId,
          selectedText: selectedText,
          noteContent: noteContent,
          position: position,
          chapterIndex: Value(chapterIndex),
          createdAt: DateTime.now(),
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateNote({
    required String id,
    required String noteContent,
  }) async {
    try {
      await _db.updateNote(
        NotesCompanion(
          id: Value(id),
          noteContent: Value(noteContent),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _db.deleteNote(id);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final notesNotifierProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<void>>((ref) {
      return NotesNotifier(ref.watch(databaseProvider));
    });
