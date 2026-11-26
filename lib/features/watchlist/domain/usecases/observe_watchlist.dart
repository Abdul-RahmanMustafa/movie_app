import '../../../movies/domain/entities/movie.dart';
import '../repositories/watchlist_repository.dart';

class ObserveWatchlist {
  const ObserveWatchlist(this._repository);

  final WatchlistRepository _repository;

  Stream<List<Movie>> call() => _repository.observeWatchlist();
}
