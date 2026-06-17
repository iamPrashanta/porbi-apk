// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReaderSettings _$ReaderSettingsFromJson(Map<String, dynamic> json) =>
    ReaderSettings(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      fontFamily: json['fontFamily'] as String? ?? 'Literata',
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.6,
      horizontalMargin: (json['horizontalMargin'] as num?)?.toDouble() ?? 20.0,
      verticalMargin: (json['verticalMargin'] as num?)?.toDouble() ?? 16.0,
      readerTheme:
          $enumDecodeNullable(_$ReaderThemeModeEnumMap, json['readerTheme']) ??
              ReaderThemeMode.light,
      isFullscreen: json['isFullscreen'] as bool? ?? false,
    );

Map<String, dynamic> _$ReaderSettingsToJson(ReaderSettings instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'fontFamily': instance.fontFamily,
      'lineHeight': instance.lineHeight,
      'horizontalMargin': instance.horizontalMargin,
      'verticalMargin': instance.verticalMargin,
      'readerTheme': _$ReaderThemeModeEnumMap[instance.readerTheme]!,
      'isFullscreen': instance.isFullscreen,
    };

const _$ReaderThemeModeEnumMap = {
  ReaderThemeMode.light: 'light',
  ReaderThemeMode.dark: 'dark',
  ReaderThemeMode.sepia: 'sepia',
  ReaderThemeMode.oledBlack: 'oledBlack',
};
