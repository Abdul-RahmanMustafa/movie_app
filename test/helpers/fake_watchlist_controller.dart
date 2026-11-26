import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/watchlist/presentation/providers/watchlist_controller.dart';

/// In-memory watchlist controller for widget tests.
class FakeWatchlistController implements WatchlistController {
  FakeWatchlistController({this.movies = const <Movie>[]});

  final List<Movie> movies;

  @override
  Stream<List<Movie>> observeWatchlist() => Stream<List<Movie>>.value(movies);

  @override
  Stream<bool> observeSaved(int movieId) =>
      Stream<bool>.value(movies.any((movie) => movie.id == movieId));

  @override
  Future<bool> toggle(Movie movie) async => true;
}
