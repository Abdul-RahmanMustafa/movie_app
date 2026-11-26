import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/presentation/screens/movie_details_screen.dart';
import 'package:movie_app/features/watchlist/presentation/providers/watchlist_controller.dart';

import '../../../../helpers/fake_movies_controller.dart';
import '../../../../helpers/localized_test_app.dart';

void main() {
  testWidgets('renders supported details and recommendations', (tester) async {
    await tester.pumpWidget(
      LocalizedTestApp(
        home: MovieDetailsScreen(
          movieId: 1,
          moviesController: FakeMoviesController(),
          watchlistController: _FakeWatchlistController(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('First Movie'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);
    expect(find.text('8.1'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('First synopsis.'), findsOneWidget);
    expect(find.text('First Actor'), findsOneWidget);
    expect(find.text('Similar Movies'), findsOneWidget);
  });
}

class _FakeWatchlistController implements WatchlistController {
  @override
  Stream<List<Movie>> observeWatchlist() => Stream.value(const []);

  @override
  Stream<bool> observeSaved(int movieId) => Stream.value(false);

  @override
  Future<bool> toggle(Movie movie) async => true;
}
