import 'package:porbi/core/storage/database.dart';

class ReaderPreferencesState {
  final ReaderPreferencesData? preferences;
  final bool isLoading;
  final String? error;

  const ReaderPreferencesState({
    this.preferences,
    this.isLoading = false,
    this.error,
  });

  ReaderPreferencesState copyWith({
    ReaderPreferencesData? preferences,
    bool? isLoading,
    String? error,
  }) {
    return ReaderPreferencesState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
