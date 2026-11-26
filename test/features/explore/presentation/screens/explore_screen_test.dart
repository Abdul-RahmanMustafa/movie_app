import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/explore/presentation/screens/explore_screen.dart';
import 'package:movie_app/features/explore/presentation/widgets/explore_genre_chip.dart';
import 'package:movie_app/features/explore/presentation/widgets/explore_movie_card.dart';

import '../../../../helpers/fake_movies_controller.dart';
import '../../../../helpers/localized_test_app.dart';
import '../../../../helpers/test_surface.dart';

void main() {
  testWidgets('renders API-backed movies in the Figma Browse grid', (
    tester,
  ) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(
      LocalizedTestApp(
        home: ExploreScreen(moviesController: FakeMoviesController()),
      ),
    );
    await tester.pump();

    // Figma "Browse" frame genre groups. The list scrolls horizontally, so
    // only the first three chips are built in the default test viewport.
    expect(find.byType(ExploreGenreChip), findsNWidgets(3));
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Adventure'), findsOneWidget);
    expect(find.text('Animation'), findsOneWidget);

    final genreList = find.byWidgetPredicate(
      (widget) =>
          widget is ListView && widget.scrollDirection == Axis.horizontal,
    );
    await tester.drag(genreList, const Offset(-1000, 0));
    await tester.pumpAndSettle();
    expect(find.text('Biography'), findsOneWidget);

    // Figma 2 x 2 poster grid now contains real entity values.
    expect(find.byType(ExploreMovieCard), findsNWidgets(4));
    for (final index in [0, 1, 2, 3]) {
      expect(find.byKey(Key('explore_movie_slot_$index')), findsOneWidget);
      expect(find.byKey(Key('explore_rating_slot_$index')), findsOneWidget);
    }
    expect(find.text('First Movie'), findsOneWidget);
    expect(find.text('8.1'), findsOneWidget);
  });

  testWidgets('top genre buttons move the selected highlight', (tester) async {
    usePhoneSurface(tester);
    final controller = FakeMoviesController();
    await tester.pumpWidget(
      LocalizedTestApp(home: ExploreScreen(moviesController: controller)),
    );
    await tester.pump();

    ExploreGenreChip chipAt(int index) => tester.widget<ExploreGenreChip>(
      find.byKey(Key('explore_genre_slot_$index')),
    );

    expect(chipAt(0).selected, isTrue);
    expect(chipAt(1).selected, isFalse);
    expect(chipAt(1).onTap, isNotNull);

    await tester.tap(find.byKey(Key('explore_genre_slot_1')));
    await tester.pump();

    expect(chipAt(0).selected, isFalse);
    expect(chipAt(1).selected, isTrue);
    expect(controller.queries.last.genre, 'Adventure');

    await tester.tap(find.byKey(Key('explore_genre_slot_0')));
    await tester.pump();

    expect(chipAt(0).selected, isTrue);
    expect(chipAt(1).selected, isFalse);
  });
}
