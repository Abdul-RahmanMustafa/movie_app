import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app/shell/main_shell.dart';
import 'package:movie_app/core/widgets/app_bottom_navigation_bar.dart';
import 'package:movie_app/features/explore/presentation/screens/explore_screen.dart';
import 'package:movie_app/features/home/presentation/screens/home_screen.dart';
import 'package:movie_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:movie_app/features/search/presentation/screens/search_screen.dart';

import '../../helpers/fake_auth_controller.dart';
import '../../helpers/fake_movies_controller.dart';
import '../../helpers/fake_profile_controller.dart';
import '../../helpers/fake_watchlist_controller.dart';
import '../../helpers/test_surface.dart';

void main() {
  testWidgets('mounts tabs on first visit and keeps them alive', (
    tester,
  ) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(home: MainShell(moviesController: FakeMoviesController())),
    );
    await tester.pump();

    Finder navItem(int index) => find
        .descendant(
          of: find.byType(AppBottomNavigationBar),
          matching: find.byType(InkWell),
        )
        .at(index);

    // Only Home runs its initial network work at startup.
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ExploreScreen, skipOffstage: false), findsNothing);
    expect(find.byType(SearchScreen, skipOffstage: false), findsNothing);

    await tester.tap(navItem(AppBottomNavigationBar.exploreIndex));
    await tester.pump();
    expect(find.byType(ExploreScreen, skipOffstage: false), findsOneWidget);

    await tester.tap(navItem(AppBottomNavigationBar.vectorIndex));
    await tester.pump();
    expect(find.byType(SearchScreen, skipOffstage: false), findsOneWidget);

    // Returning to a visited tab reuses the same mounted page.
    await tester.tap(navItem(AppBottomNavigationBar.homeIndex));
    await tester.pump();
    expect(find.byType(HomeScreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(ExploreScreen, skipOffstage: false), findsOneWidget);
  });

  testWidgets('loads profile data on the first profile visit', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: MainShell(
          moviesController: FakeMoviesController(),
          watchlistController: FakeWatchlistController(movies: sampleMovies),
          profileController: FakeProfileController(),
          authController: FakeAuthController(),
        ),
      ),
    );
    await tester.pump();

    final profileTab = find
        .descendant(
          of: find.byType(AppBottomNavigationBar),
          matching: find.byType(InkWell),
        )
        .at(AppBottomNavigationBar.profileIndex);

    // One tap must be enough: the first visit has to start its own loading.
    await tester.tap(profileTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('QA User'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ProfileScreen),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsNothing,
    );

    final editButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Edit Profile'),
    );
    expect(editButton.onPressed, isNotNull);
  });
}
