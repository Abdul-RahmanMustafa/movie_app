import '../../../movies/domain/entities/movie.dart';
import '../../data/datasources/firestore_watchlist_data_source.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/usecases/observe_saved_movie.dart';
import '../../domain/usecases/observe_watchlist.dart';
import '../../domain/usecases/toggle_watchlist_movie.dart';

abstract interface class WatchlistController {
  Stream<List<Movie>> observeWatchlist();

  Stream<bool> observeSaved(int movieId);

  Future<bool> toggle(Movie movie);
}

class WatchlistControllerImpl implements WatchlistController {
  const WatchlistControllerImpl._(
    this._observeWatchlist,
    this._observeSavedMovie,
    this._toggleWatchlistMovie,
  );

  factory WatchlistControllerImpl.firebase() {
    final repository = WatchlistRepositoryImpl(
      FirestoreWatchlistDataSourceImpl(),
    );
    return WatchlistControllerImpl._(
      ObserveWatchlist(repository),
      ObserveSavedMovie(repository),
      ToggleWatchlistMovie(repository),
    );
  }

  final ObserveWatchlist _observeWatchlist;
  final ObserveSavedMovie _observeSavedMovie;
  final ToggleWatchlistMovie _toggleWatchlistMovie;

  @override
  Stream<List<Movie>> observeWatchlist() => _observeWatchlist();

  @override
  Stream<bool> observeSaved(int movieId) => _observeSavedMovie(movieId);

  @override
  Future<bool> toggle(Movie movie) => _toggleWatchlistMovie(movie);
}

abstract final class WatchlistDependencies {
  static final WatchlistController controller =
      WatchlistControllerImpl.firebase();
}
