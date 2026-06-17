import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porbi/features/home/screens/home_screen.dart';
import 'package:porbi/features/library/screens/library_screen.dart';
import 'package:porbi/features/reader/screens/reader_screen.dart';
import 'package:porbi/features/bookmarks/screens/bookmarks_screen.dart';
import 'package:porbi/features/search/screens/search_screen.dart';
import 'package:porbi/features/settings/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    if (state.uri.scheme == 'content' || state.uri.scheme == 'file') {
      // Prevent GoRouter from navigating to incoming deep links.
      // IntentService will handle these URIs natively.
      return '/';
    }
    return null;
  },
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return _ShellScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/library',
          name: 'library',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LibraryScreen()),
        ),
        GoRoute(
          path: '/bookmarks',
          name: 'bookmarks',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: BookmarksScreen()),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/reader/:bookId',
      name: 'reader',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final bookId = state.pathParameters['bookId']!;
        return ReaderScreen(bookId: bookId);
      },
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final bookId = state.uri.queryParameters['bookId'];
        return SearchScreen(bookId: bookId);
      },
    ),
  ],
);

class _ShellScaffold extends StatelessWidget {
  final Widget child;

  const _ShellScaffold({required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/bookmarks')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/library');
              break;
            case 2:
              context.go('/bookmarks');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_library_outlined),
            selectedIcon: Icon(Icons.local_library_rounded),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Bookmarks',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
