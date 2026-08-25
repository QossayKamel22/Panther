import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../data/models/memory_entry.dart';
import '../application/memory_controller.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MemoryController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        leading: Navigator.canPop(context) ? const BackButton() : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Text(
              'What PANTHER remembers about you. Nothing is stored unless you explicitly ask it to.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: controller.loading
                ? const AppLoadingState()
                : controller.error != null
                ? AppErrorState(
                    message: controller.error,
                    onRetry: controller.retry,
                  )
                : controller.entries.isEmpty
                ? const AppEmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: 'Nothing saved yet',
                    message:
                        'Tell PANTHER something to remember from the chat.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: controller.entries.length,
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) =>
                        _MemoryTile(entry: controller.entries[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, controller),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAddSheet(BuildContext context, MemoryController controller) {
    final textController = TextEditingController();
    var scope = MemoryScope.fact;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom:
                MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.lg,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Remember something',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (final s in MemoryScope.values)
                        ChoiceChip(
                          label: Text(s.name),
                          selected: scope == s,
                          onSelected: (_) => setState(() => scope = s),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'What should PANTHER remember?',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: () {
                      controller.add(
                        scope: scope,
                        content: textController.text,
                      );
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({required this.entry});

  final MemoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.scope.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<MemoryController>().remove(entry.id),
            icon: const Icon(Icons.close_rounded, size: 18),
            tooltip: 'Forget',
          ),
        ],
      ),
    );
  }
}
