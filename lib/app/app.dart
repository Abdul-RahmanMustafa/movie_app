import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key, this.routerConfig});

  final GoRouter? routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Movie',
      theme: AppTheme.darkTheme,
      routerConfig: routerConfig ?? AppRouter.router,
    );
  }
}
