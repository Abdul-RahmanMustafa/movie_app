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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.authController});

  final AuthController? authController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  final phone = TextEditingController();
  late final AuthController _authController =
      widget.authController ?? AuthController.firebase();
  int avatar = 1;
  bool _isLoading = false;

  String? _intendedDestination() {
    return AuthNavigation.safeProtectedDestination(
      GoRouterState.of(context).uri.queryParameters['from'],
    );
  }

  Future<void> _submitRegistration() async {
    if (_isLoading || !formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    AuthFailure? failure;
    try {
      await _authController.register(
        name: name.text,
        email: email.text,
        password: password.text,
        phone: phone.text,
        avatarIndex: avatar,
      );
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

  @override
  void dispose() {
    for (final c in [name, email, password, confirm, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: authBackground,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.go(
                                AuthNavigation.routeWithDestination(
                                  '/login',
                                  _intendedDestination(),
                                ),
                              ),
                        icon: const Icon(Icons.arrow_back, color: authYellow),
                      ),
                      const Expanded(
                        child: Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: authYellow, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => GestureDetector(
                        onTap: () => setState(() => avatar = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: i == avatar ? 112 : 74,
                          height: i == avatar ? 112 : 74,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: [
                              const Color(0xFFB6E9FC),
                              const Color(0xFF8DD5F1),
                              const Color(0xFFB5E7F5),
                            ][i],
                            border: Border.all(
                              color: avatar == i
                                  ? authYellow
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              [Icons.face_6, Icons.face, Icons.face_3][i],
                              color: [
                                Colors.teal,
                                Colors.deepOrange,
                                Colors.brown,
                              ][i],
                              size: i == avatar ? 76 : 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text('Avatar', style: TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(height: 12),
                  AuthField(
                    controller: name,
                    hint: 'Name',
                    icon: Icons.badge_outlined,
                    validator: requiredValidator,
                  ),
                  const SizedBox(height: 14),
                  AuthField(
                    controller: email,
                    hint: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 14),
                  AuthField(
                    controller: password,
                    hint: 'Password',
                    icon: Icons.lock,
                    obscure: true,
                    validator: passwordValidator,
                  ),
                  const SizedBox(height: 14),
                  AuthField(
                    controller: confirm,
                    hint: 'Confirm Password',
                    icon: Icons.lock,
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value != password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthField(
                    controller: phone,
                    hint: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value == null ||
                            !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value.trim())
                        ? 'Enter a valid phone number'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  AuthButton(
                    text: 'Create Account',
                    isLoading: _isLoading,
                    onPressed: _submitRegistration,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Have Account ? ',
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () => context.go(
                                AuthNavigation.routeWithDestination(
                                  '/login',
                                  _intendedDestination(),
                                ),
                              ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: authYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
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
