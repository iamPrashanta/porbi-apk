import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/providers/database_provider.dart';

final readerPreferencesRepositoryProvider = Provider<ReaderPreferencesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ReaderPreferencesRepository(db);
});

class ReaderPreferencesRepository {
  final AppDatabase _db;

  ReaderPreferencesRepository(this._db);

  /// Get the current global reader preferences
  Future<ReaderPreferencesData> getPreferences() async {
    final query = _db.select(_db.readerPreferences)
      ..where((p) => p.id.equals('global'));
    
    final result = await query.getSingleOrNull();
    if (result != null) return result;

    // Insert default if missing
    const companion = ReaderPreferencesCompanion(id: Value('global'));
    await _db.into(_db.readerPreferences).insert(companion, mode: InsertMode.insertOrIgnore);
    return await query.getSingle();
  }

  /// Watch global reader preferences for instant UI updates
  Stream<ReaderPreferencesData> watchPreferences() {
    final query = _db.select(_db.readerPreferences)
      ..where((p) => p.id.equals('global'));
    
    return query.watchSingle();
  }

  /// Save partial or complete global preferences
  Future<void> savePreferences(ReaderPreferencesCompanion companion) async {
    await _db.into(_db.readerPreferences).insert(
          companion.copyWith(
            id: const Value('global'),
            updatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Export current preferences as JSON map
  Future<Map<String, dynamic>> exportPreferences() async {
    final prefs = await getPreferences();
    return {
      'id': prefs.id,
      'themeMode': prefs.themeMode,
      'fontSize': prefs.fontSize,
      'lineHeight': prefs.lineHeight,
      'horizontalMargin': prefs.horizontalMargin,
      'fontFamily': prefs.fontFamily,
      'fullscreenEnabled': prefs.fullscreenEnabled,
      'autoHideControls': prefs.autoHideControls,
      'justifiedText': prefs.justifiedText,
      'brightnessOverride': prefs.brightnessOverride,
      'paragraphSpacing': prefs.paragraphSpacing,
      'textAlign': prefs.textAlign,
      'showPageProgress': prefs.showPageProgress,
      'showBatteryStatus': prefs.showBatteryStatus,
      'showClock': prefs.showClock,
      'tapToTurnPage': prefs.tapToTurnPage,
      'keepScreenAwake': prefs.keepScreenAwake,
      'updatedAt': prefs.updatedAt.toIso8601String(),
    };
  }

  /// Import preferences from a JSON map
  Future<void> importPreferences(Map<String, dynamic> data) async {
    final companion = ReaderPreferencesCompanion(
      id: const Value('global'),
      themeMode: Value(data['themeMode'] as String? ?? 'light'),
      fontSize: Value((data['fontSize'] as num?)?.toDouble() ?? 16.0),
      lineHeight: Value((data['lineHeight'] as num?)?.toDouble() ?? 1.5),
      horizontalMargin: Value((data['horizontalMargin'] as num?)?.toDouble() ?? 16.0),
      fontFamily: Value(data['fontFamily'] as String? ?? 'System'),
      fullscreenEnabled: Value(data['fullscreenEnabled'] as bool? ?? false),
      autoHideControls: Value(data['autoHideControls'] as bool? ?? true),
      justifiedText: Value(data['justifiedText'] as bool? ?? false),
      brightnessOverride: Value((data['brightnessOverride'] as num?)?.toDouble()),
      paragraphSpacing: Value((data['paragraphSpacing'] as num?)?.toDouble() ?? 16.0),
      textAlign: Value(data['textAlign'] as String? ?? 'left'),
      showPageProgress: Value(data['showPageProgress'] as bool? ?? true),
      showBatteryStatus: Value(data['showBatteryStatus'] as bool? ?? true),
      showClock: Value(data['showClock'] as bool? ?? true),
      tapToTurnPage: Value(data['tapToTurnPage'] as bool? ?? true),
      keepScreenAwake: Value(data['keepScreenAwake'] as bool? ?? true),
      updatedAt: Value(DateTime.now()),
    );
    await savePreferences(companion);
  }
}
