import 'package:go_router/go_router.dart';
import '../shell/main_shell.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    // Login is the entry point again; Home stays available at /home.
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/login'),
      GoRoute(path: '/home', builder: (context, state) => const MainShell()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    ],
  );
}
