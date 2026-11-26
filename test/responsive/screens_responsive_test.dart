import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app/shell/main_shell.dart';
import 'package:movie_app/core/widgets/app_bottom_navigation_bar.dart';
import 'package:movie_app/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:movie_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:movie_app/features/authentication/presentation/screens/register_screen.dart';
import 'package:movie_app/features/explore/presentation/screens/explore_screen.dart';
import 'package:movie_app/features/home/presentation/screens/home_screen.dart';
import 'package:movie_app/features/movies/presentation/screens/movie_details_screen.dart';
import 'package:movie_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movie_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:movie_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:movie_app/features/search/presentation/screens/search_screen.dart';

import '../helpers/fake_auth_controller.dart';
import '../helpers/fake_movies_controller.dart';
import '../helpers/fake_profile_controller.dart';
import '../helpers/fake_watchlist_controller.dart';
import '../helpers/screen_sizes.dart';
import '../helpers/test_fonts.dart';

/// Builds every screen with in-memory controllers so no network or Firebase is
/// required.
final Map<String, Widget Function()> _screens = <String, Widget Function()>{
  'Onboarding': () => const OnboardingScreen(),
  'Login': () => LoginScreen(authController: FakeAuthController()),
  'Register': () => RegisterScreen(authController: FakeAuthController()),
  'Forgot password': () =>
      ForgotPasswordScreen(authController: FakeAuthController()),
  'Home': () => HomeScreen(moviesController: FakeMoviesController()),
  'Explore': () => ExploreScreen(moviesController: FakeMoviesController()),
  'Search': () => SearchScreen(moviesController: FakeMoviesController()),
  'Movie details': () => MovieDetailsScreen(
    movieId: 1,
    moviesController: FakeMoviesController(),
    watchlistController: FakeWatchlistController(),
  ),
  'Profile': () => Scaffold(
    body: ProfileScreen(
      watchlistController: FakeWatchlistController(movies: sampleMovies),
      profileController: FakeProfileController(),
      authController: FakeAuthController(),
    ),
  ),
  'Edit profile': () => EditProfileScreen(
    profileController: FakeProfileController(),
    authController: FakeAuthController(),
  ),
  'Main shell': () => MainShell(
    moviesController: FakeMoviesController(),
    watchlistController: FakeWatchlistController(movies: sampleMovies),
    profileController: FakeProfileController(),
    authController: FakeAuthController(),
  ),
};

void main() {
  setUpAll(loadRobotoForTests);

  for (final entry in _screens.entries) {
    for (final size in kResponsiveScreenSizes) {
      testWidgets('${entry.key} lays out at ${size.name}', (tester) async {
        await pumpScreenAtSize(tester, size, entry.value());

        // First frame builds the screen, the second lets initial data/streams
        // deliver so post-load layouts are covered too.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          tester.takeException(),
          isNull,
          reason:
              '${entry.key} produced a layout error at ${size.name} '
              '(${size.size.width}x${size.size.height}).',
        );
      });
    }

    // Accessibility-sized text: the app clamps system scaling to 1.2, so the
    // same phone widths must still fit with that factor applied.
    for (final size in kResponsiveScreenSizes.where(
      (size) => size.size.width <= 430,
    )) {
      testWidgets('${entry.key} lays out at ${size.name} with 1.2x text', (
        tester,
      ) async {
        await pumpScreenAtSize(
          tester,
          size,
          entry.value(),
          textScaleFactor: 1.2,
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(
          tester.takeException(),
          isNull,
          reason:
              '${entry.key} produced a layout error at ${size.name} '
              '(${size.size.width}x${size.size.height}) with 1.2x text.',
        );
      });
    }
  }

  // The shell adds the bottom navigation bar and swaps all four tabs, so walk
  // every tab at every size instead of only the default Home page.
  for (final size in kResponsiveScreenSizes) {
    testWidgets('Main shell tabs lay out at ${size.name}', (tester) async {
      await pumpScreenAtSize(
        tester,
        size,
        MainShell(
          moviesController: FakeMoviesController(),
          watchlistController: FakeWatchlistController(movies: sampleMovies),
          profileController: FakeProfileController(),
          authController: FakeAuthController(),
        ),
      );
      await tester.pump();

      Finder navItem(int index) => find
          .descendant(
            of: find.byType(AppBottomNavigationBar),
            matching: find.byType(InkWell),
          )
          .at(index);

      for (final index in <int>[
        AppBottomNavigationBar.vectorIndex,
        AppBottomNavigationBar.exploreIndex,
        AppBottomNavigationBar.profileIndex,
        AppBottomNavigationBar.homeIndex,
      ]) {
        await tester.tap(navItem(index));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          tester.takeException(),
          isNull,
          reason:
              'Tab $index produced a layout error at ${size.name} '
              '(${size.size.width}x${size.size.height}).',
        );
      }
    });
  }
}
