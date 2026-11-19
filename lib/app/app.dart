import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie',
      theme: AppTheme.darkTheme,
      home: const Scaffold(),
    );
  }
}
