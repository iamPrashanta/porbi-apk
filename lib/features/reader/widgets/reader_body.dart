import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_state.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:url_launcher/url_launcher.dart';

class ReaderBody extends StatelessWidget {
  final ReaderState state;
  final ReaderPreferencesData preferences;
  final ReaderThemeConfig readerTheme;
  final ScrollController scrollController;
  final double topInset;
  final double bottomInset;
  final Function(String) onAddBookmark;
  final Function(String) onAddNote;

  const ReaderBody({
    super.key,
    required this.state,
    required this.preferences,
    required this.readerTheme,
    required this.scrollController,
    required this.topInset,
    required this.bottomInset,
    required this.onAddBookmark,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    final book = state.book;
    final chapter = state.currentChapter;
    
    if (book == null || chapter == null) {
      return Center(
        child: Text(
          'No content',
          style: TextStyle(color: readerTheme.secondaryTextColor),
        ),
      );
    }

    final content = chapter.content;

    // Use a polished line height
    final double polishedLineHeight = preferences.lineHeight.clamp(1.55, 1.75);

    final textStyle = TextStyle(
      fontFamily: preferences.fontFamily,
      fontSize: preferences.fontSize,
      height: polishedLineHeight,
      color: readerTheme.textColor,
    );

    switch (book.fileType) {
      case FileType.txt:
        return SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            preferences.horizontalMargin,
            topInset + preferences.horizontalMargin, // Wait, horizontal margin as vertical margin too? Let's use horizontal margin or 24
            preferences.horizontalMargin,
            bottomInset + preferences.horizontalMargin,
          ),
          child: SelectableText(
            content,
            style: textStyle,
            contextMenuBuilder: (context, editableState) {
              return _buildTextSelectionMenu(context, editableState);
            },
          ),
        );

      case FileType.markdown:
        return SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            preferences.horizontalMargin,
            topInset + 24.0, // using a fixed vertical margin
            preferences.horizontalMargin,
            bottomInset + 24.0,
          ),
          child: MarkdownBody(
            data: content,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: textStyle,
              pPadding: const EdgeInsets.only(bottom: 16),
              h1: textStyle.copyWith(
                fontSize: preferences.fontSize * 1.8,
                fontWeight: FontWeight.w800,
              ),
              h1Padding: const EdgeInsets.only(top: 48, bottom: 24),
              h2: textStyle.copyWith(
                fontSize: preferences.fontSize * 1.5,
                fontWeight: FontWeight.w700,
              ),
              h2Padding: const EdgeInsets.only(top: 36, bottom: 16),
              h3: textStyle.copyWith(
                fontSize: preferences.fontSize * 1.3,
                fontWeight: FontWeight.w600,
              ),
              h3Padding: const EdgeInsets.only(top: 24, bottom: 12),
              h4: textStyle.copyWith(
                fontSize: preferences.fontSize * 1.1,
                fontWeight: FontWeight.w600,
              ),
              code: textStyle.copyWith(
                fontFamily: 'monospace',
                fontSize: preferences.fontSize * 0.85,
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.06),
              ),
              codeblockDecoration: BoxDecoration(
                color: readerTheme.textColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              codeblockPadding: const EdgeInsets.all(16),
              blockquoteDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: readerTheme.accentColor, width: 4),
                ),
                color: readerTheme.textColor.withValues(alpha: 0.03),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              blockquotePadding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
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
              listIndent: 24,
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
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            preferences.horizontalMargin,
            topInset + 24.0,
            preferences.horizontalMargin,
            bottomInset + 24.0,
          ),
          child: Html(
            data: content,
            style: {
              'body': Style(
                fontFamily: preferences.fontFamily,
                fontSize: FontSize(preferences.fontSize),
                lineHeight: LineHeight(polishedLineHeight),
                color: readerTheme.textColor,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              'h1': Style(
                fontSize: FontSize(preferences.fontSize * 1.8),
                fontWeight: FontWeight.w800,
                color: readerTheme.textColor,
                margin: Margins.only(top: 48, bottom: 24),
              ),
              'h2': Style(
                fontSize: FontSize(preferences.fontSize * 1.5),
                fontWeight: FontWeight.w700,
                color: readerTheme.textColor,
                margin: Margins.only(top: 36, bottom: 16),
              ),
              'h3': Style(
                fontSize: FontSize(preferences.fontSize * 1.3),
                fontWeight: FontWeight.w600,
                color: readerTheme.textColor,
                margin: Margins.only(top: 24, bottom: 12),
              ),
              'p': Style(
                margin: Margins.only(bottom: 16),
              ),
              'a': Style(color: readerTheme.accentColor),
              'code': Style(
                fontFamily: 'monospace',
                fontSize: FontSize(preferences.fontSize * 0.85),
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.06),
              ),
              'pre': Style(
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.06),
                padding: HtmlPaddings.all(16),
                margin: Margins.only(bottom: 16),
              ),
              'blockquote': Style(
                border: Border(
                  left: BorderSide(color: readerTheme.accentColor, width: 4),
                ),
                padding: HtmlPaddings.only(left: 20, top: 16, bottom: 16, right: 16),
                margin: Margins.symmetric(vertical: 16),
                backgroundColor: readerTheme.textColor.withValues(alpha: 0.03),
              ),
              'img': Style(
                width: Width(100, Unit.percent),
                margin: Margins.symmetric(vertical: 24),
              ),
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
  ) {
    final anchors = editableState.contextMenuAnchors;
    final selectedText = editableState.textEditingValue.text.substring(
      editableState.textEditingValue.selection.start,
      editableState.textEditingValue.selection.end,
    );

    return AdaptiveTextSelectionToolbar(
      anchors: anchors,
      children: [
        TextButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: selectedText));
            editableState.hideToolbar();
          },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('Copy'),
        ),
        TextButton.icon(
          onPressed: () {
            onAddBookmark(selectedText);
            editableState.hideToolbar();
          },
          icon: const Icon(Icons.bookmark_add_rounded, size: 18),
          label: const Text('Bookmark'),
        ),
        TextButton.icon(
          onPressed: () {
            onAddNote(selectedText);
            editableState.hideToolbar();
          },
          icon: const Icon(Icons.note_add_rounded, size: 18),
          label: const Text('Note'),
        ),
      ],
    );
  }
}
