import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:porbi/features/reader/providers/reader_preferences_provider.dart';
import 'package:porbi/features/reader/providers/search_provider.dart';

class ReaderBottomDock extends ConsumerWidget {
  final ReaderState state;
  final ReaderPreferencesData preferences;
  final ReaderThemeConfig readerTheme;
  final VoidCallback onShowSettings;
  final VoidCallback onShowBookmarks;
  final VoidCallback onShowNotes;
  final VoidCallback onShowProgress;
  final bool isVisible;

  const ReaderBottomDock({
    super.key,
    required this.state,
    required this.preferences,
    required this.readerTheme,
    required this.onShowSettings,
    required this.onShowBookmarks,
    required this.onShowNotes,
    required this.onShowProgress,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      bottom: isVisible ? safeBottom + 16 : -100, // Slide down to hide
      left: 24,
      right: 24,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isVisible ? 1.0 : 0.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: readerTheme.backgroundColor.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: readerTheme.textColor.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DockAction(
                    icon: Icons.search_rounded,
                    label: 'Search',
                    color: readerTheme.textColor,
                    onTap: () {
                      final searchState = ref.read(searchProvider);
                      final searchNotifier = ref.read(searchProvider.notifier);
                      if (searchState.searchResultsVisible) {
                        searchNotifier.hideSearch();
                      } else {
                        searchNotifier.showSearch();
                      }
                    },
                  ),
                  _DockAction(
                    icon: Icons.bookmark_outline_rounded,
                    label: 'Bookmarks',
                    color: readerTheme.textColor,
                    onTap: onShowBookmarks,
                  ),
                  _DockAction(
                    icon: Icons.note_outlined,
                    label: 'Notes',
                    color: readerTheme.textColor,
                    onTap: onShowNotes,
                  ),
                  _DockAction(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    color: readerTheme.textColor,
                    onTap: onShowSettings,
                  ),
                  _DockAction(
                    icon: preferences.fullscreenEnabled
                        ? Icons.center_focus_strong_rounded
                        : Icons.filter_center_focus_rounded,
                    label: 'Focus',
                    color: readerTheme.textColor,
                    onTap: () {
                      ref.read(readerPreferencesProvider.notifier).toggleFullscreen();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DockAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
