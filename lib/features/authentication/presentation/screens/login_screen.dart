import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/auth_styles.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/language_toggle.dart';
import '../widgets/play_logo_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  // Prefilled demo credentials so the Login button can be tried immediately.
  // The fields use requiredValidator (not the strict email/password rules)
  // because 'route1' is a username and is shorter than the 8-char rule.
  final email = TextEditingController(text: 'route1');
  final password = TextEditingController(text: 'route1');

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: authBackground,
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400), child: Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 14),
          Center(child: SizedBox(height: 120, width: 120, child: CustomPaint(painter: PlayLogoPainter()))),
          const SizedBox(height: 42),
          AuthField(controller: email, hint: 'Email', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: requiredValidator),
          const SizedBox(height: 16),
          AuthField(controller: password, hint: 'Password', icon: Icons.lock, obscure: true, validator: requiredValidator),
          Align(alignment: Alignment.centerRight, child: TextButton(
            onPressed: () => showPending(context, 'Password reset'),
            child: const Text('Forget Password ?', style: TextStyle(color: authYellow, fontSize: 12)),
          )),
          const SizedBox(height: 12),
          AuthButton(text: 'Login', onPressed: () {
            // UI-only pass: a valid demo form enters the app at Home.
            // Replace with Firebase Auth once backend integration lands.
            if (formKey.currentState!.validate()) context.go('/home');
          }),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Don't Have Account ? ", style: TextStyle(fontSize: 12)),
            GestureDetector(onTap: () => context.go('/register'), child: const Text('Create One', style: TextStyle(fontSize: 12, color: authYellow, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 24),
          Row(children: [const Expanded(child: Divider(color: authYellow, indent: 65)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('OR', style: TextStyle(color: authYellow, fontSize: 12))),
            const Expanded(child: Divider(color: authYellow, endIndent: 65))]),
          const SizedBox(height: 24),
          AuthButton(text: 'Login With Google', leading: const Text('G', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), onPressed: () => showPending(context, 'Google Sign-In')),
          const SizedBox(height: 28),
          const Center(child: LanguageToggle()),
        ]),
      )),
    ))),
  );
}
