import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/features/reader/repositories/reader_preferences_repository.dart';
import 'package:porbi/features/reader/providers/reader_preferences_state.dart';

class ReaderPreferencesNotifier extends StateNotifier<ReaderPreferencesState> {
  final ReaderPreferencesRepository _repository;
  StreamSubscription<ReaderPreferencesData>? _subscription;

  ReaderPreferencesNotifier(this._repository) : super(const ReaderPreferencesState(isLoading: true)) {
    _init();
  }

  void _init() async {
    try {
      await _repository.getPreferences();
    } catch (_) {}

    _subscription = _repository.watchPreferences().listen(
      (preferences) {
        state = state.copyWith(
          preferences: preferences,
          isLoading: false,
          error: null,
        );
      },
      onError: (e) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> updateThemeMode(String themeMode) async {
    if (state.preferences == null) return;
    // Optimistic UI update
    final newPrefs = state.preferences!.copyWith(themeMode: themeMode);
    state = state.copyWith(preferences: newPrefs);
    // Background save
    await _repository.savePreferences(
      ReaderPreferencesCompanion(themeMode: Value(themeMode)),
    );
  }

  void updateFontSize(double fontSize) {
    if (state.preferences == null) return;
    final newPrefs = state.preferences!.copyWith(fontSize: fontSize);
    state = state.copyWith(preferences: newPrefs);
  }

  Future<void> saveFontSize(double fontSize) async {
    if (state.preferences == null) return;
    updateFontSize(fontSize);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(fontSize: Value(fontSize)),
    );
  }

  void updateLineHeight(double lineHeight) {
    if (state.preferences == null) return;
    final newPrefs = state.preferences!.copyWith(lineHeight: lineHeight);
    state = state.copyWith(preferences: newPrefs);
  }

  Future<void> saveLineHeight(double lineHeight) async {
    if (state.preferences == null) return;
    updateLineHeight(lineHeight);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(lineHeight: Value(lineHeight)),
    );
  }

  void updateMargin(double margin) {
    if (state.preferences == null) return;
    final newPrefs = state.preferences!.copyWith(horizontalMargin: margin);
    state = state.copyWith(preferences: newPrefs);
  }

  Future<void> saveMargin(double margin) async {
    if (state.preferences == null) return;
    updateMargin(margin);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(horizontalMargin: Value(margin)),
    );
  }

  Future<void> updateFontFamily(String fontFamily) async {
    if (state.preferences == null) return;
    final newPrefs = state.preferences!.copyWith(fontFamily: fontFamily);
    state = state.copyWith(preferences: newPrefs);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(fontFamily: Value(fontFamily)),
    );
  }

  Future<void> toggleFullscreen() async {
    if (state.preferences == null) return;
    final newValue = !state.preferences!.fullscreenEnabled;
    final newPrefs = state.preferences!.copyWith(fullscreenEnabled: newValue);
    state = state.copyWith(preferences: newPrefs);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(fullscreenEnabled: Value(newValue)),
    );
  }

  Future<void> toggleAutoHideControls() async {
    if (state.preferences == null) return;
    final newValue = !state.preferences!.autoHideControls;
    final newPrefs = state.preferences!.copyWith(autoHideControls: newValue);
    state = state.copyWith(preferences: newPrefs);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(autoHideControls: Value(newValue)),
    );
  }

  Future<void> toggleJustifiedText() async {
    if (state.preferences == null) return;
    final newValue = !state.preferences!.justifiedText;
    final newPrefs = state.preferences!.copyWith(justifiedText: newValue);
    state = state.copyWith(preferences: newPrefs);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(justifiedText: Value(newValue)),
    );
  }

  Future<void> updateBrightness(double? brightness) async {
    if (state.preferences == null) return;
    // For copyWith with nullable fields, we often need a special approach or just use the generated copyWith
    // If copyWith doesn't support setting to null, we might need a workaround. Assuming drift's copyWith handles it if we pass it directly.
    final newPrefs = state.preferences!.copyWith(brightnessOverride: Value(brightness));
    state = state.copyWith(preferences: newPrefs);
    await _repository.savePreferences(
      ReaderPreferencesCompanion(brightnessOverride: Value(brightness)),
    );
  }
}
