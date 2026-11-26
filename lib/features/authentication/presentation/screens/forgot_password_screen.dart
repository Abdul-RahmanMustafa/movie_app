
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../domain/auth_failure.dart';
import '../providers/auth_controller.dart';
import '../theme/auth_styles.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController.firebase();
  late final TextEditingController _emailController;

  bool _isLoading = false;

  static const TextStyle _textStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.initialEmail.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    AuthFailure? failure;
    try {
      await _authController.sendPasswordResetEmail(
        _emailController.text,
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
          content: Text(failure.message, style: _textStyle),
        ),
      );
      return;
    }

    final normalizedEmail =
    _emailController.text.trim().toLowerCase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'If an account exists for $normalizedEmail, a password reset email '
              'has been sent. Check your inbox and spam folder.',
          style: _textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final scale = math.min(
      1.0,
      math.min(
        screenSize.width / 430,
        screenSize.height / 932,
      ),
    );

    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * scale),
              child: SizedBox(
                height: 48 * scale,
                child: Row(
                  children: [
                    SizedBox(
                      width: 48 * scale,
                      child: IconButton(
                        onPressed: _isLoading ? null : () => context.pop(),
                        alignment: Alignment.centerLeft,
                        icon: Icon(
                          Icons.arrow_back,
                          color: authYellow,
                          size: 24 * scale,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Forget Password',
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      24 * scale,
                      8 * scale,
                      24 * scale,
                      keyboardInset + 24 * scale,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(
                          0.0,
                          constraints.maxHeight - 32 * scale,
                        ),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 400 * scale,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 8 * scale),

                                Center(
                                  child: Image.asset(
                                    AppAssets.forgotPasswordIllustration,
                                    width: (constraints.maxWidth * 0.8)
                                        .clamp(220.0, 330.0)
                                        .toDouble(),
                                    height: (constraints.maxHeight * 0.42)
                                        .clamp(220.0, 350.0)
                                        .toDouble(),
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                SizedBox(height: 28 * scale),

                                AuthField(
                                  controller: _emailController,
                                  hint: 'Email',
                                  iconPath:
                                  'assets/images/auth/ic_email.png',
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  validator: emailValidator,
                                ),

                                SizedBox(height: 20 * scale),

                                AuthButton(
                                  text: 'Verify Email',
                                  isLoading: _isLoading,
                                  onPressed: _verifyEmail,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
