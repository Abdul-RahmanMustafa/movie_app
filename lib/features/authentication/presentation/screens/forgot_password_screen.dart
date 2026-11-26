import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../domain/auth_failure.dart';
import '../providers/auth_controller.dart';
import '../theme/auth_styles.dart';
import '../utils/auth_validators.dart';
import '../utils/auth_failure_localization.dart';
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

  static const TextStyle _textStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

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

    final normalizedEmail = _emailController.text.trim().toLowerCase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.passwordResetPrivacyMessage(normalizedEmail),
          style: _textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenSize = MediaQuery.sizeOf(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final scale = math.min(
      1.0,
      math.min(screenSize.width / 430, screenSize.height / 932),
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
                        alignment: AlignmentDirectional.centerStart,
                        icon: Icon(
                          Icons.arrow_back,
                          color: authYellow,
                          size: 24 * scale,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.forgotPassword,
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
                          constraints: BoxConstraints(maxWidth: 400 * scale),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  hint: l10n.email,
                                  iconPath: 'assets/images/auth/ic_email.png',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: emailValidator(l10n),
                                ),

                                SizedBox(height: 20 * scale),

                                AuthButton(
                                  text: l10n.verifyEmail,
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
