import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/panther_mark.dart';
import '../../../core/widgets/social_sign_in_row.dart';
import '../../../data/repositories/auth_repository.dart';
import '../application/auth_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> _social(SocialProvider provider) async {
    final auth = context.read<AuthController>();
    final ok = await auth.signInWithSocial(provider);
    if (ok && mounted) context.go('/home');
  }

  Future<void> _viewDemo() async {
    final auth = context.read<AuthController>();
    final ok = await auth.signInDemo();
    if (ok && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Theme(
      data: AppTheme.build(AppPalette.dark),
      child: Scaffold(
        backgroundColor: const Color(0xFF05070C),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.35),
              radius: 1.1,
              colors: [Color(0xFF101828), Color(0xFF05070C)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const PantherMark(size: 96, glow: true),
                        const SizedBox(height: AppSpacing.xl),
                        const Text(
                          'PANTHER',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 6,
                            color: Color(0xFFF4F6FB),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: 28,
                          height: 2,
                          color: const Color(0xFF5E8CFF),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text(
                          'THINK AHEAD.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: Color(0xFF89ABFF),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          'A context-aware AI agent that thinks ahead with you.',
                          style: TextStyle(
                            color: Color(0xFFA6ADBB),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        if (auth.error != null) ...[
                          Text(
                            auth.error!,
                            style: const TextStyle(
                              color: Color(0xFFF06B6B),
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        AppButton(
                          label: 'View demo',
                          icon: Icons.play_circle_outline_rounded,
                          expand: true,
                          loading: auth.busy,
                          onPressed: _viewDemo,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton(
                          label: 'Sign in',
                          variant: AppButtonVariant.secondary,
                          expand: true,
                          onPressed: () => context.push('/login'),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton(
                          label: 'Create account',
                          variant: AppButtonVariant.ghost,
                          expand: true,
                          onPressed: () => context.push('/register'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SocialSignInRow(busy: auth.busy, onSelect: _social),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
