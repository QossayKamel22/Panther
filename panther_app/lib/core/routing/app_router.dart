import 'package:go_router/go_router.dart';
import '../../features/actions/presentation/actions_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/ecosystem/presentation/ecosystem_screen.dart';
import '../../features/help/presentation/help_screen.dart';
import '../../features/home/presentation/dashboard_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/intelligence/presentation/intelligence_screen.dart';
import '../../features/memory/presentation/memory_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

GoRouter buildRouter(AuthController auth) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final onAuthRoute = loc == '/welcome' || loc == '/login' || loc == '/register' || loc == '/forgot-password';

      // SplashScreen and OnboardingScreen decide their own next stop
      // (SplashScreen reads onboarding/auth state itself and navigates once
      // resolved — a redirect from here would never let it actually paint).
      if (loc == '/' || loc == '/onboarding') return null;

      if (auth.status == AuthStatus.authenticated && onAuthRoute) return '/home';
      if (auth.status == AuthStatus.unauthenticated && !onAuthRoute) return '/welcome';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
      GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const DashboardScreen())]),
          StatefulShellBranch(
            routes: [GoRoute(path: '/conversation', builder: (context, state) => const ChatScreen())],
          ),
          StatefulShellBranch(routes: [GoRoute(path: '/memory', builder: (context, state) => const MemoryScreen())]),
          StatefulShellBranch(
            routes: [GoRoute(path: '/ecosystem', builder: (context, state) => const EcosystemScreen())],
          ),
          StatefulShellBranch(routes: [GoRoute(path: '/actions', builder: (context, state) => const ActionsScreen())]),
          StatefulShellBranch(
            routes: [GoRoute(path: '/intelligence', builder: (context, state) => const IntelligenceScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen())],
          ),
        ],
      ),
    ],
  );
}
