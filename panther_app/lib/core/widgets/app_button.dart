import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, ghost, destructive }

/// A single button component so every call site gets consistent sizing,
/// radius, loading state, and disabled treatment instead of hand-rolling
/// ElevatedButton/OutlinedButton per screen.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onPressed == null || loading;

    final child = loading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary ? scheme.onPrimary : scheme.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Text(label),
            ],
          );

    final Widget button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: disabled ? null : onPressed, child: child),
      AppButtonVariant.secondary => OutlinedButton(onPressed: disabled ? null : onPressed, child: child),
      AppButtonVariant.ghost => TextButton(onPressed: disabled ? null : onPressed, child: child),
      AppButtonVariant.destructive => ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          child: child,
        ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
