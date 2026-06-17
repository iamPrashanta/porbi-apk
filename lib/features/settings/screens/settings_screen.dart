
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/core/constants/app_constants.dart';
import 'package:porbi/core/services/backup_service.dart';
import 'package:porbi/core/theme/app_theme.dart';
import 'package:porbi/providers/database_provider.dart';
import 'package:porbi/providers/settings_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // ─── Display ────────────────────────────────────────
          const _SectionHeader('Display'),
          ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            title: const Text('App Theme'),
            subtitle: Text(_themeModeString(themeMode)),
            onTap: () => _showThemeDialog(context, ref, themeMode),
          ),

          const Divider(),

          // ─── Data & Backup ──────────────────────────────────
          const _SectionHeader('Data & Backup'),
          ListTile(
            leading: const Icon(Icons.backup_rounded),
            title: const Text('Export Backup'),
            subtitle: const Text(
              'Save your library data and settings to a JSON file',
            ),
            onTap: () => _exportBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: const Text('Restore Backup'),
            subtitle: const Text(
              'Restore your library from a JSON backup file',
            ),
            onTap: () => _showRestoreWarning(context, ref),
          ),

          const Divider(),

          // ─── About ──────────────────────────────────────────
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text(AppConstants.appName),
            subtitle: Text('Version ${AppConstants.appVersion}'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _themeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('App Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_themeModeString(mode)),
              value: mode,
              // ignore: deprecated_member_use
              groupValue: currentMode,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(val);
                  Navigator.pop(ctx);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final backupService = BackupService(db);

    try {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Creating backup...')));
      }

      final file = await backupService.createBackup();

      if (!context.mounted) return;

      // ignore: deprecated_member_use
      final result = await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Porbi Backup');

      if (!context.mounted) return;

      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup exported successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create backup: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showRestoreWarning(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup'),
        content: const Text(
          'Warning: Restoring from a backup will overwrite your current library data, bookmarks, and notes.\n\nThis action cannot be undone. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              // In a full implementation, we would use file_picker to select the JSON file
              // and pass it to backupService.restoreBackup(file)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Please export your data first to ensure safety.',
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Choose File'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
