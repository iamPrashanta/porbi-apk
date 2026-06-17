import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/search_provider.dart';
import 'package:porbi/features/reader/widgets/reader_search_sheet.dart';

class ReaderSearchOverlay extends ConsumerStatefulWidget {
  final ReaderThemeConfig readerTheme;
  final VoidCallback onClose;

  const ReaderSearchOverlay({
    super.key,
    required this.readerTheme,
    required this.onClose,
  });

  @override
  ConsumerState<ReaderSearchOverlay> createState() => _ReaderSearchOverlayState();
}

class _ReaderSearchOverlayState extends ConsumerState<ReaderSearchOverlay> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchProvider).query;
    _controller = TextEditingController(text: initialQuery);
    
    if (initialQuery.isEmpty) {
      // Auto focus if opened fresh
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = widget.readerTheme;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: theme.backgroundColor.withValues(alpha: 0.95),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.textColor.withValues(alpha: 0.1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(color: theme.textColor, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search in document...',
                      hintStyle: TextStyle(color: theme.secondaryTextColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      isDense: true,
                    ),
                    onChanged: (val) {
                      ref.read(searchProvider.notifier).performSearch(val);
                    },
                    onSubmitted: (val) {
                      ref.read(searchProvider.notifier).performSearch(val);
                      _focusNode.unfocus();
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear_rounded, color: theme.secondaryTextColor, size: 20),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchProvider.notifier).fullClear();
                      _focusNode.requestFocus();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: theme.textColor, size: 22),
                  onPressed: () {
                    ref.read(searchProvider.notifier).fullClear();
                    widget.onClose();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (searchState.isSearching)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: LinearProgressIndicator(
                  backgroundColor: theme.textColor.withValues(alpha: 0.1),
                  color: theme.accentColor,
                  minHeight: 2,
                ),
              )
            else if (searchState.query.isNotEmpty && !searchState.isSearching)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: searchState.matches.isEmpty ? null : () {
                        _showSearchSheet(context, theme);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          searchState.matches.isEmpty 
                              ? '0 matches' 
                              : '${searchState.currentMatchIndex + 1} / ${searchState.matches.length} matches',
                          style: TextStyle(
                            color: searchState.matches.isEmpty 
                                ? theme.secondaryTextColor 
                                : theme.accentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up_rounded, color: searchState.matches.isEmpty ? theme.secondaryTextColor : theme.textColor),
                      onPressed: searchState.matches.isEmpty 
                          ? null 
                          : () {
                              _focusNode.unfocus();
                              ref.read(searchProvider.notifier).previousMatch();
                            },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: searchState.matches.isEmpty ? theme.secondaryTextColor : theme.textColor),
                      onPressed: searchState.matches.isEmpty 
                          ? null 
                          : () {
                              _focusNode.unfocus();
                              ref.read(searchProvider.notifier).nextMatch();
                            },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSearchSheet(BuildContext context, ReaderThemeConfig theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ReaderSearchSheet(readerTheme: theme),
    );
  }
}
