import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth_failure.dart';
import '../providers/auth_controller.dart';
import '../theme/auth_styles.dart';
import '../utils/auth_navigation.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/language_toggle.dart';
import '../widgets/play_logo_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.authController});

  final AuthController? authController;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  late final AuthController _authController =
      widget.authController ?? AuthController.firebase();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  bool get _isBusy => _isLoading || _isGoogleLoading;

  String? _intendedDestination() {
    return AuthNavigation.safeProtectedDestination(
      GoRouterState.of(context).uri.queryParameters['from'],
    );
  }

  Future<void> _submitLogin() async {
    if (_isBusy || !formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    AuthFailure? failure;
    try {
      await _authController.login(email: email.text, password: password.text);
    } on AuthFailure catch (error) {
      failure = error;
    } catch (_) {
      failure = const AuthFailure(
        type: AuthFailureType.unexpected,
        message: 'Something went wrong. Please try again.',
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (failure != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
      return;
    }

    context.go(_intendedDestination() ?? '/home');
  }

  Future<void> _submitGoogleLogin() async {
    if (_isBusy) return;
    setState(() => _isGoogleLoading = true);

    AuthFailure? failure;
    try {
      await _authController.loginWithGoogle();
    } on AuthFailure catch (error) {
      failure = error;
    } catch (_) {
      failure = const AuthFailure(
        type: AuthFailureType.unexpected,
        message: 'Something went wrong. Please try again.',
      );
    }

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);

    if (failure != null) {
      if (failure.type != AuthFailureType.cancelled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      }
      return;
    }

    context.go(_intendedDestination() ?? '/home');
  }

  void _openForgotPassword() {
    final route = AuthNavigation.routeWithDestination(
      '/forgot-password',
      _intendedDestination(),
    );
    context.push(route, extra: email.text.trim());
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: authBackground,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 14),
                  Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CustomPaint(painter: PlayLogoPainter()),
                    ),
                  ),
                  const SizedBox(height: 42),
                  AuthField(
                    controller: email,
                    hint: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: password,
                    hint: 'Password',
                    icon: Icons.lock,
                    obscure: true,
                    validator: requiredValidator,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isBusy ? null : _openForgotPassword,
                      child: const Text(
                        'Forget Password ?',
                        style: TextStyle(color: authYellow, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AuthButton(
                    text: 'Login',
                    isLoading: _isLoading,
                    onPressed: _submitLogin,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have Account ? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: _isBusy
                            ? null
                            : () => context.go(
                                AuthNavigation.routeWithDestination(
                                  '/register',
                                  _intendedDestination(),
                                ),
                              ),
                        child: const Text(
                          'Create One',
                          style: TextStyle(
                            fontSize: 12,
                            color: authYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: authYellow, indent: 65),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(color: authYellow, fontSize: 12),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: authYellow, endIndent: 65),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    text: 'Login With Google',
                    isLoading: _isGoogleLoading,
                    leading: const Text(
                      'G',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    onPressed: _submitGoogleLogin,
                  ),
                  const SizedBox(height: 28),
                  const Center(child: LanguageToggle()),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
