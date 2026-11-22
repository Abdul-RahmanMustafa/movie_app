import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_user.dart';
import 'auth_controller.dart';

enum AuthSessionStatus { checking, authenticated, unauthenticated }

class AuthSessionController extends ChangeNotifier {
  AuthSessionController(AuthController authController) {
    _subscription = authController.authStateChanges().listen(
      _handleUserChanged,
      onError: _handleStreamError,
    );
  }

  late final StreamSubscription<AuthUser?> _subscription;

  AuthSessionStatus _status = AuthSessionStatus.checking;
  AuthUser? _user;

  AuthSessionStatus get status => _status;
  AuthUser? get user => _user;

  void _handleUserChanged(AuthUser? user) {
    _user = user;
    _status = user == null
        ? AuthSessionStatus.unauthenticated
        : AuthSessionStatus.authenticated;
    notifyListeners();
  }

  void _handleStreamError(Object _) {
    _user = null;
    _status = AuthSessionStatus.unauthenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
