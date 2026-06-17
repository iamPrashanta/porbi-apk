import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/theme/reader_themes.dart';

class ReaderProgressSheet extends ConsumerStatefulWidget {
  final ReaderThemeConfig readerTheme;
  final ScrollController scrollController;

  const ReaderProgressSheet({
    super.key,
    required this.readerTheme,
    required this.scrollController,
  });

  @override
  ConsumerState<ReaderProgressSheet> createState() => _ReaderProgressSheetState();
}

class _ReaderProgressSheetState extends ConsumerState<ReaderProgressSheet> {
  double _currentProgress = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _updateProgress();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isDragging) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    if (!widget.scrollController.hasClients) return;
    
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    
    if (maxScroll <= 0) return;

    setState(() {
      _currentProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = widget.readerTheme;
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
              color: theme.textColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Reading Progress',
            style: TextStyle(
              color: theme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          if (widget.scrollController.hasClients && widget.scrollController.position.maxScrollExtent > 0)
            Column(
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
                    activeTrackColor: theme.accentColor,
                    inactiveTrackColor: theme.textColor.withValues(alpha: 0.12),
                    thumbColor: theme.accentColor,
                  ),
                  child: Slider(
                    value: _currentProgress,
                    min: 0.0,
                    max: 1.0,
                    onChangeStart: (_) => setState(() => _isDragging = true),
                    onChanged: (value) {
                      setState(() => _currentProgress = value);
                      final maxScroll = widget.scrollController.position.maxScrollExtent;
                      widget.scrollController.jumpTo(value * maxScroll);
                    },
                    onChangeEnd: (_) => setState(() => _isDragging = false),
                  ),
                ),
                Text(
                  '${(_currentProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: theme.secondaryTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 48,
                      color: theme.textColor.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Progress',
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Progress is not available for this document.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}
