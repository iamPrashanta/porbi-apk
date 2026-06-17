import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:porbi/core/constants/app_constants.dart';
import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/bookmarks/providers/bookmarks_provider.dart';
import 'package:porbi/features/reader/providers/notes_provider.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/models/reader_settings.dart';
import 'package:porbi/providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookId;

  const ReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showControls = true;
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  List<int> _searchResults = [];
  int _currentSearchIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(readerProvider.notifier).loadBook(widget.bookId);
    });

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        ref.read(readerProvider.notifier).updateScrollPosition(_scrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (!_showControls) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readerProvider);
    final settings = ref.watch(readerSettingsProvider);
    final readerTheme = ReaderThemes.getTheme(settings.readerTheme);

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

    final chapter = state.currentChapter;
    if (chapter == null) {
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

    // Try to restore scroll offset when jumping to a chapter that was previously saved
    if (_scrollController.hasClients && state.scrollPosition > 0 && _scrollController.offset == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && _scrollController.position.maxScrollExtent >= state.scrollPosition) {
          _scrollController.jumpTo(state.scrollPosition);
        }
      });
    }

    return Scaffold(
      backgroundColor: readerTheme.backgroundColor,
      body: Stack(
        children: [
          // ─── Reader Content ────────────────────────────────
          GestureDetector(
            onTap: _toggleControls,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: settings.horizontalMargin,
                vertical: settings.verticalMargin,
              ),
              child: SafeArea(
                child: _buildReaderContent(
                  state,
                  settings,
                  readerTheme,
                  chapter.content,
                ),
              ),
            ),
          ),

          // ─── Top Controls ──────────────────────────────────
          if (_showControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(state, readerTheme),
            ),

          // ─── Bottom Controls ───────────────────────────────
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(state, settings, readerTheme),
            ),

          // ─── Search Bar ────────────────────────────────────
          if (_showSearch)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 16,
              right: 16,
              child: _buildSearchBar(readerTheme),
            ),
        ],
      ),
    );
  }

  Widget _buildReaderContent(
    ReaderState state,
    ReaderSettings settings,
    ReaderThemeConfig readerTheme,
    String content,
  ) {
    final book = state.book;
    if (book == null) return const SizedBox.shrink();

    final textStyle = TextStyle(
      fontFamily: settings.fontFamily,
      fontSize: settings.fontSize,
      height: settings.lineHeight,
      color: readerTheme.textColor,
    );

    switch (book.fileType) {
      case FileType.txt:
        return SelectableText(
          content,
          style: textStyle,
          scrollPhysics: const BouncingScrollPhysics(),
          contextMenuBuilder: (context, editableState) {
            return _buildTextSelectionMenu(context, editableState, state);
          },
        );

      case FileType.markdown:
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: textStyle,
              h1: textStyle.copyWith(
                fontSize: settings.fontSize * 1.8,
                fontWeight: FontWeight.w800,
              ),
              h2: textStyle.copyWith(
                fontSize: settings.fontSize * 1.5,
                fontWeight: FontWeight.w700,
              ),
              h3: textStyle.copyWith(
                fontSize: settings.fontSize * 1.3,
                fontWeight: FontWeight.w600,
              ),
              h4: textStyle.copyWith(
                fontSize: settings.fontSize * 1.1,
                fontWeight: FontWeight.w600,
              ),
              code: textStyle.copyWith(
                fontFamily: 'monospace',
                fontSize: settings.fontSize * 0.85,
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.06),
              ),
              codeblockDecoration: BoxDecoration(
                color: readerTheme.textColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              blockquoteDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: readerTheme.accentColor, width: 3),
                ),
              ),
              blockquotePadding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              tableHead: textStyle.copyWith(fontWeight: FontWeight.w600),
              tableBody: textStyle,
              tableBorder: TableBorder.all(
                color: readerTheme.textColor.withValues(alpha: 0.2),
                width: 1,
              ),
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: readerTheme.textColor.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
              listBullet: textStyle,
              a: textStyle.copyWith(
                color: readerTheme.accentColor,
                decoration: TextDecoration.underline,
              ),
            ),
            onTapLink: (text, href, title) {
              if (href != null) {
                launchUrl(Uri.parse(href));
              }
            },
          ),
        );

      case FileType.epub:
      case FileType.html:
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Html(
            data: content,
            style: {
              'body': Style(
                fontFamily: settings.fontFamily,
                fontSize: FontSize(settings.fontSize),
                lineHeight: LineHeight(settings.lineHeight),
                color: readerTheme.textColor,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              'h1': Style(
                fontSize: FontSize(settings.fontSize * 1.8),
                fontWeight: FontWeight.w800,
                color: readerTheme.textColor,
              ),
              'h2': Style(
                fontSize: FontSize(settings.fontSize * 1.5),
                fontWeight: FontWeight.w700,
                color: readerTheme.textColor,
              ),
              'h3': Style(
                fontSize: FontSize(settings.fontSize * 1.3),
                fontWeight: FontWeight.w600,
                color: readerTheme.textColor,
              ),
              'a': Style(color: readerTheme.accentColor),
              'code': Style(
                fontFamily: 'monospace',
                fontSize: FontSize(settings.fontSize * 0.85),
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.06),
              ),
              'pre': Style(
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.06),
                padding: HtmlPaddings.all(12),
              ),
              'blockquote': Style(
                border: Border(
                  left: BorderSide(color: readerTheme.accentColor, width: 3),
                ),
                padding: HtmlPaddings.only(left: 16),
                margin: Margins.symmetric(vertical: 8),
              ),
              'img': Style(width: Width(100, Unit.percent)),
            },
            onLinkTap: (url, _, _) {
              if (url != null) {
                launchUrl(Uri.parse(url));
              }
            },
          ),
        );
    }
  }

  Widget _buildTextSelectionMenu(
    BuildContext context,
    EditableTextState editableState,
    ReaderState state,
  ) {
    final anchors = editableState.contextMenuAnchors;
    final selectedText = editableState.textEditingValue.text.substring(
      editableState.textEditingValue.selection.start,
      editableState.textEditingValue.selection.end,
    );

    return AdaptiveTextSelectionToolbar(
      anchors: anchors,
      children: [
        _SelectionMenuItem(
          icon: Icons.copy_rounded,
          label: 'Copy',
          onTap: () {
            Clipboard.setData(ClipboardData(text: selectedText));
            editableState.hideToolbar();
          },
        ),
        _SelectionMenuItem(
          icon: Icons.bookmark_add_rounded,
          label: 'Bookmark',
          onTap: () {
            _addBookmark(state, selectedText);
            editableState.hideToolbar();
          },
        ),
        _SelectionMenuItem(
          icon: Icons.note_add_rounded,
          label: 'Note',
          onTap: () {
            _addNote(state, selectedText);
            editableState.hideToolbar();
          },
        ),
      ],
    );
  }

  Widget _buildTopBar(ReaderState state, ReaderThemeConfig readerTheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            readerTheme.backgroundColor,
            readerTheme.backgroundColor.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: readerTheme.textColor,
                ),
                onPressed: () {
                  ref.read(readerProvider.notifier).saveProgressOnExit();
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  context.pop();
                },
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.book?.title ?? '',
                      style: TextStyle(
                        color: readerTheme.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.currentChapter != null)
                      Text(
                        state.currentChapter!.title,
                        style: TextStyle(
                          color: readerTheme.secondaryTextColor,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.search_rounded, color: readerTheme.textColor),
                onPressed: () => setState(() => _showSearch = !_showSearch),
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark_add_outlined,
                  color: readerTheme.textColor,
                ),
                onPressed: () => _addBookmark(state, null),
              ),
              IconButton(
                icon: Icon(Icons.menu_rounded, color: readerTheme.textColor),
                onPressed: () => _showChapterDrawer(state, readerTheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    ReaderState state,
    ReaderSettings settings,
    ReaderThemeConfig readerTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            readerTheme.backgroundColor,
            readerTheme.backgroundColor.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chapter navigation
              if (state.chapters.length > 1)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: state.hasPreviousChapter
                            ? readerTheme.textColor
                            : readerTheme.textColor.withValues(alpha: 0.3),
                      ),
                      onPressed: state.hasPreviousChapter
                          ? () {
                              ref
                                  .read(readerProvider.notifier)
                                  .previousChapter();
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          : null,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                              activeTrackColor: readerTheme.accentColor,
                              inactiveTrackColor: readerTheme.textColor
                                  .withValues(alpha: 0.12),
                              thumbColor: readerTheme.accentColor,
                            ),
                            child: Slider(
                              value: state.currentChapterIndex.toDouble(),
                              min: 0,
                              max: (state.chapters.length - 1).toDouble().clamp(
                                0,
                                double.infinity,
                              ),
                              divisions: state.chapters.length > 1
                                  ? state.chapters.length - 1
                                  : null,
                              onChanged: (value) {
                                ref
                                    .read(readerProvider.notifier)
                                    .goToChapter(value.toInt());
                              },
                            ),
                          ),
                          Text(
                            '${state.currentChapterIndex + 1} of ${state.chapters.length}',
                            style: TextStyle(
                              color: readerTheme.secondaryTextColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: state.hasNextChapter
                            ? readerTheme.textColor
                            : readerTheme.textColor.withValues(alpha: 0.3),
                      ),
                      onPressed: state.hasNextChapter
                          ? () {
                              ref.read(readerProvider.notifier).nextChapter();
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          : null,
                    ),
                  ],
                ),

              // Bottom action bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomAction(
                    icon: Icons.format_size_rounded,
                    label: 'Settings',
                    color: readerTheme.textColor,
                    onTap: () => _showReaderSettings(readerTheme),
                  ),
                  _BottomAction(
                    icon: Icons.bookmark_outline_rounded,
                    label: 'Bookmarks',
                    color: readerTheme.textColor,
                    onTap: () => _showBookmarks(state, readerTheme),
                  ),
                  _BottomAction(
                    icon: Icons.note_outlined,
                    label: 'Notes',
                    color: readerTheme.textColor,
                    onTap: () => _showNotes(state, readerTheme),
                  ),
                  _BottomAction(
                    icon: settings.isFullscreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    label: 'Fullscreen',
                    color: readerTheme.textColor,
                    onTap: () {
                      ref
                          .read(readerSettingsProvider.notifier)
                          .toggleFullscreen();
                    },
                  ),
                ],
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

  void _showChapterDrawer(ReaderState state, ReaderThemeConfig readerTheme) {
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
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
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

  void _showReaderSettings(ReaderThemeConfig readerTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ReaderSettingsSheet(readerTheme: readerTheme),
    );
  }

  void _addBookmark(ReaderState state, String? excerpt) {
    if (state.book == null) return;

    final title = 'Ch. ${state.currentChapterIndex + 1}';
    ref
        .read(bookmarksNotifierProvider.notifier)
        .addBookmark(
          bookId: state.book!.id,
          position: state.currentChapterIndex,
          title: title,
          chapterIndex: state.currentChapterIndex,
          excerpt: excerpt,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bookmark added'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _addNote(ReaderState state, String selectedText) {
    if (state.book == null) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"$selectedText"',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your note...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref
                      .read(notesNotifierProvider.notifier)
                      .addNote(
                        bookId: state.book!.id,
                        selectedText: selectedText,
                        noteContent: controller.text,
                        position: state.currentChapterIndex,
                        chapterIndex: state.currentChapterIndex,
                      );
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showBookmarks(ReaderState state, ReaderThemeConfig readerTheme) {
    if (state.book == null) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final bookmarks = ref.watch(bookBookmarksProvider(state.book!.id));
          return Column(
            mainAxisSize: MainAxisSize.min,
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
                  'Bookmarks',
                  style: TextStyle(
                    color: readerTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              bookmarks.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No bookmarks yet',
                        style: TextStyle(color: readerTheme.secondaryTextColor),
                      ),
                    );
                  }
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final bookmark = items[index];
                        return ListTile(
                          leading: Icon(
                            Icons.bookmark_rounded,
                            color: readerTheme.accentColor,
                          ),
                          title: Text(
                            bookmark.title,
                            style: TextStyle(color: readerTheme.textColor),
                          ),
                          subtitle: bookmark.excerpt != null
                              ? Text(
                                  bookmark.excerpt!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: readerTheme.secondaryTextColor,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: readerTheme.secondaryTextColor,
                              size: 20,
                            ),
                            onPressed: () {
                              ref
                                  .read(bookmarksNotifierProvider.notifier)
                                  .deleteBookmark(bookmark.id);
                            },
                          ),
                          onTap: () {
                            ref
                                .read(readerProvider.notifier)
                                .goToChapter(bookmark.position);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Error: $e'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _showNotes(ReaderState state, ReaderThemeConfig readerTheme) {
    if (state.book == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: readerTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final notes = ref.watch(bookNotesProvider(state.book!.id));
          return Column(
            mainAxisSize: MainAxisSize.min,
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
                  'Notes',
                  style: TextStyle(
                    color: readerTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              notes.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No notes yet.\nSelect text to add a note.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: readerTheme.secondaryTextColor),
                      ),
                    );
                  }
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final note = items[index];
                        return ListTile(
                          leading: Icon(
                            Icons.sticky_note_2_rounded,
                            color: readerTheme.accentColor,
                          ),
                          title: Text(
                            note.noteContent,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: readerTheme.textColor),
                          ),
                          subtitle: Text(
                            '"${note.selectedText}"',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: readerTheme.secondaryTextColor,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: readerTheme.secondaryTextColor,
                              size: 20,
                            ),
                            onPressed: () {
                              ref
                                  .read(notesNotifierProvider.notifier)
                                  .deleteNote(note.id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Error: $e'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

// ─── Reader Settings Sheet ──────────────────────────────────

class _ReaderSettingsSheet extends ConsumerWidget {
  final ReaderThemeConfig readerTheme;

  const _ReaderSettingsSheet({required this.readerTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    final notifier = ref.watch(readerSettingsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: readerTheme.textColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Reader Settings',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),

          // Font Size
          _SettingRow(
            label: 'Font Size',
            value: '${settings.fontSize.toInt()}',
            readerTheme: readerTheme,
            child: Slider(
              value: settings.fontSize,
              min: AppConstants.minFontSize,
              max: AppConstants.maxFontSize,
              onChanged: notifier.updateFontSize,
              activeColor: readerTheme.accentColor,
            ),
          ),

          // Line Height
          _SettingRow(
            label: 'Line Height',
            value: settings.lineHeight.toStringAsFixed(1),
            readerTheme: readerTheme,
            child: Slider(
              value: settings.lineHeight,
              min: AppConstants.minLineHeight,
              max: AppConstants.maxLineHeight,
              onChanged: notifier.updateLineHeight,
              activeColor: readerTheme.accentColor,
            ),
          ),

          // Margin
          _SettingRow(
            label: 'Margin',
            value: '${settings.horizontalMargin.toInt()}',
            readerTheme: readerTheme,
            child: Slider(
              value: settings.horizontalMargin,
              min: AppConstants.minMargin,
              max: AppConstants.maxMargin,
              onChanged: notifier.updateHorizontalMargin,
              activeColor: readerTheme.accentColor,
            ),
          ),

          const SizedBox(height: 16),

          // Font Family
          Text(
            'Font Family',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.availableFonts.length,
              itemBuilder: (context, index) {
                final font = AppConstants.availableFonts[index];
                final isSelected = font == settings.fontFamily;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(font),
                    selected: isSelected,
                    onSelected: (_) => notifier.updateFontFamily(font),
                    selectedColor: readerTheme.accentColor.withValues(
                      alpha: 0.2,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? readerTheme.accentColor
                          : readerTheme.textColor,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? readerTheme.accentColor
                          : readerTheme.textColor.withValues(alpha: 0.15),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Theme
          Text(
            'Reader Theme',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ReaderThemeMode.values.map((mode) {
              final theme = ReaderThemes.getTheme(mode);
              final isSelected = mode == settings.readerTheme;
              return GestureDetector(
                onTap: () => notifier.updateReaderTheme(mode),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? readerTheme.accentColor
                              : readerTheme.textColor.withValues(alpha: 0.15),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Aa',
                          style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? readerTheme.accentColor
                            : readerTheme.secondaryTextColor,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;
  final ReaderThemeConfig readerTheme;
  final Widget child;

  const _SettingRow({
    required this.label,
    required this.value,
    required this.readerTheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: readerTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: readerTheme.secondaryTextColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SelectionMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
