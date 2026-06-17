import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/router/app_router.dart';
import 'package:porbi/features/library/providers/library_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

final intentServiceProvider = Provider<IntentService>((ref) {
  final libraryNotifier = ref.watch(libraryNotifierProvider.notifier);
  return IntentService(libraryNotifier);
});

class IntentService {
  final LibraryNotifier _libraryNotifier;
  final _appLinks = AppLinks();
  StreamSubscription? _appLinksSubscription;
  StreamSubscription? _sharingIntentSubscription;

  IntentService(this._libraryNotifier);

  void init() {
    _initAppLinks();
    _initReceiveSharingIntent();
  }

  void dispose() {
    _appLinksSubscription?.cancel();
    _sharingIntentSubscription?.cancel();
    ReceiveSharingIntent.instance.reset();
  }

  void _initAppLinks() {
    // Handle cold start (initial URI)
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    });

    // Handle incoming URIs while app is open
    _appLinksSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

  void _initReceiveSharingIntent() {
    // Handle incoming sharing intents while app is open
    _sharingIntentSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((files) {
      _handleSharedFiles(files);
    });

    // Handle cold start (initial sharing intent)
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      _handleSharedFiles(files);
    });
  }

  Future<void> _handleUri(Uri uri) async {
    // A file:// or content:// URI
    final path = uri.toString();
    debugPrint('Handling deep link intent URI: $path');
    final book = await _libraryNotifier.importFromUri(path);
    if (book != null) {
      debugPrint('Created book id: ${book.id}');
      appRouter.push('/reader/${book.id}');
    } else {
      debugPrint('Failed to create book from URI: $path');
    }
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;
    for (final file in files) {
      debugPrint('Handling shared file intent URI: ${file.path}');
      final book = await _libraryNotifier.importFromUri(file.path);
      if (book != null) {
        debugPrint('Created book id: ${book.id}');
        appRouter.push('/reader/${book.id}');
      } else {
        debugPrint('Failed to create book from shared file: ${file.path}');
      }
    }
  }
}
