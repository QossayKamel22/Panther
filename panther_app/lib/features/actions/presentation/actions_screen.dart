import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/action_card.dart';
import '../../../core/widgets/app_states.dart';
import '../application/actions_controller.dart';

/// Action Center — the one place PANTHER's proposed actions live, split
/// into Pending / Completed / History. See ActionsController's doc comment:
/// this is a demo data layer, not a live action queue.
class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ActionsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actions'),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'Pending (${controller.pending.length})'),
            Tab(text: 'Completed (${controller.completed.length})'),
            const Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _PendingTab(controller: controller),
          _CompletedTab(controller: controller),
          _HistoryTab(controller: controller),
        ],
      ),
    );
  }
}

class _PendingTab extends StatelessWidget {
  const _PendingTab({required this.controller});
  final ActionsController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.pending.isEmpty) {
      return const AppEmptyState(
        icon: Icons.task_alt_rounded,
        title: 'No pending actions',
        message: 'PANTHER will ask before doing anything on your behalf.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: controller.pending.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final action = controller.pending[i];
        return ActionCard(
          action: action,
          onApprove: () => controller.approve(action.id),
          onReject: () => controller.reject(action.id),
        );
      },
    );
  }
}

class _CompletedTab extends StatelessWidget {
  const _CompletedTab({required this.controller});
  final ActionsController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.completed.isEmpty) {
      return const AppEmptyState(
        icon: Icons.checklist_rounded,
        title: 'Nothing completed yet',
        message: 'Approved or rejected actions will show up here.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: controller.completed.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) => ActionCard(action: controller.completed[i]),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.controller});
  final ActionsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: controller.history.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(Icons.history_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(controller.history[i], style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
