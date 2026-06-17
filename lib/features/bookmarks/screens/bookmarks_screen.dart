import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/features/bookmarks/providers/bookmarks_provider.dart';
import 'package:porbi/providers/database_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allBookmarksAsync = ref.watch(allBookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Bookmarks')),
      body: allBookmarksAsync.when(
        data: (bookmarksByBook) {
          if (bookmarksByBook.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add bookmarks while reading\nto quickly return to them later.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: bookmarksByBook.length,
            itemBuilder: (context, index) {
              final bookId = bookmarksByBook.keys.elementAt(index);
              final bookmarks = bookmarksByBook[bookId]!;

              return _BookBookmarksGroup(
                bookId: bookId,
                bookmarks: bookmarks,
                ref: ref,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _BookBookmarksGroup extends ConsumerWidget {
  final String bookId;
  final List<dynamic> bookmarks;
  final WidgetRef ref;

  const _BookBookmarksGroup({
    required this.bookId,
    required this.bookmarks,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);

    return FutureBuilder(
      future: db.getBookById(bookId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final book = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  book.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookmarks.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.bookmark_rounded,
                        color: AppColors.primaryPurple,
                      ),
                      title: Text(
                        bookmark.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: bookmark.excerpt != null
                          ? Text(
                              bookmark.excerpt!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, size: 20),
                            onPressed: () =>
                                _showRenameDialog(context, bookmark),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: AppColors.error.withValues(alpha: 0.8),
                            ),
                            onPressed: () {
                              ref
                                  .read(bookmarksNotifierProvider.notifier)
                                  .deleteBookmark(bookmark.id);
                              // We should invalidate the provider to refresh the UI
                              ref.invalidate(allBookmarksProvider);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        context.push('/reader/${book.id}');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, dynamic bookmark) {
    final controller = TextEditingController(text: bookmark.title);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Bookmark'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(bookmarksNotifierProvider.notifier)
                    .renameBookmark(bookmark.id, controller.text.trim());
                ref.invalidate(allBookmarksProvider);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
