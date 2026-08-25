import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthController>();
    final ok = await auth.sendPasswordReset(_email.text.trim());
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Reset password')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: _sent
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mark_email_read_outlined, size: 40, color: theme.colorScheme.primary),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Check your email', style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'If an account exists for ${_email.text.trim()}, a reset link is on its way.',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Enter the email tied to your account and we'll send a reset link.",
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppTextField(
                          label: 'Email',
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline_rounded,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                        ),
                        if (auth.error != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(auth.error!, style: TextStyle(color: theme.colorScheme.error)),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(label: 'Send reset link', expand: true, loading: auth.busy, onPressed: _submit),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
