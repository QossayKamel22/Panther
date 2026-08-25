import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/memory_entry.dart';
import '../../features/memory/application/memory_controller.dart';
import '../theme/app_spacing.dart';

/// One remembered item — scope label + content + a "forget" action. Shared
/// by the Memory screen and Search (which searches the same entries).
class MemoryTile extends StatelessWidget {
  const MemoryTile({super.key, required this.entry});

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
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
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
