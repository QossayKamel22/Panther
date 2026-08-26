import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/demo_account.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/briefing_card.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../data/models/dashboard_content.dart';
import '../../../data/models/memory_entry.dart';
import '../../auth/application/auth_controller.dart';
import '../../chat/application/chat_controller.dart';
import '../../memory/application/memory_controller.dart';

/// Home — PANTHER's command center. The morning briefing is real, built
/// from whatever's actually in memory. The calendar/task-shaped content
/// (meetings, deadlines, the timeline) has no integration behind it yet, so
/// it's only shown for the seeded demo account — see DemoDashboard's doc
/// comment. Everyone else gets an honest prompt to connect a service.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthController>();
    final memory = context.watch<MemoryController>();
    final isDemo = auth.user?.email == DemoAccount.email;
    final name = auth.user?.displayNameOrFallback ?? 'there';
    final columns = context.isMobile ? 2 : 4;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('${_greeting()}, $name 👋', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text("Here's what matters today.", style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          BriefingCard(
            message: _briefing(memory.entries, isDemo: isDemo),
            actionLabel: memory.entries.isEmpty ? null : 'Ask PANTHER',
            onAction: () => context.go('/conversation'),
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.3,
            children: isDemo
                ? const [
                    StatCard(icon: Icons.groups_outlined, value: '${DemoDashboard.meetingsToday}', label: 'Meetings'),
                    StatCard(icon: Icons.task_alt_rounded, value: '${DemoDashboard.tasksToday}', label: 'Tasks'),
                    StatCard(
                      icon: Icons.flag_outlined,
                      value: '${DemoDashboard.deadlinesUpcoming}',
                      label: 'Deadlines',
                    ),
                    StatCard(
                      icon: Icons.center_focus_strong_outlined,
                      value: DemoDashboard.focusHoursToday,
                      label: 'Focus time',
                    ),
                  ]
                : [
                    _ConnectStat(icon: Icons.groups_outlined, label: 'Meetings'),
                    _ConnectStat(icon: Icons.task_alt_rounded, label: 'Tasks'),
                    _ConnectStat(icon: Icons.flag_outlined, label: 'Deadlines'),
                    _ConnectStat(icon: Icons.center_focus_strong_outlined, label: 'Focus time'),
                  ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (isDemo) ...[
            Text('Upcoming', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < DemoDashboard.timeline.length; i++) ...[
                    if (i > 0) const Divider(height: AppSpacing.lg),
                    Row(
                      children: [
                        SizedBox(
                          width: 56,
                          child: Text(DemoDashboard.timeline[i].time, style: theme.textTheme.labelMedium),
                        ),
                        Expanded(child: Text(DemoDashboard.timeline[i].title, style: theme.textTheme.bodyLarge)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Top priorities', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < DemoDashboard.priorities.length; i++) ...[
                    if (i > 0) const Divider(height: AppSpacing.lg),
                    _PriorityRow(item: DemoDashboard.priorities[i]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Proactive intelligence', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            BriefingCard(
              message: DemoDashboard.proactiveTip,
              actionLabel: DemoDashboard.proactiveAction,
              onAction: () {
                context.read<ChatController>().send('Prepare me for my meeting.');
                context.go('/conversation');
              },
            ),
          ] else
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('See your real day here', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Connect Google Calendar and Tasks in Ecosystem to turn this into a real briefing '
                    'instead of a preview.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () => context.go('/ecosystem'),
                    child: const Text('Go to Ecosystem'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _briefing(List<MemoryEntry> entries, {required bool isDemo}) {
    if (entries.isEmpty) {
      return "I don't have anything saved about you yet — tell me something to remember in "
          'Conversation and I\'ll start building your briefing.';
    }
    final top = entries.first;
    final tail = isDemo
        ? ' You have ${DemoDashboard.meetingsToday} meetings today, ${DemoDashboard.tasksToday} tasks, '
            'and ${DemoDashboard.deadlinesUpcoming} deadlines approaching.'
        : '';
    return "I'm holding ${entries.length} thing${entries.length == 1 ? '' : 's'} from memory — including "
        '"${top.content}".$tail';
  }
}

class _ConnectStat extends StatelessWidget {
  const _ConnectStat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () => context.go('/ecosystem'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Text('—', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({required this.item});
  final PriorityItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (item.status) {
      PriorityStatus.done => ('Done', const Color(0xFF0E8F63)),
      PriorityStatus.inProgress => ('In progress', theme.colorScheme.primary),
      PriorityStatus.notStarted => ('Not started', theme.colorScheme.onSurfaceVariant),
    };
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 2),
              Text('Due ${item.due}', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(label, style: theme.textTheme.labelSmall?.copyWith(color: color)),
        ),
      ],
    );
  }
}
