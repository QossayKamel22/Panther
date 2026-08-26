import 'package:flutter/material.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/insight_card.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/weekly_focus_chart.dart';
import '../../../data/models/insight.dart';

/// Intelligence dashboard. Every number here is illustrative — PANTHER
/// doesn't track real usage yet — shown as the shape the feature will take
/// once it does, not a claim that it's live today.
class IntelligenceScreen extends StatelessWidget {
  const IntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final columns = context.isMobile ? 1 : 3;
    return Scaffold(
      appBar: AppBar(title: const Text('Intelligence')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Intelligence', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'How PANTHER sees your week — illustrative until real usage data is connected.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.6,
            children: const [
              StatCard(icon: Icons.bolt_rounded, value: '82', label: 'Focus score', trend: '+6 this week'),
              StatCard(icon: Icons.task_alt_rounded, value: '24', label: 'Tasks completed', trend: '+20%'),
              StatCard(icon: Icons.hourglass_bottom_rounded, value: '3.4h', label: 'Time saved this week'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly focus', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.lg),
                WeeklyFocusChart(points: demoWeeklyFocus),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Insights', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          for (final insight in demoInsights) ...[
            InsightCard(insight: insight),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
