import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/features/reader/models/search_match.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';


class SearchState {
  final String query;
  final List<SearchMatch> matches;
  final int currentMatchIndex;
  final bool isSearching;
  final bool searchResultsVisible;

  const SearchState({
    this.query = '',
    this.matches = const [],
    this.currentMatchIndex = -1,
    this.isSearching = false,
    this.searchResultsVisible = false,
  });

  SearchState copyWith({
    String? query,
    List<SearchMatch>? matches,
    int? currentMatchIndex,
    bool? isSearching,
    bool? searchResultsVisible,
  }) {
    return SearchState(
      query: query ?? this.query,
      matches: matches ?? this.matches,
      currentMatchIndex: currentMatchIndex ?? this.currentMatchIndex,
      isSearching: isSearching ?? this.isSearching,
      searchResultsVisible: searchResultsVisible ?? this.searchResultsVisible,
    );
  }

  SearchMatch? get currentMatch => 
      currentMatchIndex >= 0 && currentMatchIndex < matches.length 
          ? matches[currentMatchIndex] 
          : null;
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref _ref;
  Timer? _debounce;

  SearchNotifier(this._ref) : super(const SearchState());

  void showSearch() {
    state = state.copyWith(searchResultsVisible: true);
  }

  void hideSearch() {
    state = state.copyWith(searchResultsVisible: false);
  }

  void clearSearch() {
    state = const SearchState(searchResultsVisible: true); // keep overlay open
  }

  void fullClear() {
    state = const SearchState();
  }

  void performSearch(String query) {
    if (query == state.query) return;

    state = state.copyWith(query: query, isSearching: true);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _executeSearch(query);
    });
  }

  void _executeSearch(String query) {
    if (query.isEmpty) {
      state = state.copyWith(matches: [], currentMatchIndex: -1, isSearching: false);
      return;
    }

    final readerState = _ref.read(readerProvider);
    final chapters = readerState.chapters;
    
    final lowerQuery = query.toLowerCase();
    final results = <SearchMatch>[];

    for (int c = 0; c < chapters.length; c++) {
      final chapter = chapters[c];
      final content = chapter.content;
      final lowerContent = content.toLowerCase();

      int index = 0;
      while (true) {
        index = lowerContent.indexOf(lowerQuery, index);
        if (index == -1) break;
        
        // Extract preview text (e.g. 30 chars before and after)
        final startPreview = (index - 30).clamp(0, content.length);
        final endPreview = (index + query.length + 30).clamp(0, content.length);
        String preview = content.substring(startPreview, endPreview).replaceAll('\n', ' ');
        if (startPreview > 0) preview = '...$preview';
        if (endPreview < content.length) preview = '$preview...';

        results.add(SearchMatch(
          startOffset: index,
          endOffset: index + query.length,
          previewText: preview,
          chapterIndex: c,
          chapterTitle: chapter.title,
        ));
        
        index += query.length;
      }
    }

    state = state.copyWith(
      matches: results,
      currentMatchIndex: results.isNotEmpty ? 0 : -1,
      isSearching: false,
    );

    _syncWithReader();
  }

  void nextMatch() {
    if (state.matches.isEmpty) return;
    final nextIndex = (state.currentMatchIndex + 1) % state.matches.length;
    state = state.copyWith(currentMatchIndex: nextIndex);
    _syncWithReader();
  }

  void previousMatch() {
    if (state.matches.isEmpty) return;
    final prevIndex = state.currentMatchIndex - 1 < 0 
        ? state.matches.length - 1 
        : state.currentMatchIndex - 1;
    state = state.copyWith(currentMatchIndex: prevIndex);
    _syncWithReader();
  }

  void goToMatch(int index) {
    if (index >= 0 && index < state.matches.length) {
      state = state.copyWith(currentMatchIndex: index);
      _syncWithReader();
    }
  }

  void _syncWithReader() {
    final match = state.currentMatch;
    if (match != null) {
      final readerNotifier = _ref.read(readerProvider.notifier);
      final readerState = _ref.read(readerProvider);
      
      if (match.chapterIndex != null && match.chapterIndex != readerState.currentChapterIndex) {
        readerNotifier.goToChapter(match.chapterIndex!);
      }
    }
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
