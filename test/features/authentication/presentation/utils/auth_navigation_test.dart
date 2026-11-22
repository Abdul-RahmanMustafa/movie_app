import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/authentication/presentation/utils/auth_navigation.dart';

void main() {
  group('AuthNavigation', () {
    test('accepts local protected destinations', () {
      expect(
        AuthNavigation.safeProtectedDestination('/edit-profile?from=profile'),
        '/edit-profile?from=profile',
      );
      expect(AuthNavigation.safeProtectedDestination('/movie/42'), '/movie/42');
    });

    test('rejects public and external destinations', () {
      expect(AuthNavigation.safeProtectedDestination('/login'), isNull);
      expect(
        AuthNavigation.safeProtectedDestination('https://example.com/home'),
        isNull,
      );
    });

    test('carries a protected destination through an auth route', () {
      expect(
        AuthNavigation.routeWithDestination('/login', '/edit-profile'),
        '/login?from=%2Fedit-profile',
      );
    });
  });
}
