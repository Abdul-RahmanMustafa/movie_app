import '../../../../core/network/yts_api_client.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_list_query.dart';
import '../../domain/entities/movie_page.dart';
import '../../domain/movie_failure.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/yts_movies_remote_data_source.dart';
import '../models/yts_envelope_model.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl(this._remoteDataSource);

  final YtsMoviesRemoteDataSource _remoteDataSource;

  // Small in-memory cache so switching genres or reopening a movie is instant
  // instead of issuing the same YTS request again.
  final Map<String, _CacheEntry> _cache = <String, _CacheEntry>{};
  static const Duration _cacheTtl = Duration(minutes: 5);
  static const int _maxCacheEntries = 40;

  @override
  Future<MoviePage> listMovies(MovieListQuery query) {
    final key =
        'list:${query.page}:${query.limit}:${query.queryTerm}:'
        '${query.genre}:${query.minimumRating}:${query.sortBy}:${query.order}';
    return _cached(
      key,
      () => _guard(() => _remoteDataSource.listMovies(query)),
    );
  }

  @override
  Future<Movie> getMovieDetails({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  }) {
    return _cached(
      'details:$movieId:$withImages:$withCast',
      () => _guard(
        () => _remoteDataSource.getMovieDetails(
          movieId: movieId,
          withImages: withImages,
          withCast: withCast,
        ),
      ),
    );
  }

  @override
  Future<List<Movie>> getMovieSuggestions(int movieId) {
    return _cached(
      'suggestions:$movieId',
      () => _guard(() => _remoteDataSource.getMovieSuggestions(movieId)),
    );
  }

  /// Returns a cached value when it is still fresh; only successful results
  /// are stored so a failed request is retried on the next attempt.
  Future<T> _cached<T extends Object>(
    String key,
    Future<T> Function() load,
  ) async {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired(_cacheTtl)) {
      return entry.value as T;
    }

    final value = await load();
    if (_cache.length >= _maxCacheEntries) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = _CacheEntry(value, DateTime.now());
    return value;
  }

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on YtsApiClientException catch (error) {
      throw switch (error.type) {
        YtsApiClientFailureType.network => const MovieFailure(
          type: MovieFailureType.network,
          message: 'No network connection. Please try again.',
        ),
        YtsApiClientFailureType.timeout => const MovieFailure(
          type: MovieFailureType.timeout,
          message: 'The movie service took too long to respond.',
        ),
        YtsApiClientFailureType.invalidResponse => const MovieFailure(
          type: MovieFailureType.invalidResponse,
          message: 'The movie service returned an invalid response.',
        ),
      };
    } on YtsApiException catch (error) {
      throw MovieFailure(
        type: MovieFailureType.api,
        message: error.message.trim().isEmpty
            ? 'The movie service could not complete the request.'
            : error.message,
      );
    } on YtsInvalidResponseException {
      throw const MovieFailure(
        type: MovieFailureType.invalidResponse,
        message: 'The movie service returned an invalid response.',
      );
    } on MovieFailure {
      rethrow;
    } catch (_) {
      throw const MovieFailure(
        type: MovieFailureType.unexpected,
        message: 'Something went wrong while loading movies.',
      );
    }
  }
}

class _CacheEntry {
  const _CacheEntry(this.value, this.createdAt);

  final Object value;
  final DateTime createdAt;

  bool isExpired(Duration ttl) => DateTime.now().difference(createdAt) > ttl;
}
