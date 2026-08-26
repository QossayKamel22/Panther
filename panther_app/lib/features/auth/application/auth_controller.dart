import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../data/models/app_user.dart';
import '../../../data/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Owns auth state for the whole app: which user (if any) is signed in, and
/// the loading/error state of in-flight sign-in/register/reset calls. Screens
/// read this via Provider instead of talking to [AuthRepository] directly.
class AuthController extends ChangeNotifier {
  AuthController(this._repository) {
    _sub = _repository.authStateChanges().listen((user) {
      _user = user;
      _status = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _sub;

  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;
  bool _busy = false;
  String? _error;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  bool get busy => _busy;
  String? get error => _error;

  Future<bool> signIn({required String email, required String password}) =>
      _guard(() => _repository.signIn(email: email, password: password));

  Future<bool> register({required String email, required String password}) =>
      _guard(() => _repository.register(email: email, password: password));

  Future<bool> signInWithSocial(SocialProvider provider) =>
      _guard(() => _repository.signInWithSocial(provider));

  Future<bool> signInDemo() => _guard(() => _repository.signInDemo());

  Future<bool> sendPasswordReset(String email) =>
      _guard(() => _repository.sendPasswordReset(email));

  Future<void> signOut() => _repository.signOut();

  Future<bool> _guard(Future<Object?> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      _busy = false;
      notifyListeners();
      return true;
    } on AuthCancelled {
      _busy = false;
      notifyListeners();
      return false;
    } on AuthFailure catch (e) {
      _busy = false;
      _error = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _busy = false;
      _error = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
