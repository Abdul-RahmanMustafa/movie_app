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
  const ForgotPasswordScreen({
    super.key,
    this.initialEmail = '',
    this.authController,
  });

  final String initialEmail;
  final AuthController? authController;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthController _authController =
      widget.authController ?? AuthController.firebase();
  late final TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail.trim());
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
      await _authController.sendPasswordResetEmail(_emailController.text);
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

    final normalizedEmail = _emailController.text.trim().toLowerCase();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'If an account exists for $normalizedEmail, a password reset email '
          'has been sent. Check your inbox and spam folder.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: authBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(24, 12, 24, keyboardInset + 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 36,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 48,
                                child: IconButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => context.pop(),
                                  alignment: Alignment.centerLeft,
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: authYellow,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Forget Password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: authYellow,
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 38),
                          Center(
                            child: Image.asset(
                              AppAssets.forgotPasswordIllustration,
                              width: constraints.maxWidth
                                  .clamp(260.0, 330.0)
                                  .toDouble(),
                              height: (constraints.maxHeight * 0.42)
                                  .clamp(250.0, 350.0)
                                  .toDouble(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 38),
                          AuthField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                          ),
                          const SizedBox(height: 20),
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
    );
  }
}
