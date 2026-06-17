import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:porbi/core/constants/supported_formats.dart';
import 'package:porbi/models/book.dart' as models;
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class FileService {
  static const _uuid = Uuid();

  /// Pick a file using the system file picker.
  Future<File?> pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'md', 'markdown', 'epub', 'html', 'htm'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
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
      final file = File(uri);
      if (await file.exists()) {
        return file;
      }
    } catch (_) {
      // URI might not be a direct file path
    }
    return null;
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
