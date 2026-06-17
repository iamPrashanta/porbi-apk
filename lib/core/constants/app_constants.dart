class AppConstants {
  AppConstants._();

  static const String appName = 'Porbi';
  static const String appTagline = 'Read Anything, Anywhere';
  static const String publisher = 'Cloud Grips Tech';
  static const String appVersion = '1.0.0';

  static const int defaultPageSize = 4000;
  static const int searchResultContextLength = 80;
  static const int maxRecentFiles = 10;

  static const List<String> supportedExtensions = [
    '.txt',
    '.md',
    '.markdown',
    '.epub',
    '.html',
    '.htm',
  ];

  static const List<String> availableFonts = [
    'Literata',
    'Roboto',
    'Open Sans',
    'Merriweather',
    'Lora',
    'Source Serif Pro',
    'Noto Sans',
    'Inter',
  ];

  static const double minFontSize = 10.0;
  static const double maxFontSize = 32.0;
  static const double minLineHeight = 1.0;
  static const double maxLineHeight = 3.0;
  static const double minMargin = 4.0;
  static const double maxMargin = 48.0;
}
