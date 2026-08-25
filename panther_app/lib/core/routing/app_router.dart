import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/help/presentation/help_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/memory/presentation/memory_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

GoRouter buildRouter(AuthController auth) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) async {
      final loc = state.matchedLocation;
      final onAuthRoute = loc == '/welcome' || loc == '/login' || loc == '/register' || loc == '/forgot-password';

      if (loc == '/') {
        bool onboarded;
        try {
          final prefs = await SharedPreferences.getInstance();
          onboarded = prefs.getBool(onboardingSeenKey) ?? false;
        } catch (_) {
          onboarded = true;
        }
        if (!onboarded) return '/onboarding';
        return auth.status == AuthStatus.authenticated ? '/home' : '/welcome';
      }

      if (auth.status == AuthStatus.authenticated && onAuthRoute) return '/home';
      if (auth.status == AuthStatus.unauthenticated && !onAuthRoute && loc != '/onboarding') return '/welcome';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _Splash()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/memory', builder: (context, state) => const MemoryScreen()),
      GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
      GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const ChatScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen())]),
        ],
      ),
    ],
  );
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
