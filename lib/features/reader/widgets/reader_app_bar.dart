import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';

class ReaderAppBar extends ConsumerWidget {
  final ReaderState state;
  final ReaderThemeConfig readerTheme;
  final VoidCallback onToggleSearch;
  final VoidCallback onShowChapters;
  final VoidCallback onAddBookmark;
  final VoidCallback onBackPressed;
  final bool isVisible;

  const ReaderAppBar({
    super.key,
    required this.state,
    required this.readerTheme,
    required this.onToggleSearch,
    required this.onShowChapters,
    required this.onAddBookmark,
    required this.onBackPressed,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      top: isVisible ? 0 : -100, // Slide up to hide
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.0,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: readerTheme.backgroundColor.withValues(alpha: 0.85),
                border: Border(
                  bottom: BorderSide(
                    color: readerTheme.textColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: readerTheme.textColor,
                        ),
                        onPressed: onBackPressed,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.book?.title ?? '',
                              style: TextStyle(
                                color: readerTheme.textColor,
                                fontSize: 16,
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
                        onPressed: onToggleSearch,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_add_outlined,
                          color: readerTheme.textColor,
                        ),
                        onPressed: onAddBookmark,
                      ),
                      IconButton(
                        icon: Icon(Icons.menu_rounded, color: readerTheme.textColor),
                        onPressed: onShowChapters,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
