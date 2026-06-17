import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/models/reader_settings.dart' as models;
import 'package:porbi/providers/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;

// ─── Theme Mode Provider ────────────────────────────────────

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('themeMode') ?? 'system';
    state = _fromString(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _toString(mode));
  }

  ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

// ─── Reader Settings Provider ───────────────────────────────

final readerSettingsProvider =
    StateNotifierProvider<ReaderSettingsNotifier, models.ReaderSettings>((ref) {
      final db = ref.watch(databaseProvider);
      return ReaderSettingsNotifier(db);
    });

class ReaderSettingsNotifier extends StateNotifier<models.ReaderSettings> {
  final AppDatabase _db;
  static const _settingsId = 'default_settings';

  ReaderSettingsNotifier(this._db) : super(const models.ReaderSettings()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await (_db.select(_db.readerSettings)..where((s) => s.id.equals(_settingsId))).getSingleOrNull();
      if (row != null) {
        state = state.copyWith(
          fontSize: row.fontSize,
          fontFamily: row.fontFamily,
          lineHeight: row.lineHeight,
          horizontalMargin: row.margin,
          verticalMargin: row.margin,
        );
      }
    } catch (_) {
      // Use defaults if error
    }
  }

  Future<void> _save() async {
    await _db.into(_db.readerSettings).insertOnConflictUpdate(
      ReaderSettingsCompanion.insert(
        id: _settingsId,
        fontSize: drift.Value(state.fontSize),
        fontFamily: drift.Value(state.fontFamily),
        lineHeight: drift.Value(state.lineHeight),
        themeMode: drift.Value(state.readerTheme.name),
        margin: drift.Value(state.horizontalMargin),
      ),
    );
  }

  void updateFontSize(double size) {
    state = state.copyWith(fontSize: size);
    _save();
  }

  void updateFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
    _save();
  }

  void updateLineHeight(double height) {
    state = state.copyWith(lineHeight: height);
    _save();
  }

  void updateHorizontalMargin(double margin) {
    state = state.copyWith(horizontalMargin: margin);
    _save();
  }

  void updateVerticalMargin(double margin) {
    state = state.copyWith(verticalMargin: margin);
    _save();
  }

  void updateReaderTheme(models.ReaderThemeMode theme) {
    state = state.copyWith(readerTheme: theme);
    _save();
  }

  void toggleFullscreen() {
    state = state.copyWith(isFullscreen: !state.isFullscreen);
    _save();
  }

  void reset() {
    state = const models.ReaderSettings();
    _save();
  }
}
