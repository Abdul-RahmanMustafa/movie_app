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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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

  final AuthController _authController = AuthController.firebase();

  final PageController _avatarController = PageController(
    initialPage: 4,
    viewportFraction: 0.34,
  );

  int avatar = 4;
  bool _isLoading = false;

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

  Future<void> _submitRegistration() async {
    if (_isLoading || !formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
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

  @override
  void dispose() {
    _avatarController.dispose();

    for (final controller in [name, email, password, confirm, phone]) {
      controller.dispose();
    }

    super.dispose();
  }

  Widget _buildAvatarCarousel(double scale) {
    return SizedBox(
      height: 136 * scale,
      child: PageView.builder(
        controller: _avatarController,
        itemCount: 9,
        onPageChanged: (index) {
          setState(() => avatar = index);
        },
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _avatarController,
            builder: (context, child) {
              final currentPage = _avatarController.hasClients
                  ? (_avatarController.page ?? avatar.toDouble())
                  : avatar.toDouble();

              final distance = (currentPage - index).abs().clamp(0.0, 1.0);

              final size = (136.0 - (42.0 * distance)) * scale;

              return Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: size,
                  height: size,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile/profile${index + 1}.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenSize = MediaQuery.sizeOf(context);

    final scale = math.min(
      1.0,
      math.min(screenSize.width / 430, screenSize.height / 932),
    );

    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed AppBar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * scale),
              child: SizedBox(
                height: 48 * scale,
                child: Row(
                  children: [
                    SizedBox(
                      width: 48 * scale,
                      child: IconButton(
                        onPressed: _isLoading
                            ? null
                            : () => context.go(
                                AuthNavigation.routeWithDestination(
                                  '/login',
                                  _intendedDestination(),
                                ),
                              ),
                        icon: Icon(
                          Icons.arrow_back,
                          color: authYellow,
                          size: 24 * scale,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.register,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: authYellow,
                        ),
                      ),
                    ),
                    SizedBox(width: 48 * scale),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: 24 * scale,
                  vertical: 18 * scale,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400 * scale),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAvatarCarousel(scale),

                          SizedBox(height: 8 * scale),

                          Center(child: Text(l10n.avatar, style: _textStyle)),

                          SizedBox(height: 12 * scale),

                          AuthField(
                            controller: name,
                            hint: l10n.name,
                            iconPath: 'assets/images/auth/ic_name.svg',

                            validator: requiredValidator(l10n),
                          ),

                          SizedBox(height: 14 * scale),

                          AuthField(
                            controller: email,
                            hint: l10n.email,
                            iconPath: 'assets/images/auth/ic_email.png',
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator(l10n),
                          ),

                          SizedBox(height: 14 * scale),

                          AuthField(
                            controller: password,
                            hint: l10n.password,
                            iconPath: 'assets/images/auth/ic_lock.png',
                            obscure: true,
                            validator: passwordValidator(l10n),
                          ),

                          SizedBox(height: 14 * scale),

                          AuthField(
                            controller: confirm,
                            hint: l10n.confirmPassword,
                            iconPath: 'assets/images/auth/ic_lock.png',
                            obscure: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.validationConfirmPassword;
                              }

                              if (value != password.text) {
                                return l10n.validationPasswordsMismatch;
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 14 * scale),

                          AuthField(
                            controller: phone,
                            hint: l10n.phoneNumber,
                            iconPath: 'assets/images/auth/ic_phone.svg',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(
                                    r'^\+?[0-9]{10,15}$',
                                  ).hasMatch(value.trim())) {
                                return l10n.validationPhoneInvalid;
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 18 * scale),

                          AuthButton(
                            text: l10n.createAccount,
                            fontSize: 20,
                            isLoading: _isLoading,
                            onPressed: _submitRegistration,
                          ),

                          SizedBox(height: 16 * scale),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${l10n.alreadyHaveAccount} ',
                                style: _textStyle.copyWith(fontSize: 14),
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
                                child: Text(
                                  l10n.login,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: authYellow,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 18 * scale),

                          const Center(child: LanguageToggle()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
