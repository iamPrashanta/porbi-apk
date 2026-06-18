import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/core/services/file_service.dart';
import 'package:porbi/features/library/providers/library_provider.dart';
import 'package:porbi/models/book.dart';
import 'package:crypto/crypto.dart';
import 'package:porbi/providers/database_provider.dart';

class SafFolder {
  final String name;
  final String uri;

  SafFolder({required this.name, required this.uri});

  factory SafFolder.fromJson(Map<String, dynamic> json) {
    return SafFolder(
      name: json['name'] as String,
      uri: json['uri'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'uri': uri,
      };
}

class FolderExplorerView extends ConsumerStatefulWidget {
  const FolderExplorerView({super.key});

  @override
  ConsumerState<FolderExplorerView> createState() => _FolderExplorerViewState();
}

class _FolderExplorerViewState extends ConsumerState<FolderExplorerView> {
  List<SafFolder> _rootFolders = [];
  String? _currentPath; // Storing SAF content URI
  List<Map<String, dynamic>> _currentContents = []; // Storing native maps
  final List<String> _navigationStack = []; // URI stack
  final List<String> _navigationNames = []; // Name stack (breadcrumb)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRootFolders();
  }

  Future<void> _loadRootFolders() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('porbi_root_folders_saf') ?? [];
    try {
      _rootFolders = jsonList
          .map((item) => SafFolder.fromJson(json.decode(item) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error parsing root folders: $e');
      _rootFolders = [];
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveRootFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _rootFolders.map((f) => json.encode(f.toJson())).toList();
    await prefs.setStringList('porbi_root_folders_saf', jsonList);
  }

  String _getFolderNameFromUri(String uriString) {
    try {
      final uri = Uri.parse(uriString);
      final lastSegment = Uri.decodeComponent(uri.pathSegments.last);
      if (lastSegment.contains(':')) {
        return lastSegment.split(':').last;
      }
      return p.basename(lastSegment);
    } catch (e) {
      return 'Folder';
    }
  }

  Future<void> _addRootFolder() async {
    try {
      final fileService = ref.read(fileServiceProvider);
      final selectedUri = await fileService.pickDirectory();
      if (selectedUri != null) {
        if (!_rootFolders.any((f) => f.uri == selectedUri)) {
          final folderName = _getFolderNameFromUri(selectedUri);
          setState(() {
            _rootFolders.add(SafFolder(name: folderName, uri: selectedUri));
          });
          await _saveRootFolders();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick directory: $e')),
        );
      }
    }
  }

  void _removeRootFolder(SafFolder folder) async {
    setState(() {
      _rootFolders.removeWhere((f) => f.uri == folder.uri);
    });
    await _saveRootFolders();
  }

  void _navigateToPath(String pathUri, {String? folderName}) {
    setState(() {
      _isLoading = true;
      _currentPath = pathUri;
    });

    final fileService = ref.read(fileServiceProvider);

    fileService.listDirectory(pathUri).then((list) {
      // Filter out hidden files and unsupported files
      final filteredList = list.where((item) {
        final name = item['name'] as String;
        final isDir = item['isDirectory'] as bool;
        if (name.startsWith('.')) return false;

        if (!isDir) {
          final ext = p.extension(name).toLowerCase().replaceAll('.', '');
          final allowed = ['epub', 'txt', 'md', 'markdown', 'html', 'htm'];
          return allowed.contains(ext);
        }
        return true;
      }).toList();

      // Sort: directories first, then files alphabetically
      filteredList.sort((a, b) {
        final aIsDir = a['isDirectory'] as bool;
        final bIsDir = b['isDirectory'] as bool;
        final aName = a['name'] as String;
        final bName = b['name'] as String;

        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;
        return aName.toLowerCase().compareTo(bName.toLowerCase());
      });

      if (mounted) {
        setState(() {
          _currentContents = filteredList;
          _isLoading = false;
          if (folderName != null) {
            _navigationNames.add(folderName);
          }
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _currentContents = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to read directory: $e')),
        );
      }
    });
  }

  void _jumpToBreadcrumb(int index) {
    if (_currentPath == null) return;

    if (index == 0) {
      // Go back to the Root Folders list
      setState(() {
        _currentPath = null;
        _currentContents = [];
        _navigationStack.clear();
        _navigationNames.clear();
      });
      return;
    }

    final targetIndex = index - 1; 
    if (targetIndex == _navigationNames.length - 1) return; // Clicked current

    final targetUri = targetIndex < _navigationStack.length ? _navigationStack[targetIndex] : _currentPath;
    if (targetUri == null) return;

    setState(() {
      _navigationStack.removeRange(targetIndex, _navigationStack.length);
      _navigationNames.removeRange(targetIndex + 1, _navigationNames.length);
    });

    _navigateToPath(targetUri);
  }

  String _hashUri(String uri) {
    return sha256.convert(utf8.encode(uri)).toString();
  }

  void _handleFileTap(Map<String, dynamic> fileMap) {
    final String fileUri = fileMap['uri'] as String;
    final String fileName = fileMap['name'] as String;
    final String bookId = 'temp_${_hashUri(fileUri)}';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  fileName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.menu_book_rounded),
                title: const Text('Open Once'),
                subtitle: const Text('Read without adding to library'),
                onTap: () async {
                  Navigator.pop(ctx);

                  try {
                    final fileService = ref.read(fileServiceProvider);
                    final tempFile = await fileService.importFromUri(fileUri);
                    if (!mounted) return;
                    
                    debugPrint('SAF URI: $fileUri');
                    debugPrint('BOOK ID: $bookId');
                    debugPrint('CACHE PATH: ${tempFile?.path}');

                    if (tempFile != null) {
                      context.push(
                        '/reader/$bookId?filePath=${Uri.encodeComponent(tempFile.path)}&originalUri=${Uri.encodeComponent(fileUri)}',
                      );
                    } else {
                      throw Exception('Failed to copy file content');
                    }
                  } catch (e, st) {
                    debugPrint('Error opening file: $e\n$st');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to open file: $e')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.library_add_rounded),
                title: const Text('Import to Library'),
                subtitle: const Text('Copy to app storage and track progress'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final notifier = ref.read(libraryNotifierProvider.notifier);
                    final book = await notifier.importFromUri(fileUri);
                    if (!mounted) return;
                    if (book != null) {
                      context.push('/reader/${book.id}');
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to import file: $e')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _handleRecentBookTap(Book book) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final file = File(book.filePath);
      if (await file.exists()) {
        if (mounted) {
          Navigator.pop(context); // Dismiss loader
          context.push(
            '/reader/${book.id}?filePath=${Uri.encodeComponent(book.filePath)}&originalUri=${Uri.encodeComponent(book.fileHash ?? "")}',
          );
        }
      } else {
        final originalUri = book.fileHash;
        if (originalUri != null && originalUri.startsWith('content://')) {
          final fileService = ref.read(fileServiceProvider);
          final tempFile = await fileService.importFromUri(originalUri);
          if (mounted) {
            if (tempFile != null) {
              final db = ref.read(databaseProvider);
              await db.updateBook(book.copyWith(filePath: tempFile.path));
              if (mounted) {
                Navigator.pop(context); // Dismiss loader
                context.push(
                  '/reader/${book.id}?filePath=${Uri.encodeComponent(tempFile.path)}&originalUri=${Uri.encodeComponent(originalUri)}',
                );
              }
            } else {
              Navigator.pop(context); // Dismiss loader
              throw Exception('Failed to recover file from storage');
            }
          }
        } else {
          if (mounted) {
            Navigator.pop(context);
            throw Exception('File cache was cleared and source URI is invalid');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: $e')),
        );
      }
    }
  }

  IconData _getFileIcon(String name, bool isDir) {
    if (isDir) return Icons.folder_rounded;
    final ext = p.extension(name).toLowerCase();
    switch (ext) {
      case '.epub':
        return Icons.menu_book_rounded;
      case '.md':
      case '.markdown':
        return Icons.description_rounded;
      case '.html':
      case '.htm':
        return Icons.language_rounded;
      case '.txt':
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileIconColor(String name, bool isDir, ThemeData theme) {
    if (isDir) return AppColors.primaryPurple;
    final ext = p.extension(name).toLowerCase();
    switch (ext) {
      case '.epub':
        return Colors.blue;
      case '.md':
      case '.markdown':
        return Colors.orange;
      case '.html':
      case '.htm':
        return Colors.teal;
      case '.txt':
        return Colors.grey;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    var d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatLastModified(int timestamp) {
    if (timestamp <= 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentPath == null) {
      final recentTempBooksAsync = ref.watch(recentTempBooksProvider);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton.icon(
              onPressed: _addRootFolder,
              icon: const Icon(Icons.create_new_folder_outlined),
              label: const Text('Add Folder'),
            ),
          ),
          if (_rootFolders.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No folders added yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  recentTempBooksAsync.when(
                    data: (books) {
                      if (books.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            child: Text(
                              'Recent Documents',
                              style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          ...books.map((book) {
                            final progress = (book.readingProgress * 100).toInt();
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getFileIconColor(book.title, false, theme).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getFileIcon(book.title, false),
                                  color: _getFileIconColor(book.title, false, theme),
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                book.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: progress > 0
                                  ? Text(
                                      'Progress: $progress%',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                    )
                                  : null,
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                              onTap: () => _handleRecentBookTap(book),
                            );
                          }),
                          const SizedBox(height: 12),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => const SizedBox.shrink(),
                  ),
                  ..._rootFolders.map((folder) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.folder_rounded, color: AppColors.primaryPurple),
                        title: Text(folder.name),
                        subtitle: Text(folder.uri, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => _removeRootFolder(folder),
                        ),
                        onTap: () {
                          _navigationStack.clear();
                          _navigationNames.clear();
                          _navigateToPath(folder.uri, folderName: folder.name);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      );
    }

    final breadcrumbsCount = _navigationNames.length + 1; // "Folders" + stack names

    return Column(
      children: [
        // Path Header (Breadcrumbs)
        Container(
          width: double.infinity,
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  for (int i = 0; i < breadcrumbsCount; i++) ...[
                    if (i > 0)
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => _jumpToBreadcrumb(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text(
                          i == 0 ? 'Folders' : _navigationNames[i - 1],
                          style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: i == breadcrumbsCount - 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: i == breadcrumbsCount - 1
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),

        // Contents
        Expanded(
          child: _currentContents.isEmpty
              ? Center(
                  child: Text(
                    'Empty folder',
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                )
              : ListView.builder(
                  itemCount: _currentContents.length,
                  itemBuilder: (context, index) {
                    final item = _currentContents[index];
                    final isDir = item['isDirectory'] as bool;
                    final name = item['name'] as String;
                    final size = item['size'] as int? ?? 0;
                    final lastModified = item['lastModified'] as int? ?? 0;

                    return ListTile(
                      leading: Icon(
                        _getFileIcon(name, isDir),
                        color: _getFileIconColor(name, isDir, theme),
                      ),
                      title: Text(name),
                      subtitle: !isDir && size > 0
                          ? Text(
                              '${_formatFileSize(size)}${lastModified > 0 ? " • ${_formatLastModified(lastModified)}" : ""}')
                          : null,
                      onTap: () {
                        if (isDir) {
                          _navigationStack.add(_currentPath!);
                          _navigateToPath(item['uri'] as String, folderName: name);
                        } else {
                          _handleFileTap(item);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
