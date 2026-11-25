import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../../domain/watchlist_failure.dart';
import '../datasources/firestore_watchlist_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  const WatchlistRepositoryImpl(this._dataSource);

  final FirestoreWatchlistDataSource _dataSource;

  @override
  Stream<List<Movie>> observeWatchlist() {
    try {
      return _dataSource.observeWatchlist().handleError(
        (Object error) => throw _mapFailure(error),
      );
    } catch (error) {
      return Stream.error(_mapFailure(error));
    }
  }

  @override
  Stream<bool> observeSaved(int movieId) {
    try {
      return _dataSource
          .observeSaved(movieId)
          .handleError((Object error) => throw _mapFailure(error));
    } catch (error) {
      return Stream.error(_mapFailure(error));
    }
  }

  @override
  Future<bool> toggle(Movie movie) async {
    try {
      return await _dataSource.toggle(movie);
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  WatchlistFailure _mapFailure(Object error) {
    if (error is WatchlistFailure) return error;
    if (error is WatchlistDataException) {
      return switch (error.type) {
        WatchlistDataFailureType.unauthenticated => const WatchlistFailure(
          type: WatchlistFailureType.unauthenticated,
          message: 'Please sign in to use your Watch List.',
        ),
        WatchlistDataFailureType.invalidData => const WatchlistFailure(
          type: WatchlistFailureType.invalidData,
          message: 'A saved movie could not be loaded.',
        ),
      };
    }
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return const WatchlistFailure(
          type: WatchlistFailureType.permissionDenied,
          message: 'You do not have permission to update this Watch List.',
        );
      }
      if (error.code == 'unavailable' ||
          error.code == 'deadline-exceeded' ||
          error.code == 'network-request-failed') {
        return const WatchlistFailure(
          type: WatchlistFailureType.network,
          message: 'Could not reach your Watch List. Check your connection.',
        );
      }
    }
    return const WatchlistFailure(
      type: WatchlistFailureType.unexpected,
      message: 'Something went wrong with your Watch List.',
    );
  }
}
