import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/router/app_router.dart';
import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/providers/settings_provider.dart';

import 'package:porbi/core/services/intent_service.dart';

class PorbiApp extends ConsumerStatefulWidget {
  const PorbiApp({super.key});

  @override
  ConsumerState<PorbiApp> createState() => _PorbiAppState();
}

class _PorbiAppState extends ConsumerState<PorbiApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(intentServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Porbi',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
