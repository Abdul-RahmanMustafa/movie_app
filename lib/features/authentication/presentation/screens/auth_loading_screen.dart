import 'package:flutter/material.dart';

import '../theme/auth_styles.dart';

class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: authBackground,
      body: Center(child: CircularProgressIndicator(color: authYellow)),
    );
  }
}
