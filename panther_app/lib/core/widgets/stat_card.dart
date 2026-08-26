import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';

/// A compact metric tile — icon, value, label, optional trend line. Used
/// across Home and Intelligence wherever a number needs to read at a glance.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.trend,
    this.trendUp,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final String? trend;
  final bool? trendUp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall),
          if (trend != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  (trendUp ?? true) ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 14,
                  color: (trendUp ?? true) ? semantic.success : theme.colorScheme.error,
                ),
                const SizedBox(width: 4),
                Text(
                  trend!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: (trendUp ?? true) ? semantic.success : theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
