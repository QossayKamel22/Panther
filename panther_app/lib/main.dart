import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/demo_account.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/memory_repository.dart';
import 'data/services/demo_ai_service.dart';
import 'data/services/firebase_bootstrap.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/chat/application/chat_controller.dart';
import 'features/memory/application/memory_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.init();
  runApp(const PantherApp());
}

class PantherApp extends StatelessWidget {
  const PantherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        Provider<AuthRepository>(
          create: (_) => FirebaseBootstrap.isAvailable ? FirebaseAuthRepository() : LocalAuthRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(context.read<AuthRepository>()),
        ),
        ChangeNotifierProxyProvider<AuthController, MemoryController>(
          create: (context) {
            final uid = context.read<AuthController>().user?.uid;
            return MemoryController(_memoryRepositoryFor(uid), uid: uid);
          },
          update: (context, auth, previous) {
            final uid = auth.user?.uid;
            if (previous != null && previous.uid == uid) return previous;
            return MemoryController(_memoryRepositoryFor(uid), uid: uid);
          },
        ),
        ChangeNotifierProxyProvider<MemoryController, ChatController>(
          create: (context) => ChatController(
            aiService: const DemoAiService(),
            memory: context.read<MemoryController>(),
          ),
          update: (context, memory, previous) => previous ?? ChatController(
            aiService: const DemoAiService(),
            memory: memory,
          ),
        ),
      ],
      child: const _AppRoot(),
    );
  }

  MemoryRepository _memoryRepositoryFor(String? uid) {
    if (FirebaseBootstrap.isAvailable && uid != null) {
      return FirestoreMemoryRepository(uid);
    }
    final isDemo = uid == DemoAccount.email;
    return LocalMemoryRepository(seed: isDemo ? DemoAccount.seedMemory() : const []);
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late final router = buildRouter(context.read<AuthController>());

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    return MaterialApp.router(
      title: 'PANTHER',
      debugShowCheckedModeBanner: false,
      themeMode: themeController.flutterThemeMode,
      theme: AppTheme.build(AppPalette.light),
      darkTheme: AppTheme.build(AppPalette.dark),
      routerConfig: router,
      builder: (context, child) => AnimatedTheme(
        data: Theme.of(context),
        duration: const Duration(milliseconds: 220),
        child: child!,
      ),
    );
  }
}
