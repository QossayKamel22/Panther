import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/services/firebase_bootstrap.dart';
import '../../auth/application/auth_controller.dart';
import '../../memory/application/memory_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final memory = context.watch<MemoryController>();
    final user = auth.user;
    final theme = Theme.of(context);
    final name = user?.displayNameOrFallback ?? 'Guest';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                  child: Text(
                    initial,
                    style: theme.textTheme.displaySmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(name, style: theme.textTheme.headlineSmall),
                if (user?.email != null)
                  Text(user!.email!, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Memories saved',
                  value: '${memory.entries.length}',
                  icon: Icons.bookmark_rounded,
                  onTap: () => context.push('/memory'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  label: 'Backend',
                  value: FirebaseBootstrap.isAvailable ? 'Connected' : 'Local mode',
                  icon: FirebaseBootstrap.isAvailable ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  user == null
                      ? 'Signed out.'
                      : 'Signed in as ${user.email ?? user.uid}.',
                  style: theme.textTheme.bodyMedium,
                ),
                if (!FirebaseBootstrap.isAvailable) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Running without a connected backend — your data stays on this device only.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, this.onTap});

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: theme.textTheme.titleLarge),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
