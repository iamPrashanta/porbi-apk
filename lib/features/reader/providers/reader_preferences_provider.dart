import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/features/reader/repositories/reader_preferences_repository.dart';
import 'package:porbi/features/reader/providers/reader_preferences_state.dart';
import 'package:porbi/features/reader/providers/reader_preferences_notifier.dart';

final readerPreferencesProvider = StateNotifierProvider<ReaderPreferencesNotifier, ReaderPreferencesState>((ref) {
  final repository = ref.watch(readerPreferencesRepositoryProvider);
  return ReaderPreferencesNotifier(repository);
});
