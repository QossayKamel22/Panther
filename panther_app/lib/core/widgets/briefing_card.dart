import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'panther_mark.dart';

/// The large "PANTHER is actively understanding your day" card at the top
/// of Home. One consistent shape for both a real, memory-derived briefing
/// and the honest empty state when there's nothing to summarize yet.
class BriefingCard extends StatelessWidget {
  const BriefingCard({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PantherMark(size: 36),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Morning briefing', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(message, style: theme.textTheme.bodyLarge?.copyWith(height: 1.45)),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppButton(label: actionLabel!, variant: AppButtonVariant.secondary, onPressed: onAction),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
