import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app/shell/main_shell.dart';
import 'package:movie_app/features/explore/presentation/screens/explore_screen.dart';
import 'package:movie_app/features/search/presentation/screens/search_screen.dart';

import '../../helpers/fake_movies_controller.dart';
import '../../helpers/localized_test_app.dart';

void main() {
  testWidgets('uses the Explore scaffold instead of a generic placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(
      LocalizedTestApp(
        home: MainShell(moviesController: FakeMoviesController()),
      ),
    );
    await tester.pump();

    // IndexedStack keeps the other tabs offstage but mounted.
    expect(find.byType(ExploreScreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(SearchScreen, skipOffstage: false), findsOneWidget);
  });
}
