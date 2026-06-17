import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:porbi/core/constants/supported_formats.dart';
import 'package:porbi/models/book.dart' as models;
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

final fileServiceProvider = Provider<FileService>((ref) => FileService());

class FileService {
  static const _uuid = Uuid();
  static const _channel = MethodChannel('com.porbi.apk/content');

  /// Pick a file using the system file picker.
  Future<File?> pickFile() async {
    try {
      if (Platform.isAndroid) {
        // Use custom native picker for robust SAF support
        final uriString = await _channel.invokeMethod<String>('pickFile');
        if (uriString == null) return null;
        
        debugPrint('Picked file URI via custom intent: $uriString');
        
        // Copy content URI to local cache
        final copiedPath = await _channel.invokeMethod<String>('copyContentUri', {'uri': uriString});
        if (copiedPath != null) {
          debugPrint('Copied file path from custom intent URI: $copiedPath');
          final tempFile = File(copiedPath);
          
          // Verify extension
          final ext = p.extension(copiedPath).toLowerCase().replaceAll('.', '');
          final allowed = ['txt', 'md', 'markdown', 'epub', 'html', 'htm'];
          if (!allowed.contains(ext)) {
            // Android often loses the extension during copy if not resolved from metadata, 
            // but the copyContentUri method queries OpenableColumns.DISPLAY_NAME which preserves it.
            if (ext.isNotEmpty) {
               // We only throw if it definitely has a bad extension.
               // Sometimes no extension is retrieved, so we let it pass to parsing.
               // We will just let the caller handle format errors if any.
            }
          }
          return tempFile;
        }
        return null;
      }

      // Fallback for non-Android platforms
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.single;
      final path = file.path;
      final bytes = file.bytes;
      final name = file.name;
      final ext = p.extension(name).toLowerCase().replaceAll('.', '');
      
      debugPrint('Picked file:');
      debugPrint('Name: $name');
      debugPrint('Extension: $ext');
      debugPrint('Path: $path');
      debugPrint('Bytes available: ${bytes != null ? bytes.length : 0}');

      final allowed = ['txt', 'md', 'markdown', 'epub', 'html', 'htm'];
      if (!allowed.contains(ext) && ext.isNotEmpty) {
        throw UnsupportedError('File type .$ext is not supported');
      }

      // If bytes are available, write to temporary cache
      if (bytes != null) {
        final cacheDir = await getTemporaryDirectory();
        final importDir = Directory(p.join(cacheDir.path, 'imports'));
        if (!await importDir.exists()) {
          await importDir.create(recursive: true);
        }
        final tempFile = File(p.join(importDir.path, name));
        await tempFile.writeAsBytes(bytes);
        debugPrint('Copied file path from bytes: ${tempFile.path}');
        return tempFile;
      }

      // If no bytes but path exists and is content://
      if (path != null && path.startsWith('content://')) {
        final copiedPath = await _channel.invokeMethod<String>('copyContentUri', {'uri': path});
        if (copiedPath != null) {
          debugPrint('Copied file path from URI: $copiedPath');
          return File(copiedPath);
        }
      }

      // If path is a normal file
      if (path != null) {
        final localFile = File(path);
        if (await localFile.exists()) {
          return localFile;
        }
      }

      throw Exception('Failed to retrieve file content or path');
    } catch (e) {
      debugPrint('Error picking file: $e');
      rethrow;
    }
  }

  /// Hash a file using SHA256.
  Future<String> hashFile(File file) async {
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  /// Import a file into the app's documents directory.
  Future<models.Book> importFile(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDir.path, 'books'));
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }

    final ext = p.extension(sourceFile.path).toLowerCase();
    final fileType = SupportedFormats.getTypeForExtension(ext);

    if (fileType == null) {
      throw UnsupportedError('File type $ext is not supported');
    }

    final id = _uuid.v4();
    final fileName = '${id}_${p.basename(sourceFile.path)}';
    final destPath = p.join(booksDir.path, fileName);

    // Calculate SHA256 Hash via Stream
    final digest = await sha256.bind(sourceFile.openRead()).first;
    final fileHash = digest.toString();
    
    final fileSize = await sourceFile.length();
    
    final destFile = await sourceFile.copy(destPath);

    final title = _extractTitle(sourceFile.path);

    return models.Book(
      id: id,
      title: title,
      filePath: destFile.path,
      fileType: fileType,
      fileSize: fileSize,
      fileHash: fileHash,
      addedAt: DateTime.now(),
    );
  }

  /// Import a file from a content URI (Android intent).
  Future<File?> importFromUri(String uri) async {
    try {
      debugPrint('Incoming URI: $uri');
      if (uri.startsWith('content://')) {
        final result = await _channel.invokeMethod<String>('copyContentUri', {'uri': uri});
        if (result != null) {
          debugPrint('Copied file path: $result');
          return File(result);
        }
      } else {
        final file = File(uri);
        if (await file.exists()) {
          return file;
        }
      }
    } catch (e) {
      debugPrint('Error handling URI: $e');
    }
    return null;
  }

  /// Pick a directory using the native picker (SAF).
  Future<String?> pickDirectory() async {
    try {
      if (Platform.isAndroid) {
        return await _channel.invokeMethod<String>('pickDirectory');
      }
      return null;
    } catch (e) {
      debugPrint('Error picking directory: $e');
      return null;
    }
  }

  /// List contents of a directory using SAF.
  Future<List<Map<String, dynamic>>> listDirectory(String uriString) async {
    try {
      if (Platform.isAndroid) {
        final list = await _channel.invokeMethod<List<dynamic>>('listDirectory', {'uri': uriString});
        if (list != null) {
          return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        }
      }
      return const [];
    } catch (e) {
      debugPrint('Error listing directory via SAF: $e');
      rethrow;
    }
  }

  /// Read file content as string.
  Future<String> readFileContent(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return file.readAsString();
    }
    throw FileSystemException('File not found', filePath);
  }

  /// Read file content as bytes.
  Future<List<int>> readFileBytes(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return file.readAsBytes();
    }
    throw FileSystemException('File not found', filePath);
  }

  /// Delete a book's file from storage.
  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Get the app's book storage directory.
  Future<Directory> getBooksDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDir.path, 'books'));
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }
    return booksDir;
  }

  /// Extract a human-readable title from the file path.
  String _extractTitle(String filePath) {
    final basename = p.basenameWithoutExtension(filePath);
    // Replace underscores and hyphens with spaces, capitalize words
    return basename
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ')
        .trim();
  }
}
