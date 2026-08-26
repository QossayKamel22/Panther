import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/memory_tile.dart';
import '../../../data/models/memory_entry.dart';
import '../application/memory_controller.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  MemoryScope? _filter;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MemoryController>();
    final theme = Theme.of(context);
    final filtered = _filter == null
        ? controller.entries
        : controller.entries.where((e) => e.scope == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search memory',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
            child: Text(
              'Everything PANTHER knows about you — under your control.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CategoryChip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                  for (final s in MemoryScope.values) ...[
                    const SizedBox(width: AppSpacing.xs),
                    _CategoryChip(
                      label: _label(s),
                      selected: _filter == s,
                      onTap: () => setState(() => _filter = s),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: controller.loading
                ? const AppLoadingState()
                : controller.error != null
                ? AppErrorState(
                    message: controller.error,
                    onRetry: controller.retry,
                  )
                : filtered.isEmpty
                ? AppEmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: controller.entries.isEmpty ? 'No memories yet' : 'Nothing in this category',
                    message: controller.entries.isEmpty
                        ? 'Tell PANTHER something to remember from Conversation.'
                        : 'Try a different category, or add a new memory below.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => MemoryTile(entry: filtered[i]),
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

  String _label(MemoryScope s) => s.name[0].toUpperCase() + s.name.substring(1);

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
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.lg,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Remember something', style: Theme.of(context).textTheme.titleLarge),
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
                    decoration: const InputDecoration(hintText: 'What should PANTHER remember?'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: () {
                      controller.add(scope: scope, content: textController.text);
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap());
  }
}
