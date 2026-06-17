import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_state.dart';
import 'package:porbi/features/reader/providers/search_provider.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/core/storage/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:markdown/markdown.dart' as md;

class ReaderBody extends StatelessWidget {
  final ReaderState state;
  final SearchState searchState;
  final GlobalKey activeMatchKey;
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
    required this.searchState,
    required this.activeMatchKey,
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

    debugPrint(
      'ReaderBody build '
      'contentLength=${content.length}'
    );

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
          child: SelectableText.rich(
            TextSpan(children: _buildTxtSpans(content, textStyle)),
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
            data: _highlightMarkdown(content),
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
            extensionSet: _createMarkdownExtensionSet(),
            builders: {
              'mark': _MarkElementBuilder(readerTheme, searchState.currentMatchIndex, activeMatchKey),
            },
            onTapLink: (text, href, title) {
              if (href != null) {
                launchUrl(Uri.parse(href));
              }
            },
          ),
        );

      case FileType.html:
      case FileType.epub:
        final highlightedHtml = _highlightHtml(content);
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
            data: highlightedHtml,
            extensions: [
              TagExtension(
                tagsToExtend: {'mark'},
                builder: (extensionContext) {
                  final isActive = extensionContext.classes.contains('search-match-active');
                  final text = extensionContext.element?.text ?? '';
                  final widget = RichText(
                    text: TextSpan(
                      text: text,
                      style: TextStyle(
                        backgroundColor: isActive ? readerTheme.accentColor : Colors.yellow,
                        color: isActive ? readerTheme.backgroundColor : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: preferences.fontSize,
                        fontFamily: preferences.fontFamily,
                      ),
                    ),
                  );

                  if (isActive) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(key: activeMatchKey, width: 0, height: 0),
                        widget,
                      ],
                    );
                  }
                  return widget;
                },
              ),
            ],
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
              'mark': Style(
                backgroundColor: Colors.yellow,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              '.search-match-active': Style(
                backgroundColor: readerTheme.accentColor,
                color: readerTheme.backgroundColor,
                fontWeight: FontWeight.w600,
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

  // ─── Search Highlighting Helpers ──────────────────────────────────

  List<InlineSpan> _buildTxtSpans(String content, TextStyle defaultStyle) {
    if (searchState.query.isEmpty || state.currentChapter?.index != searchState.currentMatch?.chapterIndex) {
      return [TextSpan(text: content, style: defaultStyle)];
    }

    final lowerContent = content.toLowerCase();
    final lowerQuery = searchState.query.toLowerCase();
    final matches = <int>[];
    int idx = 0;
    while (true) {
      idx = lowerContent.indexOf(lowerQuery, idx);
      if (idx == -1) break;
      matches.add(idx);
      idx += lowerQuery.length;
    }

    if (matches.isEmpty) {
      return [TextSpan(text: content, style: defaultStyle)];
    }

    final spans = <InlineSpan>[];
    int currentPos = 0;
    int matchIndexInChapter = 0;

    // We need to know which global match index corresponds to this chapter's matches.
    // Let's find the offset of this chapter's first match.
    int globalMatchOffset = searchState.matches.indexWhere((m) => m.chapterIndex == state.currentChapter?.index);
    if (globalMatchOffset == -1) globalMatchOffset = 0; // Fallback

    for (final matchIdx in matches) {
      if (matchIdx > currentPos) {
        spans.add(TextSpan(text: content.substring(currentPos, matchIdx), style: defaultStyle));
      }
      
      final isCurrent = (globalMatchOffset + matchIndexInChapter) == searchState.currentMatchIndex;
      
      if (isCurrent) {
        spans.add(WidgetSpan(
          child: SizedBox(key: activeMatchKey, width: 0, height: 0),
        ));
      }

      spans.add(TextSpan(
        text: content.substring(matchIdx, matchIdx + searchState.query.length),
        style: defaultStyle.copyWith(
          backgroundColor: isCurrent ? readerTheme.accentColor : Colors.yellow,
          color: isCurrent ? readerTheme.backgroundColor : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ));
      
      currentPos = matchIdx + searchState.query.length;
      matchIndexInChapter++;
    }

    if (currentPos < content.length) {
      spans.add(TextSpan(text: content.substring(currentPos), style: defaultStyle));
    }

    return spans;
  }

  String _highlightHtml(String htmlString) {
    if (searchState.query.isEmpty || state.currentChapter?.index != searchState.currentMatch?.chapterIndex) {
      return htmlString;
    }

    try {
      final doc = html_parser.parseFragment(htmlString);
      final lowerQuery = searchState.query.toLowerCase();
      
      int globalMatchOffset = searchState.matches.indexWhere((m) => m.chapterIndex == state.currentChapter?.index);
      if (globalMatchOffset == -1) globalMatchOffset = 0;
      
      int matchIndexInChapter = 0;

      void traverse(dom.Node node) {
        if (node.nodeType == dom.Node.TEXT_NODE) {
          final text = node.text;
          if (text != null && text.toLowerCase().contains(lowerQuery)) {
            final parent = node.parentNode;
            if (parent != null && parent is dom.Element && parent.localName != 'mark') {
              final lowerText = text.toLowerCase();
              final parts = <dom.Node>[];
              int currentPos = 0;
              int idx = 0;

              while (true) {
                idx = lowerText.indexOf(lowerQuery, idx);
                if (idx == -1) break;

                if (idx > currentPos) {
                  parts.add(dom.Text(text.substring(currentPos, idx)));
                }

                final isCurrent = (globalMatchOffset + matchIndexInChapter) == searchState.currentMatchIndex;
                final markNode = dom.Element.tag('mark');
                if (isCurrent) {
                  markNode.classes.add('search-match-active');
                  // We can't inject a flutter GlobalKey into a pure HTML string here. 
                  // But we can add an ID to the active mark!
                  markNode.attributes['id'] = 'active-search-match';
                }
                markNode.text = text.substring(idx, idx + searchState.query.length);
                parts.add(markNode);

                currentPos = idx + searchState.query.length;
                idx += searchState.query.length;
                matchIndexInChapter++;
              }

              if (currentPos < text.length) {
                parts.add(dom.Text(text.substring(currentPos)));
              }

              // Replace the original text node with the new parts
              final nodeIndex = parent.nodes.indexOf(node);
              if (nodeIndex != -1) {
                parent.nodes.removeAt(nodeIndex);
                parent.nodes.insertAll(nodeIndex, parts);
              }
            }
          }
        } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
          final element = node as dom.Element;
          // Don't traverse inside already injected mark tags or scripts
          if (element.localName != 'mark' && element.localName != 'script' && element.localName != 'style') {
            for (var child in element.nodes.toList()) {
              traverse(child);
            }
          }
        }
      }

      for (var child in doc.nodes.toList()) {
        traverse(child);
      }
      return doc.outerHtml;
    } catch (e) {
      debugPrint('Failed to highlight HTML: $e');
      return htmlString;
    }
  }

  String _highlightMarkdown(String markdownString) {
    if (searchState.query.isEmpty || state.currentChapter?.index != searchState.currentMatch?.chapterIndex) {
      return markdownString;
    }
    // Very basic fallback since flutter_markdown doesn't support complex text node splitting easily.
    // Actually, we can use the same regex replacement logic and wrap with `<mark>` 
    // because flutter_markdown supports inline HTML if extensionSet allows it!
    // But standard MarkdownBody drops unknown HTML tags like <mark>.
    // So we use custom ==highlight== syntax.
    final lowerQuery = searchState.query.toLowerCase();
    int idx = 0;
    int globalMatchOffset = searchState.matches.indexWhere((m) => m.chapterIndex == state.currentChapter?.index);
    if (globalMatchOffset == -1) globalMatchOffset = 0;
    int matchIndexInChapter = 0;

    final buffer = StringBuffer();
    int currentPos = 0;
    final lowerContent = markdownString.toLowerCase();

    while (true) {
      idx = lowerContent.indexOf(lowerQuery, idx);
      if (idx == -1) break;

      if (idx > currentPos) {
        buffer.write(markdownString.substring(currentPos, idx));
      }

      final isCurrent = (globalMatchOffset + matchIndexInChapter) == searchState.currentMatchIndex;
      final matchText = markdownString.substring(idx, idx + searchState.query.length);
      
      final tag = isCurrent ? '[mark:active]' : '[mark]';
      buffer.write('$tag$matchText[/mark]');

      currentPos = idx + searchState.query.length;
      idx += searchState.query.length;
      matchIndexInChapter++;
    }

    if (currentPos < markdownString.length) {
      buffer.write(markdownString.substring(currentPos));
    }

    return buffer.toString();
  }

  md.ExtensionSet _createMarkdownExtensionSet() {
    return md.ExtensionSet(
      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
      [
        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        _MarkInlineSyntax(),
      ],
    );
  }
}

class _MarkInlineSyntax extends md.InlineSyntax {
  _MarkInlineSyntax() : super(r'\[mark(:active)?\](.*?)\[/mark\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final isActive = match[1] == ':active';
    final text = match[2]!;
    final el = md.Element.text('mark', text);
    if (isActive) el.attributes['class'] = 'active';
    parser.addNode(el);
    return true;
  }
}

class _MarkElementBuilder extends MarkdownElementBuilder {
  final ReaderThemeConfig theme;
  final int currentIndex;
  final GlobalKey activeMatchKey;

  _MarkElementBuilder(this.theme, this.currentIndex, this.activeMatchKey);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final isActive = element.attributes['class'] == 'active';
    final textWidget = RichText(
      text: TextSpan(
        text: element.textContent,
        style: preferredStyle?.copyWith(
          backgroundColor: isActive ? theme.accentColor : Colors.yellow,
          color: isActive ? theme.backgroundColor : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (isActive) {
      // Wrap in a widget with the global key so we can scroll to it
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(key: activeMatchKey, width: 0, height: 0),
          textWidget,
        ],
      );
    }

    return textWidget;
  }
}

