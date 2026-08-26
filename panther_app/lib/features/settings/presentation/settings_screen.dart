import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../data/services/firebase_bootstrap.dart';
import '../../auth/application/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _SectionLabel('Account'),
          _SettingsTile(
            icon: Icons.person_outline_rounded,
            title: user?.displayNameOrFallback ?? 'Guest',
            subtitle: user?.email ?? 'Not signed in',
            onTap: () => context.push('/profile'),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('General'),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'PANTHER',
            subtitle: 'Your Second Mind. Version 1.0.0',
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & About',
            subtitle: 'Learn how memory and tools work.',
            onTap: () => context.push('/help'),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: SegmentedButton<AppThemeMode>(
              segments: const [
                ButtonSegment(
                  value: AppThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto_rounded),
                ),
                ButtonSegment(value: AppThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_rounded)),
                ButtonSegment(value: AppThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_rounded)),
              ],
              selected: {themeController.mode},
              onSelectionChanged: (s) => themeController.setMode(s.first),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('Connected Services'),
          _SettingsTile(
            icon: Icons.hub_outlined,
            title: 'Ecosystem',
            subtitle: 'Manage Calendar, Gmail, Notion, and more.',
            onTap: () => context.go('/ecosystem'),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('Memory'),
          _SettingsTile(
            icon: Icons.bookmark_outline_rounded,
            title: 'Manage memory',
            subtitle: 'View, filter, or forget what PANTHER remembers.',
            onTap: () => context.go('/memory'),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('Notifications'),
          const _SoonTile(icon: Icons.notifications_outlined, title: 'Push notifications', subtitle: 'Meeting prep, action approvals, weekly summary.'),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('AI Preferences'),
          const _SoonTile(icon: Icons.tune_rounded, title: 'Response style', subtitle: 'Concise, balanced, or detailed.'),
          const _SoonTile(icon: Icons.psychology_outlined, title: 'Proactive suggestions', subtitle: 'Let PANTHER surface ideas before you ask.'),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('Privacy & Security'),
          _SettingsTile(
            icon: FirebaseBootstrap.isAvailable ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            title: 'Data & backend',
            subtitle: FirebaseBootstrap.isAvailable
                ? 'Your memory is synced to your account, scoped to only you.'
                : 'Running in local mode — data stays on this device.',
          ),
          const _SoonTile(icon: Icons.lock_outline_rounded, title: 'Two-factor authentication'),
          const SizedBox(height: AppSpacing.xxl),
          _SectionLabel('Account actions'),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.onTap});

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

/// A settings row for a feature that isn't implemented yet — shown plainly
/// with a "Soon" badge rather than a switch that would silently do nothing.
class _SoonTile extends StatelessWidget {
  const _SoonTile({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Text('Soon', style: theme.textTheme.labelSmall),
      ),
    );
  }
}
