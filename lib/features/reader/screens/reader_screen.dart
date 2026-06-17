import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/bookmarks/providers/bookmarks_provider.dart';
import 'package:porbi/features/reader/providers/notes_provider.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';
import 'package:porbi/features/reader/providers/reader_preferences_provider.dart';
import 'package:porbi/models/reader_settings.dart';
import 'package:porbi/features/reader/services/reader_scroll_service.dart';
import 'package:porbi/features/reader/widgets/reader_app_bar.dart';
import 'package:porbi/features/reader/widgets/reader_body.dart';
import 'package:porbi/features/reader/widgets/reader_bottom_dock.dart';
import 'package:porbi/features/reader/widgets/reader_progress_sheet.dart';
import 'package:porbi/features/reader/widgets/reader_settings_sheet.dart';
import 'package:porbi/features/reader/widgets/reader_bookmarks_sheet.dart';
import 'package:porbi/features/reader/widgets/reader_notes_sheet.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookId;

  const ReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ReaderScrollService _scrollService = ReaderScrollService();
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  List<int> _searchResults = [];
  int _currentSearchIndex = 0;
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(readerProvider.notifier).loadBook(widget.bookId);
    });

    _scrollService.addVisibilityListener(() {
      setState(() {});
    });

    _scrollService.scrollController.addListener(() {
      if (_scrollService.scrollController.hasClients) {
        if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();
        _scrollDebounce = Timer(const Duration(milliseconds: 500), () {
          if (mounted && _scrollService.scrollController.hasClients) {
            ref.read(readerProvider.notifier).saveScrollPositionToDb(
                  _scrollService.scrollController.offset,
                );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _scrollService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSingleTap() {
    _scrollService.toggleVisibility();
    if (!_scrollService.isVisible) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _handleDoubleTap() {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Image Zoom TBD')),
    // );
  }

  void _handleBack() {
    final state = ref.read(readerProvider);
    final currentOffset = _scrollService.scrollController.hasClients
        ? _scrollService.scrollController.offset
        : state.scrollPosition;
    ref.read(readerProvider.notifier).saveProgressOnExit(currentOffset);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readerProvider);
    final prefsState = ref.watch(readerPreferencesProvider);

    if (prefsState.isLoading || prefsState.preferences == null) {
      if (prefsState.error != null) {
        return Scaffold(
          body: Center(
            child: Text('Failed to load preferences: ${prefsState.error}', style: const TextStyle(color: Colors.red)),
          ),
        );
      }
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final prefs = prefsState.preferences!;
    final themeMode = ReaderThemeMode.values.firstWhere(
      (e) => e.name == prefs.themeMode,
      orElse: () => ReaderThemeMode.light,
    );
    final readerTheme = ReaderThemes.getTheme(themeMode);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: readerTheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: readerTheme.accentColor),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(color: readerTheme.secondaryTextColor),
              ),
            ],
          ),
        ),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: readerTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: readerTheme.textColor,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                state.error!,
                style: TextStyle(color: readerTheme.textColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.currentChapter == null) {
      return Scaffold(
        backgroundColor: readerTheme.backgroundColor,
        body: Center(
          child: Text(
            'No content',
            style: TextStyle(color: readerTheme.secondaryTextColor),
          ),
        ),
      );
    }

    // Restore scroll offset
    if (_scrollService.scrollController.hasClients &&
        state.scrollPosition > 0 &&
        _scrollService.scrollController.offset == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollService.scrollController.hasClients &&
            _scrollService.scrollController.position.maxScrollExtent >=
                state.scrollPosition) {
          _scrollService.scrollController.jumpTo(state.scrollPosition);
        }
      });
    }

    final safeTop = MediaQuery.viewPaddingOf(context).top;
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    
    // We reserve generous space for our UI components so content never underlaps
    const appBarHeight = 64.0;
    const dockHeight = 80.0;
    
    final topInset = safeTop + appBarHeight;
    final bottomInset = safeBottom + dockHeight;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;

        final currentOffset = _scrollService.scrollController.hasClients
            ? _scrollService.scrollController.offset
            : state.scrollPosition;
        ref.read(readerProvider.notifier).saveProgressOnExit(currentOffset);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      },
      child: Scaffold(
        backgroundColor: readerTheme.backgroundColor,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              // ─── Reader Content ────────────────────────────────
              RawGestureDetector(
                gestures: {
                  TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                    () => TapGestureRecognizer(),
                    (TapGestureRecognizer instance) {
                      instance.onTap = _handleSingleTap;
                    },
                  ),
                  DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
                    () => DoubleTapGestureRecognizer(),
                    (DoubleTapGestureRecognizer instance) {
                      instance.onDoubleTap = _handleDoubleTap;
                    },
                  ),
                },
                child: SizedBox.expand(
                  child: ReaderBody(
                    state: state,
                    preferences: prefs,
                    readerTheme: readerTheme,
                    scrollController: _scrollService.scrollController,
                    topInset: topInset,
                    bottomInset: bottomInset,
                    onAddBookmark: (text) => _addBookmark(text),
                    onAddNote: (text) => _addNote(text),
                  ),
                ),
              ),


              // ─── Top Controls ──────────────────────────────────
              ReaderAppBar(
                state: state,
                readerTheme: readerTheme,
                isVisible: _scrollService.isVisible,
                onToggleSearch: () => setState(() => _showSearch = !_showSearch),
                onShowChapters: () => _showChapterDrawer(readerTheme),
                onAddBookmark: () => _addBookmark(null),
                onBackPressed: _handleBack,
              ),

              // ─── Bottom Dock ───────────────────────────────
              ReaderBottomDock(
                state: state,
                preferences: prefs,
                readerTheme: readerTheme,
                isVisible: _scrollService.isVisible,
                onShowSettings: () => _showReaderSettings(readerTheme),
                onShowBookmarks: () => _showBookmarks(readerTheme),
                onShowNotes: () => _showNotes(readerTheme),
                onShowProgress: () => _showProgressSheet(readerTheme),
              ),

              // ─── Search Bar ────────────────────────────────────
              if (_showSearch)
                Positioned(
                  top: topInset + 8,
                  left: 16,
                  right: 16,
                  child: _buildSearchBar(readerTheme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ReaderThemeConfig readerTheme) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      color: readerTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: readerTheme.textColor),
                decoration: InputDecoration(
                  hintText: 'Search in document...',
                  hintStyle: TextStyle(color: readerTheme.secondaryTextColor),
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: (query) => _performSearch(query),
              ),
            ),
            if (_searchResults.isNotEmpty)
              Text(
                '${_currentSearchIndex + 1}/${_searchResults.length}',
                style: TextStyle(
                  color: readerTheme.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: readerTheme.textColor,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _showSearch = false;
                  _searchController.clear();
                  _searchResults = [];
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    final state = ref.read(readerProvider);
    final chapter = state.currentChapter;
    if (chapter == null) return;

    final content = chapter.content.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final results = <int>[];

    int index = 0;
    while (true) {
      index = content.indexOf(lowerQuery, index);
      if (index == -1) break;
      results.add(index);
      index += lowerQuery.length;
    }

    setState(() {
      _searchResults = results;
      _currentSearchIndex = 0;
    });

    if (results.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${results.length} results'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _addBookmark(String? excerpt) {
    final state = ref.read(readerProvider);
    if (state.book == null) return;

    final defaultTitle = 'Ch. ${state.currentChapterIndex + 1}';
    final readerTheme = ReaderThemes.getTheme(
      ReaderThemeMode.values.firstWhere(
        (e) => e.name == ref.read(readerPreferencesProvider).preferences?.themeMode,
        orElse: () => ReaderThemeMode.light,
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final titleController = TextEditingController(text: defaultTitle);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Bookmark', style: TextStyle(color: readerTheme.textColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: TextStyle(color: readerTheme.textColor),
                decoration: InputDecoration(
                  labelText: 'Bookmark Title',
                  labelStyle: TextStyle(color: readerTheme.secondaryTextColor),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: readerTheme.secondaryTextColor.withValues(alpha: 0.5))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: readerTheme.accentColor)),
                ),
              ),
              const SizedBox(height: 16),
              if (excerpt != null) ...[
                Text('Excerpt', style: TextStyle(color: readerTheme.secondaryTextColor, fontSize: 12)),
                const SizedBox(height: 4),
                Text('"$excerpt"', style: TextStyle(color: readerTheme.textColor, fontStyle: FontStyle.italic), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Cancel', style: TextStyle(color: readerTheme.secondaryTextColor)),
                  ),
                  FilledButton(
                    onPressed: () {
                      ref.read(bookmarksNotifierProvider.notifier).addBookmark(
                            bookId: state.book!.id,
                            position: state.currentChapterIndex,
                            title: titleController.text.isEmpty ? defaultTitle : titleController.text,
                            chapterIndex: state.currentChapterIndex,
                            excerpt: excerpt,
                          );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bookmark added'), duration: Duration(seconds: 1)));
                    },
                    style: FilledButton.styleFrom(backgroundColor: readerTheme.accentColor),
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _addNote(String selectedText) {
    final state = ref.read(readerProvider);
    if (state.book == null) return;

    final readerTheme = ReaderThemes.getTheme(
      ReaderThemeMode.values.firstWhere(
        (e) => e.name == ref.read(readerPreferencesProvider).preferences?.themeMode,
        orElse: () => ReaderThemeMode.light,
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Note', style: TextStyle(color: readerTheme.textColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: readerTheme.textColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"$selectedText"',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: readerTheme.secondaryTextColor),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                style: TextStyle(color: readerTheme.textColor),
                decoration: InputDecoration(
                  hintText: 'Write your note...',
                  hintStyle: TextStyle(color: readerTheme.secondaryTextColor),
                  border: OutlineInputBorder(borderSide: BorderSide(color: readerTheme.secondaryTextColor.withValues(alpha: 0.5))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: readerTheme.secondaryTextColor.withValues(alpha: 0.3))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: readerTheme.accentColor)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Cancel', style: TextStyle(color: readerTheme.secondaryTextColor)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        ref.read(notesNotifierProvider.notifier).addNote(
                              bookId: state.book!.id,
                              selectedText: selectedText,
                              noteContent: controller.text,
                              position: state.currentChapterIndex,
                              chapterIndex: state.currentChapterIndex,
                            );
                      }
                      Navigator.pop(ctx);
                    },
                    style: FilledButton.styleFrom(backgroundColor: readerTheme.accentColor),
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showChapterDrawer(ReaderThemeConfig readerTheme) {
    final state = ref.read(readerProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: readerTheme.textColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Chapters',
                  style: TextStyle(
                    color: readerTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = state.chapters[index];
                    final isActive = index == state.currentChapterIndex;
                    return ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive
                              ? readerTheme.accentColor.withValues(alpha: 0.15)
                              : readerTheme.textColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive
                                ? readerTheme.accentColor
                                : readerTheme.secondaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      title: Text(
                        chapter.title,
                        style: TextStyle(
                          color: isActive
                              ? readerTheme.accentColor
                              : readerTheme.textColor,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        ref.read(readerProvider.notifier).goToChapter(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showProgressSheet(ReaderThemeConfig readerTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ReaderProgressSheet(
        readerTheme: readerTheme,
        scrollController: _scrollService.scrollController,
      ),
    );
  }

  void _showReaderSettings(ReaderThemeConfig readerTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ReaderSettingsSheet(readerTheme: readerTheme),
    );
  }

  void _showBookmarks(ReaderThemeConfig readerTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ReaderBookmarksSheet(readerTheme: readerTheme),
    );
  }

  void _showNotes(ReaderThemeConfig readerTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ReaderNotesSheet(readerTheme: readerTheme),
    );
  }
}
