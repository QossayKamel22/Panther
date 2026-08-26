import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../theme/app_spacing.dart';
import 'social_icons.dart';

/// The "or continue with" divider + Google/Apple/Microsoft row shared by the
/// welcome, login and register screens.
///
/// Only Google is wired to a real, enabled Firebase provider today. Apple
/// and Microsoft route to a friendly "coming soon" notice instead of the
/// raw "isn't enabled on this Firebase project" error — accurate (they
/// really aren't live yet) without surfacing backend/console details to
/// whoever's looking at the screen.
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
                tooltip: 'Apple — coming soon',
                icon: const Icon(Icons.apple, size: 20),
                comingSoon: true,
                onPressed: busy ? null : () => _comingSoon(context, 'Apple'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SocialButton(
                tooltip: 'Microsoft — coming soon',
                icon: const MicrosoftIcon(),
                comingSoon: true,
                onPressed: busy ? null : () => _comingSoon(context, 'Microsoft'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _comingSoon(BuildContext context, String provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$provider sign-in is on the roadmap — not live yet.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.comingSoon = false,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
            child: Opacity(opacity: comingSoon ? 0.45 : 1, child: icon),
          ),
          if (comingSoon)
            Positioned(
              top: -6,
              right: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Text(
                  'Soon',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
