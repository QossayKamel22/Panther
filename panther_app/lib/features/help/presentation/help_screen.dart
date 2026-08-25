import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/panther_mark.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & About'), leading: const BackButton()),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Center(child: PantherMark(size: 56)),
          const SizedBox(height: AppSpacing.lg),
          Text('PANTHER', style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          Text(
            'Your Second Mind. Version 1.0.0',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _HelpSection(
            title: 'How memory works',
            icon: Icons.bookmark_outline_rounded,
            body:
                'PANTHER only remembers what you explicitly ask it to. Each item you save is '
                'tagged with a scope — preference, project, decision, instruction, or fact — so '
                'it can bring the right context back into a conversation later. Nothing is stored '
                'silently, and you can forget anything from the Memory screen at any time.',
          ),
          const SizedBox(height: AppSpacing.lg),
          const _HelpSection(
            title: 'How conversations work',
            icon: Icons.chat_bubble_outline_rounded,
            body:
                'Every message you send is answered with your saved memory as context, so replies '
                'can reference what you\'ve told PANTHER before instead of starting from zero each time.',
          ),
          const SizedBox(height: AppSpacing.lg),
          const _HelpSection(
            title: 'Your data',
            icon: Icons.lock_outline_rounded,
            body:
                'When signed in, your memory syncs to your account and is only ever readable by you '
                '— it\'s scoped to your user id with security rules on the backend. Without a signed-in '
                'account, everything stays local to this device.',
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({required this.title, required this.icon, required this.body});

  final String title;
  final IconData icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
