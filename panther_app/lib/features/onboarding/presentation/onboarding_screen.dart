import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/panther_mark.dart';

const onboardingSeenKey = 'panther.onboarding_seen';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(onboardingSeenKey, true);
    } catch (_) {
      // Non-critical — worst case onboarding shows again next launch.
    }
    if (context.mounted) context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PantherMark(size: 64),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Context that thinks ahead.', style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'PANTHER connects your calendar, tasks, notes, and conversations — then turns that context into useful action, not just answers.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  AppButton(label: 'Get started', expand: true, onPressed: () => _finish(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
