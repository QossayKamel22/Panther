import 'package:flutter/material.dart';
import '../../data/models/insight.dart';
import '../theme/app_spacing.dart';

/// A minimal, hand-rolled bar chart — no charting dependency needed for
/// seven bars. Kept deliberately plain: rounded bars, one accent color,
/// day labels underneath.
class WeeklyFocusChart extends StatelessWidget {
  const WeeklyFocusChart({super.key, required this.points});
  final List<WeeklyFocusPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final p in points)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 96,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: p.value.clamp(0.04, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(p.label, style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
