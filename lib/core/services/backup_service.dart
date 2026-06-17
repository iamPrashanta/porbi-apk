import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupService {
  final AppDatabase _database;

  BackupService(this._database);

  /// Create a full backup as a JSON file.
  Future<File> createBackup() async {
    final data = await _database.exportAll();

    // Add settings to backup
    final prefs = await SharedPreferences.getInstance();
    data['settings'] = {
      'themeMode': prefs.getString('themeMode') ?? 'system',
      'readerSettings': prefs.getString('readerSettings'),
    };

    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(backupDir.path, 'porbi_backup_$timestamp.json'));
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));

    return file;
  }

  /// Restore from a backup JSON file.
  Future<void> restoreBackup(File backupFile) async {
    final content = await backupFile.readAsString();
    final data = json.decode(content) as Map<String, dynamic>;

    // Restore database
    await _database.importAll(data);

    // Restore settings
    if (data['settings'] != null) {
      final settings = data['settings'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();

      if (settings['themeMode'] != null) {
        await prefs.setString('themeMode', settings['themeMode'] as String);
      }
      if (settings['readerSettings'] != null) {
        await prefs.setString(
          'readerSettings',
          settings['readerSettings'] as String,
        );
      }
    }
  }

  /// Export notes for a specific book as JSON.
  Future<String> exportNotes(String bookId) async {
    final notes = await _database.getNotesForBook(bookId);
    final data = notes
        .map(
          (n) => {
            'selectedText': n.selectedText,
            'noteContent': n.noteContent,
            'createdAt': n.createdAt.toIso8601String(),
          },
        )
        .toList();

    return const JsonEncoder.withIndent('  ').convert({
      'bookId': bookId,
      'exportedAt': DateTime.now().toIso8601String(),
      'notes': data,
    });
  }

  /// Export bookmarks for a specific book as JSON.
  Future<String> exportBookmarks(String bookId) async {
    final bookmarks = await _database.getBookmarksForBook(bookId);
    final data = bookmarks
        .map(
          (b) => {
            'title': b.title,
            'position': b.position,
            'createdAt': b.createdAt.toIso8601String(),
          },
        )
        .toList();

    return const JsonEncoder.withIndent('  ').convert({
      'bookId': bookId,
      'exportedAt': DateTime.now().toIso8601String(),
      'bookmarks': data,
    });
  }
}
