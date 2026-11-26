import '../../../movies/domain/entities/movie.dart';
import '../repositories/watchlist_repository.dart';

class ToggleWatchlistMovie {
  const ToggleWatchlistMovie(this._repository);

  final WatchlistRepository _repository;

  Future<bool> call(Movie movie) => _repository.toggle(movie);
}
