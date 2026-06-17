import 'package:path/path.dart' as p;
import 'package:porbi/core/constants/supported_formats.dart';
import 'package:porbi/models/book.dart';

class FileUtils {
  FileUtils._();

  /// Get file extension from path (lowercase, with dot).
  static String getExtension(String filePath) {
    return p.extension(filePath).toLowerCase();
  }

  /// Determine FileType from file path.
  static FileType? getFileType(String filePath) {
    final ext = getExtension(filePath);
    return SupportedFormats.getTypeForExtension(ext);
  }

  /// Check if a file extension is supported.
  static bool isSupported(String filePath) {
    final ext = getExtension(filePath);
    return SupportedFormats.isSupported(ext);
  }

  /// Get file name without extension.
  static String getBaseName(String filePath) {
    return p.basenameWithoutExtension(filePath);
  }

  /// Format file size in human-readable form.
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Normalize a title to help deduplicate files.
  static String normalizeTitle(String title) {
    var normalized = title.toLowerCase();
    
    // Remove extensions
    final extensions = ['.md', '.markdown', '.txt', '.epub', '.html', '.htm'];
    for (final ext in extensions) {
      if (normalized.endsWith(ext)) {
        normalized = normalized.substring(0, normalized.length - ext.length);
        break;
      }
    }
    
    // Replace non-alphanumeric with empty
    normalized = normalized.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return normalized.trim();
  }

  /// Extract original SAF URI from a Book's fileHash.
  static String? getOriginalUri(Book book) {
    final hash = book.fileHash;
    if (hash == null) return null;
    if (hash.contains('|')) {
      return hash.split('|').first;
    }
    if (hash.startsWith('content://')) {
      return hash;
    }
    return null;
  }

  /// Extract content hash from a Book's fileHash.
  static String? getContentHash(Book book) {
    final hash = book.fileHash;
    if (hash == null) return null;
    if (hash.contains('|')) {
      return hash.split('|').last;
    }
    if (hash.startsWith('content://')) {
      return null;
    }
    return hash;
  }
}
