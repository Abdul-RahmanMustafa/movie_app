import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../domain/auth_failure.dart';
import '../providers/auth_controller.dart';
import '../theme/auth_styles.dart';
import '../utils/auth_navigation.dart';
import '../utils/auth_failure_localization.dart';
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

  static const TextStyle _textStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizedAuthFailure(context.l10n, failure),
            style: _textStyle,
          ),
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizedAuthFailure(context.l10n, failure),
              style: _textStyle,
            ),
          ),
        );
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenSize = MediaQuery.sizeOf(context);
    final safeTop = MediaQuery.viewPaddingOf(context).top;

    final scale = math.min(
      1.0,
      math.min(screenSize.width / 430, screenSize.height / 932),
    );

    final topSpacing = math.max(0.0, (67 * scale) - safeTop);

    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400 * scale),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: topSpacing),

                    Center(
                      child: SizedBox(
                        height: 120 * scale,
                        width: 120 * scale,
                        child: CustomPaint(painter: PlayLogoPainter()),
                      ),
                    ),

                    SizedBox(height: 69 * scale),

                    AuthField(
                      controller: email,
                      hint: l10n.email,
                      iconPath: 'assets/images/auth/ic_email.png',
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator(l10n),
                    ),

                    SizedBox(height: 22.5 * scale),

                    AuthField(
                      controller: password,
                      hint: l10n.password,
                      iconPath: 'assets/images/auth/ic_lock.png',
                      obscure: true,
                      validator: requiredValidator(l10n),
                    ),

                    SizedBox(height: 10 * scale),

                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: _isBusy ? null : _openForgotPassword,
                        child: Text(
                          l10n.forgotPasswordQuestion,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: authYellow,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 33 * scale),

                    AuthButton(
                      text: l10n.login,
                      isLoading: _isLoading,
                      onPressed: _submitLogin,
                    ),

                    SizedBox(height: 23 * scale),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${l10n.dontHaveAccount} ', style: _textStyle),
                        GestureDetector(
                          onTap: _isBusy
                              ? null
                              : () => context.go(
                                  AuthNavigation.routeWithDestination(
                                    '/register',
                                    _intendedDestination(),
                                  ),
                                ),
                          child: Text(
                            l10n.createOne,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: authYellow,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28 * scale),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: authYellow, indent: 65),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            l10n.commonOr,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: authYellow,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: authYellow, endIndent: 65),
                        ),
                      ],
                    ),

                    SizedBox(height: 28 * scale),

                    AuthButton(
                      text: l10n.loginWithGoogle,
                      isLoading: _isGoogleLoading,
                      leading: Image.asset(
                        'assets/images/auth/ic_google.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      onPressed: _submitGoogleLogin,
                    ),

                    SizedBox(height: 33 * scale),

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
}
