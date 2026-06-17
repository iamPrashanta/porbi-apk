import 'package:json_annotation/json_annotation.dart';

part 'reader_settings.g.dart';

enum ReaderThemeMode { light, dark, sepia, oledBlack }

extension ReaderThemeModeExtension on ReaderThemeMode {
  String get displayName {
    switch (this) {
      case ReaderThemeMode.light:
        return 'Light';
      case ReaderThemeMode.dark:
        return 'Dark';
      case ReaderThemeMode.sepia:
        return 'Sepia';
      case ReaderThemeMode.oledBlack:
        return 'OLED Black';
    }
  }
}

@JsonSerializable()
class ReaderSettings {
  final double fontSize;
  final String fontFamily;
  final double lineHeight;
  final double horizontalMargin;
  final double verticalMargin;
  final ReaderThemeMode readerTheme;
  final bool isFullscreen;

  const ReaderSettings({
    this.fontSize = 16.0,
    this.fontFamily = 'Literata',
    this.lineHeight = 1.6,
    this.horizontalMargin = 20.0,
    this.verticalMargin = 16.0,
    this.readerTheme = ReaderThemeMode.light,
    this.isFullscreen = false,
  });

  ReaderSettings copyWith({
    double? fontSize,
    String? fontFamily,
    double? lineHeight,
    double? horizontalMargin,
    double? verticalMargin,
    ReaderThemeMode? readerTheme,
    bool? isFullscreen,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineHeight: lineHeight ?? this.lineHeight,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      verticalMargin: verticalMargin ?? this.verticalMargin,
      readerTheme: readerTheme ?? this.readerTheme,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }

  factory ReaderSettings.fromJson(Map<String, dynamic> json) =>
      _$ReaderSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ReaderSettingsToJson(this);
}
