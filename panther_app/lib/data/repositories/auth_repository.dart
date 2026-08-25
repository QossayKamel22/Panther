import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/app_user.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Single abstraction the UI talks to for auth — screens never import
/// `firebase_auth` directly, so the demo/local fallback and the real
/// Firebase path are interchangeable behind one interface.
abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<AppUser> signIn({required String email, required String password});
  Future<AppUser> register({required String email, required String password});
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  fb.FirebaseAuth get _auth => fb.FirebaseAuth.instance;

  AppUser _map(fb.User u) => AppUser(uid: u.uid, email: u.email, displayName: u.displayName, photoUrl: u.photoURL);

  @override
  Stream<AppUser?> authStateChanges() => _auth.authStateChanges().map((u) => u == null ? null : _map(u));

  @override
  AppUser? get currentUser {
    final u = _auth.currentUser;
    return u == null ? null : _map(u);
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _map(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyMessage(e));
    }
  }

  @override
  Future<AppUser> register({required String email, required String password}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _map(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyMessage(e));
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyMessage(e));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  String _friendlyMessage(fb.FirebaseAuthException e) => switch (e.code) {
        'user-not-found' || 'wrong-password' || 'invalid-credential' => 'Incorrect email or password.',
        'email-already-in-use' => 'An account with this email already exists.',
        'weak-password' => 'Choose a stronger password (at least 6 characters).',
        'invalid-email' => 'That email address looks invalid.',
        'network-request-failed' => 'Network error — check your connection and try again.',
        'operation-not-allowed' || 'configuration-not-found' =>
          'Email/password sign-in isn\'t enabled on this Firebase project yet — enable it in the Firebase console under Authentication > Sign-in method.',
        _ => e.message ?? 'Something went wrong. Please try again.',
      };
}

/// In-memory stand-in used when no Firebase project is configured yet (see
/// [FirebaseBootstrap]). Lets every auth screen be built and exercised end to
/// end — including validation and error states — without a live backend.
class LocalAuthRepository implements AuthRepository {
  AppUser? _user;
  final _controller = StreamController<AppUser?>.broadcast();

  final Map<String, String> _accounts = {};

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  AppUser? get currentUser => _user;

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final stored = _accounts[email];
    if (stored == null || stored != password) {
      throw const AuthFailure('Incorrect email or password.');
    }
    final user = AppUser(uid: email, email: email, displayName: email.split('@').first);
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppUser> register({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (_accounts.containsKey(email)) {
      throw const AuthFailure('An account with this email already exists.');
    }
    if (password.length < 6) {
      throw const AuthFailure('Choose a stronger password (at least 6 characters).');
    }
    _accounts[email] = password;
    final user = AppUser(uid: email, email: email, displayName: email.split('@').first);
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!_accounts.containsKey(email)) {
      throw const AuthFailure('No account found with that email.');
    }
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}
