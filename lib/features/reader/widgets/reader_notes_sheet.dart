import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';
import 'package:porbi/features/reader/providers/notes_provider.dart';

class ReaderNotesSheet extends ConsumerWidget {
  final ReaderThemeConfig readerTheme;

  const ReaderNotesSheet({super.key, required this.readerTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readerProvider);
    if (state.book == null) return const SizedBox.shrink();

    final notes = ref.watch(bookNotesProvider(state.book!.id));
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
              'Notes',
              style: TextStyle(
                color: readerTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            notes.when(
              data: (items) {
                if (items.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 48,
                            color: readerTheme.textColor.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Notes',
                            style: TextStyle(
                              color: readerTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select text while reading to add a note.',
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
                            ref.read(notesNotifierProvider.notifier).deleteNote(note.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Expanded(
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
