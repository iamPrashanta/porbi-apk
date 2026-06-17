import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/core/utils/date_utils.dart';
import 'package:porbi/features/library/providers/library_provider.dart';
import 'package:porbi/models/book.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(sortedLibraryBooksProvider);
    final viewMode = ref.watch(libraryViewProvider);
    final sortMode = ref.watch(librarySortProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Library'),
            actions: [
              // Sort button
              PopupMenuButton<LibrarySort>(
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Sort',
                onSelected: (sort) {
                  ref.read(librarySortProvider.notifier).state = sort;
                },
                itemBuilder: (context) => [
                  _sortMenuItem(
                    'Name',
                    LibrarySort.name,
                    sortMode,
                    Icons.sort_by_alpha_rounded,
                  ),
                  _sortMenuItem(
                    'Date Added',
                    LibrarySort.date,
                    sortMode,
                    Icons.calendar_today_rounded,
                  ),
                  _sortMenuItem(
                    'Recent',
                    LibrarySort.recent,
                    sortMode,
                    Icons.access_time_rounded,
                  ),
                ],
              ),
              // View toggle
              IconButton(
                icon: Icon(
                  viewMode == LibraryView.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                ),
                tooltip: viewMode == LibraryView.grid
                    ? 'List View'
                    : 'Grid View',
                onPressed: () {
                  ref
                      .read(libraryViewProvider.notifier)
                      .state = viewMode == LibraryView.grid
                      ? LibraryView.list
                      : LibraryView.grid;
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          booksAsync.when(
            data: (books) {
              if (books.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books in library',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (viewMode == LibraryView.grid) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _BookGridItem(book: books[index], ref: ref),
                      childCount: books.length,
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _BookListItem(book: books[index], ref: ref),
                      childCount: books.length,
                    ),
                  ),
                );
              }
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final notifier = ref.read(libraryNotifierProvider.notifier);
          final book = await notifier.importFile();
          if (book != null && context.mounted) {
            context.push('/reader/${book.id}');
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Import'),
      ),
    );
  }

  PopupMenuItem<LibrarySort> _sortMenuItem(
    String label,
    LibrarySort value,
    LibrarySort current,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
          if (current == value) ...[
            const Spacer(),
            const Icon(Icons.check_rounded, size: 18),
          ],
        ],
      ),
    );
  }
}

// ─── Grid Item ────────────────────────────────────────────────

class _BookGridItem extends StatelessWidget {
  final Book book;
  final WidgetRef ref;

  const _BookGridItem({required this.book, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: theme.cardTheme.color,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/reader/${book.id}'),
        onLongPress: () => _showContextMenu(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getFileTypeColor(
                    book.fileType,
                  ).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getFileTypeIcon(book.fileType),
                  color: _getFileTypeColor(book.fileType),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Expanded(
                child: Text(
                  book.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Meta
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    book.fileType.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  if (book.isFavorite)
                    const Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                ],
              ),

              // Progress
              if (book.readingProgress > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: book.readingProgress,
                    minHeight: 3,
                    backgroundColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.08,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryPurple,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                book.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
              ),
              title: Text(
                book.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              ),
              onTap: () {
                ref
                    .read(libraryNotifierProvider.notifier)
                    .toggleFavorite(book.id);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Delete "${book.title}" from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(libraryNotifierProvider.notifier).deleteBook(book);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── List Item ────────────────────────────────────────────────

class _BookListItem extends StatelessWidget {
  final Book book;
  final WidgetRef ref;

  const _BookListItem({required this.book, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: theme.cardTheme.color,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/reader/${book.id}'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getFileTypeColor(
                      book.fileType,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getFileTypeIcon(book.fileType),
                    color: _getFileTypeColor(book.fileType),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            book.fileType.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          if (book.lastOpened != null) ...[
                            Text(
                              ' · ${AppDateUtils.formatRelative(book.lastOpened!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (book.readingProgress > 0)
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: book.readingProgress,
                          strokeWidth: 3,
                          backgroundColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.08),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryPurple,
                          ),
                        ),
                        Text(
                          '${(book.readingProgress * 100).toInt()}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (book.isFavorite) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.favorite_rounded,
                    size: 18,
                    color: AppColors.error,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────

IconData _getFileTypeIcon(FileType type) {
  switch (type) {
    case FileType.txt:
      return Icons.description_rounded;
    case FileType.markdown:
      return Icons.code_rounded;
    case FileType.epub:
      return Icons.auto_stories_rounded;
    case FileType.html:
      return Icons.language_rounded;
  }
}

Color _getFileTypeColor(FileType type) {
  switch (type) {
    case FileType.txt:
      return const Color(0xFF4A90D9);
    case FileType.markdown:
      return const Color(0xFF26C6DA);
    case FileType.epub:
      return AppColors.primaryPurple;
    case FileType.html:
      return const Color(0xFFFF7043);
  }
}
