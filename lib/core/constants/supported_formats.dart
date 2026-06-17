import 'package:porbi/models/book.dart';

class SupportedFormats {
  SupportedFormats._();

  static const Map<String, FileType> extensionMap = {
    '.txt': FileType.txt,
    '.md': FileType.markdown,
    '.markdown': FileType.markdown,
    '.epub': FileType.epub,
    '.html': FileType.html,
    '.htm': FileType.html,
  };

  static const Map<FileType, String> mimeTypes = {
    FileType.txt: 'text/plain',
    FileType.markdown: 'text/markdown',
    FileType.epub: 'application/epub+zip',
    FileType.html: 'text/html',
  };

  static FileType? getTypeForExtension(String extension) {
    return extensionMap[extension.toLowerCase()];
  }

  static bool isSupported(String extension) {
    return extensionMap.containsKey(extension.toLowerCase());
  }

  static List<String> get allExtensions => extensionMap.keys.toList();
}
