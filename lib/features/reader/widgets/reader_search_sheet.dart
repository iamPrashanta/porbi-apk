import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/search_provider.dart';

class ReaderSearchSheet extends ConsumerWidget {
  final ReaderThemeConfig readerTheme;

  const ReaderSearchSheet({super.key, required this.readerTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
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
              'Search Results',
              style: TextStyle(
                color: readerTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (searchState.matches.isEmpty)
              SizedBox(
                height: minHeight - 80,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: readerTheme.textColor.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Matches Found',
                        style: TextStyle(
                          color: readerTheme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchState.matches.length,
                  itemBuilder: (context, index) {
                    final match = searchState.matches[index];
                    final isActive = index == searchState.currentMatchIndex;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      tileColor: isActive ? readerTheme.accentColor.withValues(alpha: 0.1) : Colors.transparent,
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive 
                              ? readerTheme.accentColor.withValues(alpha: 0.2) 
                              : readerTheme.textColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? readerTheme.accentColor : readerTheme.secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        match.chapterTitle ?? 'Chapter ${(match.chapterIndex ?? 0) + 1}',
                        style: TextStyle(
                          color: isActive ? readerTheme.accentColor : readerTheme.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: _highlightMatchPreview(match.previewText, searchState.query, readerTheme, isActive),
                      ),
                      onTap: () {
                        ref.read(searchProvider.notifier).goToMatch(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _highlightMatchPreview(String text, String query, ReaderThemeConfig theme, bool isActive) {
    if (query.isEmpty) return Text(text, style: TextStyle(color: theme.secondaryTextColor, fontSize: 13));

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matches = <int>[];
    int idx = 0;
    while (true) {
      idx = lowerText.indexOf(lowerQuery, idx);
      if (idx == -1) break;
      matches.add(idx);
      idx += query.length;
    }

    if (matches.isEmpty) {
      return Text(text, style: TextStyle(color: theme.secondaryTextColor, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis);
    }

    final spans = <TextSpan>[];
    int currentPos = 0;

    for (final matchIdx in matches) {
      if (matchIdx > currentPos) {
        spans.add(TextSpan(text: text.substring(currentPos, matchIdx)));
      }
      spans.add(TextSpan(
        text: text.substring(matchIdx, matchIdx + query.length),
        style: TextStyle(
          color: isActive ? theme.backgroundColor : Colors.black,
          backgroundColor: isActive ? theme.accentColor : Colors.yellow,
          fontWeight: FontWeight.w600,
        ),
      ));
      currentPos = matchIdx + query.length;
    }

    if (currentPos < text.length) {
      spans.add(TextSpan(text: text.substring(currentPos)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: theme.secondaryTextColor, fontSize: 13, height: 1.4),
        children: spans,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
