import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/constants/app_constants.dart';
import 'package:porbi/core/theme/reader_themes.dart';
import 'package:porbi/models/reader_settings.dart';
import 'package:porbi/features/reader/providers/reader_preferences_provider.dart';

class ReaderSettingsSheet extends ConsumerWidget {
  final ReaderThemeConfig readerTheme;

  const ReaderSettingsSheet({super.key, required this.readerTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readerPreferencesProvider);
    final notifier = ref.read(readerPreferencesProvider.notifier);

    if (state.isLoading || state.preferences == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final prefs = state.preferences!;

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
            'Reader Settings',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),

          // Font Size
          _SettingRow(
            label: 'Font Size',
            value: '${prefs.fontSize.toInt()}',
            readerTheme: readerTheme,
            child: Slider(
              value: prefs.fontSize,
              min: AppConstants.minFontSize,
              max: AppConstants.maxFontSize,
              onChanged: notifier.updateFontSize,
              onChangeEnd: notifier.saveFontSize,
              activeColor: readerTheme.accentColor,
            ),
          ),

          // Line Height
          _SettingRow(
            label: 'Line Height',
            value: prefs.lineHeight.toStringAsFixed(1),
            readerTheme: readerTheme,
            child: Slider(
              value: prefs.lineHeight,
              min: AppConstants.minLineHeight,
              max: AppConstants.maxLineHeight,
              onChanged: notifier.updateLineHeight,
              onChangeEnd: notifier.saveLineHeight,
              activeColor: readerTheme.accentColor,
            ),
          ),

          // Margin
          _SettingRow(
            label: 'Margin',
            value: '${prefs.horizontalMargin.toInt()}',
            readerTheme: readerTheme,
            child: Slider(
              value: prefs.horizontalMargin,
              min: AppConstants.minMargin,
              max: AppConstants.maxMargin,
              onChanged: notifier.updateMargin,
              onChangeEnd: notifier.saveMargin,
              activeColor: readerTheme.accentColor,
            ),
          ),

          const SizedBox(height: 16),

          // Font Family
          Text(
            'Font Family',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: readerTheme.textColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: readerTheme.textColor.withValues(alpha: 0.1),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: prefs.fontFamily,
                isExpanded: true,
                dropdownColor: readerTheme.backgroundColor,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: readerTheme.textColor),
                itemHeight: 64,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    notifier.updateFontFamily(newValue);
                  }
                },
                items: AppConstants.availableFonts.map<DropdownMenuItem<String>>((String font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            font,
                            style: TextStyle(
                              fontFamily: 'System',
                              fontSize: 11,
                              color: readerTheme.secondaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'The quick brown fox...',
                            style: TextStyle(
                              fontFamily: font == 'System' ? null : font,
                              fontSize: 18,
                              color: readerTheme.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Theme
          Text(
            'Reader Theme',
            style: TextStyle(
              color: readerTheme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ReaderThemeMode.values.map((mode) {
              final theme = ReaderThemes.getTheme(mode);
              final isSelected = mode.name == prefs.themeMode;
              return GestureDetector(
                onTap: () => notifier.updateThemeMode(mode.name),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? readerTheme.accentColor
                              : readerTheme.textColor.withValues(alpha: 0.15),
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Aa',
                          style: TextStyle(
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? readerTheme.accentColor
                            : readerTheme.secondaryTextColor,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;
  final ReaderThemeConfig readerTheme;
  final Widget child;

  const _SettingRow({
    required this.label,
    required this.value,
    required this.readerTheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: readerTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: readerTheme.secondaryTextColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}
