import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../theme/app_spacing.dart';
import 'social_icons.dart';

/// The "or continue with" divider + Google/Apple/Microsoft row shared by the
/// welcome, login and register screens.
class SocialSignInRow extends StatelessWidget {
  const SocialSignInRow({super.key, required this.busy, required this.onSelect});

  final bool busy;
  final ValueChanged<SocialProvider> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.colorScheme.outline)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('or continue with', style: theme.textTheme.bodySmall),
            ),
            Expanded(child: Divider(color: theme.colorScheme.outline)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                tooltip: 'Continue with Google',
                icon: const GoogleGIcon(),
                onPressed: busy ? null : () => onSelect(SocialProvider.google),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SocialButton(
                tooltip: 'Continue with Apple',
                icon: const Icon(Icons.apple, size: 20),
                onPressed: busy ? null : () => onSelect(SocialProvider.apple),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SocialButton(
                tooltip: 'Continue with Microsoft',
                icon: const MicrosoftIcon(),
                onPressed: busy ? null : () => onSelect(SocialProvider.microsoft),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.onPressed, required this.tooltip});

  final Widget icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: theme.colorScheme.outline),
        ),
        child: icon,
      ),
    );
  }
}
