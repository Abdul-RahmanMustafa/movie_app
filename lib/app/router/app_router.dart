import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../shell/main_shell.dart';
import '../../features/authentication/presentation/providers/auth_controller.dart';
import '../../features/authentication/presentation/providers/auth_session_controller.dart';
import '../../features/authentication/presentation/screens/auth_loading_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/utils/auth_navigation.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/movies/presentation/screens/movie_details_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';

abstract final class AppRouter {
  static final AuthSessionController _authSession = AuthSessionController(
    AuthController.firebase(),
  );

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    refreshListenable: _authSession,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/auth-loading',
        builder: (context, state) => const AuthLoadingScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) {
          final initialEmail = state.extra;
          return ForgotPasswordScreen(
            initialEmail: initialEmail is String ? initialEmail : '',
          );
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const MainShell()),
      GoRoute(
        path: '/movie/:movieId',
        builder: (context, state) => MovieDetailsScreen(
          movieId: int.tryParse(state.pathParameters['movieId'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );

  static String? _redirect(BuildContext _, GoRouterState state) {
    // TEMP_QA_BYPASS: remove after device verification.
    return null;
    // ignore: dead_code
    final location = state.matchedLocation;
    final isLoading = location == '/auth-loading';
    final from = state.uri.queryParameters['from'];

    if (_authSession.status == AuthSessionStatus.checking) {
      if (isLoading) return null;
      return Uri(
        path: '/auth-loading',
        queryParameters: {'from': state.uri.toString()},
      ).toString();
    }

    if (_authSession.status == AuthSessionStatus.unauthenticated) {
      if (isLoading) {
        final destination = Uri.tryParse(from ?? '');
        if (destination != null &&
            (destination.path == '/login' ||
                destination.path == '/register' ||
                destination.path == '/forgot-password')) {
          return destination.toString();
        }
        final protectedDestination = AuthNavigation.safeProtectedDestination(
          from,
        );
        if (protectedDestination != null) {
          return AuthNavigation.routeWithDestination(
            '/login',
            protectedDestination,
          );
        }
        return '/';
      }

      if (AuthNavigation.isProtectedPath(location)) {
        return AuthNavigation.routeWithDestination(
          '/login',
          state.uri.toString(),
        );
      }
      return null;
    }

    if (isLoading) {
      return AuthNavigation.safeProtectedDestination(from) ?? '/home';
    }

    if (location == '/' ||
        location == '/login' ||
        location == '/register' ||
        location == '/forgot-password') {
      return AuthNavigation.safeProtectedDestination(from) ?? '/home';
    }

    return null;
  }
}
