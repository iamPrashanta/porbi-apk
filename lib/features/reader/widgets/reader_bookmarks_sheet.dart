import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';
import 'package:porbi/features/bookmarks/providers/bookmarks_provider.dart';

class ReaderBookmarksSheet extends ConsumerWidget {
  final ReaderThemeConfig readerTheme;

  const ReaderBookmarksSheet({super.key, required this.readerTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readerProvider);
    if (state.book == null) return const SizedBox.shrink();

    final bookmarks = ref.watch(bookBookmarksProvider(state.book!.id));
    final minHeight = MediaQuery.sizeOf(context).height * 0.45;

    return SafeArea(
      bottom: true,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
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
              'Bookmarks',
              style: TextStyle(
                color: readerTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            bookmarks.when(
              data: (items) {
                if (items.isEmpty) {
                  return SizedBox(
                    height: minHeight - 80,
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_outline_rounded,
                            size: 48,
                            color: readerTheme.textColor.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Bookmarks',
                            style: TextStyle(
                              color: readerTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add bookmarks while reading to easily find them here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: readerTheme.secondaryTextColor),
                          ),
                        ],
                      ),
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
                            ref.read(bookmarksNotifierProvider.notifier).deleteBookmark(bookmark.id);
                          },
                        ),
                        onTap: () {
                          ref.read(readerProvider.notifier).goToChapter(bookmark.position);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => SizedBox(
                height: minHeight - 80,
                width: double.infinity,
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SizedBox(
                height: minHeight - 80,
                width: double.infinity,
                child: Center(
                  child: Text('Error: $e', style: TextStyle(color: readerTheme.textColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
