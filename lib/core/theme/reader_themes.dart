import 'package:flutter/material.dart';
import 'package:porbi/models/reader_settings.dart';
import 'package:porbi/core/theme/app_theme.dart';

class ReaderThemes {
  ReaderThemes._();

  static ReaderThemeConfig getTheme(ReaderThemeMode mode) {
    switch (mode) {
      case ReaderThemeMode.light:
        return lightReaderTheme;
      case ReaderThemeMode.dark:
        return darkReaderTheme;
      case ReaderThemeMode.sepia:
        return sepiaReaderTheme;
      case ReaderThemeMode.oledBlack:
        return oledReaderTheme;
    }
  }

  static const ReaderThemeConfig lightReaderTheme = ReaderThemeConfig(
    name: 'Light',
    backgroundColor: Color(0xFFFAFAFA),
    textColor: Color(0xFF2D2D2D),
    secondaryTextColor: Color(0xFF757575),
    accentColor: AppColors.primaryPurple,
    selectionColor: Color(0x406C3CE1),
    highlightColor: Color(0xFFFFEB3B),
    icon: Icons.light_mode,
  );

  static const ReaderThemeConfig darkReaderTheme = ReaderThemeConfig(
    name: 'Dark',
    backgroundColor: Color(0xFF1E1E2A),
    textColor: Color(0xFFE0E0E0),
    secondaryTextColor: Color(0xFF9E9E9E),
    accentColor: AppColors.accentTeal,
    selectionColor: Color(0x4026C6DA),
    highlightColor: Color(0xFF66BB6A),
    icon: Icons.dark_mode,
  );

  static const ReaderThemeConfig sepiaReaderTheme = ReaderThemeConfig(
    name: 'Sepia',
    backgroundColor: AppColors.sepiaBackground,
    textColor: AppColors.sepiaText,
    secondaryTextColor: Color(0xFF8D7B6B),
    accentColor: Color(0xFF8B6914),
    selectionColor: Color(0x408B6914),
    highlightColor: Color(0xFFD4A017),
    icon: Icons.auto_stories,
  );

  static const ReaderThemeConfig oledReaderTheme = ReaderThemeConfig(
    name: 'OLED Black',
    backgroundColor: AppColors.oledBackground,
    textColor: AppColors.oledText,
    secondaryTextColor: Color(0xFF666666),
    accentColor: Color(0xFF7C4DFF),
    selectionColor: Color(0x407C4DFF),
    highlightColor: Color(0xFF4CAF50),
    icon: Icons.brightness_1,
  );
}

class ReaderThemeConfig {
  final String name;
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final Color selectionColor;
  final Color highlightColor;
  final IconData icon;

  const ReaderThemeConfig({
    required this.name,
    required this.backgroundColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.selectionColor,
    required this.highlightColor,
    required this.icon,
  });
}
