import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/features/reader/providers/reader_provider.dart';

class ReaderProgressSheet extends ConsumerWidget {
  final ReaderThemeConfig readerTheme;

  const ReaderProgressSheet({super.key, required this.readerTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readerProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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
            'Reading Progress',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          if (state.chapters.length > 1)
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: state.hasPreviousChapter
                        ? readerTheme.textColor
                        : readerTheme.textColor.withValues(alpha: 0.3),
                  ),
                  onPressed: state.hasPreviousChapter
                      ? () {
                          ref.read(readerProvider.notifier).previousChapter();
                        }
                      : null,
                ),
                Expanded(
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                          activeTrackColor: readerTheme.accentColor,
                          inactiveTrackColor:
                              readerTheme.textColor.withValues(alpha: 0.12),
                          thumbColor: readerTheme.accentColor,
                        ),
                        child: Slider(
                          value: state.currentChapterIndex.toDouble(),
                          min: 0,
                          max: (state.chapters.length - 1)
                              .toDouble()
                              .clamp(0, double.infinity),
                          divisions: state.chapters.length > 1
                              ? state.chapters.length - 1
                              : null,
                          onChanged: (value) {
                            ref
                                .read(readerProvider.notifier)
                                .goToChapter(value.toInt());
                          },
                        ),
                      ),
                      Text(
                        '${state.currentChapterIndex + 1} of ${state.chapters.length}',
                        style: TextStyle(
                          color: readerTheme.secondaryTextColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: state.hasNextChapter
                        ? readerTheme.textColor
                        : readerTheme.textColor.withValues(alpha: 0.3),
                  ),
                  onPressed: state.hasNextChapter
                      ? () {
                          ref.read(readerProvider.notifier).nextChapter();
                        }
                      : null,
                ),
              ],
            )
          else
            Text(
              'No chapters available.',
              style: TextStyle(color: readerTheme.secondaryTextColor),
            ),
        ],
      ),
    );
  }
}
