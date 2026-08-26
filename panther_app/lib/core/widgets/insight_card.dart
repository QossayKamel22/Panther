import 'package:flutter/material.dart';
import '../../data/models/insight.dart';
import '../theme/app_spacing.dart';

/// One behavioral observation on the Intelligence dashboard — an emoji
/// glyph instead of an icon so it reads as an observation, not a metric.
class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.insight});
  final Insight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Text(insight.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(insight.text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
