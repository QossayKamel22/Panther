import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_controller.dart';
import '../../auth/application/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Appearance', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<AppThemeMode>(
            segments: const [
              ButtonSegment(value: AppThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto_rounded)),
              ButtonSegment(value: AppThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_rounded)),
              ButtonSegment(value: AppThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_rounded)),
            ],
            selected: {themeController.mode},
            onSelectionChanged: (s) => themeController.setMode(s.first),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('About', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          const _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'PANTHER',
            subtitle: 'Your Second Mind. Version 1.0.0',
          ),
          const _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & About',
            subtitle: 'Context-aware AI agent — learn how memory and tools work.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Account', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            title: Text('Sign out', style: TextStyle(color: theme.colorScheme.error)),
            onTap: () async {
              await context.read<AuthController>().signOut();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
