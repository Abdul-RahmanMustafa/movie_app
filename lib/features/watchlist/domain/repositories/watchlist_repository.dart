import '../../../movies/domain/entities/movie.dart';

abstract interface class WatchlistRepository {
  Stream<List<Movie>> observeWatchlist();

  Stream<bool> observeSaved(int movieId);

  Future<bool> toggle(Movie movie);
}
