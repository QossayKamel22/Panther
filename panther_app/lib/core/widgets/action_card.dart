import 'package:flutter/material.dart';
import '../../data/models/agent_action.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_card.dart';

/// One thing PANTHER wants to do — a preview plus explicit approve/reject.
/// Destructive or external actions get a visibly stronger warning treatment
/// so approval is never a careless tap.
class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.action, this.onApprove, this.onReject});

  final AgentAction action;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(action.title, style: theme.textTheme.titleMedium)),
              if (action.state != ActionState.pending) _StateBadge(state: action.state),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(action.detail, style: theme.textTheme.bodyMedium),
          if (action.destructive && action.state == ActionState.pending) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 14, color: theme.colorScheme.error),
                const SizedBox(width: 4),
                Text(
                  'Sends externally — review before approving.',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.error),
                ),
              ],
            ),
          ],
          if (action.state == ActionState.pending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(label: 'Approve', expand: true, onPressed: onApprove),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: 'Reject',
                    variant: AppButtonVariant.ghost,
                    expand: true,
                    onPressed: onReject,
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

class _StateBadge extends StatelessWidget {
  const _StateBadge({required this.state});
  final ActionState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final approved = state == ActionState.approved;
    final color = approved ? const Color(0xFF0E8F63) : theme.colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        approved ? 'Approved' : 'Rejected',
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
