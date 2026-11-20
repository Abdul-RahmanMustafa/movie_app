import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

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
          Center(child: SizedBox(height: 120, width: 120, child: CustomPaint(painter: _PlayLogoPainter()))),
          const SizedBox(height: 42),
          AuthField(controller: email, hint: 'Email', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: emailValidator),
          const SizedBox(height: 16),
          AuthField(controller: password, hint: 'Password', icon: Icons.lock, obscure: true, validator: passwordValidator),
          Align(alignment: Alignment.centerRight, child: TextButton(
            onPressed: () => showPending(context, 'Password reset'),
            child: const Text('Forget Password ?', style: TextStyle(color: authYellow, fontSize: 12)),
          )),
          const SizedBox(height: 12),
          AuthButton(text: 'Login', onPressed: () {
            if (formKey.currentState!.validate()) showPending(context, 'Login');
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

class _PlayLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = authYellow..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawCircle(Offset(size.width * .58, size.height * .5), size.width * .37, stroke);
    final path = Path()
      ..moveTo(size.width * .23, size.height * .24)
      ..lineTo(size.width * .23, size.height * .76)
      ..lineTo(size.width * .64, size.height * .5)
      ..close();
    canvas.drawPath(path, Paint()..color = authYellow..style = PaintingStyle.stroke..strokeWidth = 12..strokeJoin = StrokeJoin.round);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
