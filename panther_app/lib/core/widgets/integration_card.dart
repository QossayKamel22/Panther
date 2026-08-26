import 'package:flutter/material.dart';
import '../../data/models/integration.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_card.dart';

/// One connectable service in the Ecosystem hub. Every "Connect" button is
/// honest about not doing anything real yet — same "on the roadmap" pattern
/// as the Apple/Microsoft sign-in buttons, rather than pretending to connect.
class IntegrationCard extends StatelessWidget {
  const IntegrationCard({super.key, required this.integration});

  final Integration integration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: integration.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(integration.icon, size: 18, color: integration.color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(integration.name, style: theme.textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final c in integration.capabilities)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(c, style: theme.textTheme.labelSmall),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Connect',
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: () => _comingSoon(context),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${integration.name} isn\'t connected yet — on the roadmap.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
