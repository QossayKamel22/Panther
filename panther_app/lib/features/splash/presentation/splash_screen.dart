import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/panther_mark.dart';
import '../../auth/application/auth_controller.dart';
import '../../onboarding/presentation/onboarding_screen.dart';

/// The very first frame anyone sees. Owns the "where do we actually go"
/// decision itself (onboarding seen? signed in?) instead of leaving it to
/// GoRouter's redirect callback — a redirect resolves before the router
/// ever paints the route it's redirecting *from*, so a splash driven purely
/// by redirect logic never actually becomes visible. Shown for a minimum
/// stretch so it reads as an intentional brand moment rather than a flicker.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  Future<void> _resolve() async {
    final auth = context.read<AuthController>();
    final minDisplay = Future<void>.delayed(const Duration(milliseconds: 650));

    bool onboarded;
    try {
      final prefs = await SharedPreferences.getInstance();
      onboarded = prefs.getBool(onboardingSeenKey) ?? false;
    } catch (_) {
      onboarded = true;
    }

    if (auth.status == AuthStatus.unknown) {
      await auth.ready;
    }

    await minDisplay;
    if (!mounted) return;

    if (!onboarded) {
      context.go('/onboarding');
    } else if (auth.status == AuthStatus.authenticated) {
      context.go('/home');
    } else {
      context.go('/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 1.1,
            colors: [Color(0xFF101828), Color(0xFF05070C)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final t = _pulse.value;
              return Opacity(
                opacity: 0.75 + (0.25 * t),
                child: Transform.scale(
                  scale: 0.94 + (0.06 * t),
                  child: child,
                ),
              );
            },
            child: const PantherMark(size: 80, glow: true),
          ),
        ),
      ),
    );
  }
}
