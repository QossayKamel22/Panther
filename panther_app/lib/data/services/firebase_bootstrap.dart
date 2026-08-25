import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Initializes Firebase and remembers whether it actually succeeded.
///
/// With only placeholder credentials in firebase_options.dart (see that
/// file), `Firebase.initializeApp` throws. Rather than crash the app, every
/// repository checks [FirebaseBootstrap.isAvailable] and falls back to a
/// local, in-memory implementation — the same "never look broken" pattern
/// the web app used for its AI provider.
class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static bool isAvailable = false;

  static Future<void> init() async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.projectId == 'panther-app-placeholder') {
      isAvailable = false;
      debugPrint('Firebase not configured (placeholder credentials), running in local/offline mode.');
      return;
    }
    try {
      await Firebase.initializeApp(options: options);
      isAvailable = true;
    } catch (e) {
      isAvailable = false;
      debugPrint('Firebase unavailable, running in local/offline mode: $e');
    }
  }
}
