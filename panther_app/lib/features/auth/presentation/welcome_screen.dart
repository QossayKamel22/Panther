import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/panther_mark.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PantherMark(size: 72),
                  const SizedBox(height: AppSpacing.xl),
                  Text('PANTHER', style: theme.textTheme.displaySmall?.copyWith(letterSpacing: 3)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Your Second Mind.',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'A context-aware AI agent that thinks ahead with you.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  AppButton(
                    label: 'Sign in',
                    expand: true,
                    onPressed: () => context.push('/login'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Create account',
                    variant: AppButtonVariant.secondary,
                    expand: true,
                    onPressed: () => context.push('/register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
