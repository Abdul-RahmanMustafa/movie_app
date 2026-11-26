import '../repositories/watchlist_repository.dart';

class ObserveSavedMovie {
  const ObserveSavedMovie(this._repository);

  final WatchlistRepository _repository;

  Stream<bool> call(int movieId) => _repository.observeSaved(movieId);
}
