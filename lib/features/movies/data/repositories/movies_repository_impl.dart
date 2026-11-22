import '../../../../core/network/yts_api_client.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_list_query.dart';
import '../../domain/entities/movie_page.dart';
import '../../domain/movie_failure.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/yts_movies_remote_data_source.dart';
import '../models/yts_envelope_model.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl(this._remoteDataSource);

  final YtsMoviesRemoteDataSource _remoteDataSource;

  @override
  Future<MoviePage> listMovies(MovieListQuery query) {
    return _guard(() => _remoteDataSource.listMovies(query));
  }

  @override
  Future<Movie> getMovieDetails({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  }) {
    return _guard(
      () => _remoteDataSource.getMovieDetails(
        movieId: movieId,
        withImages: withImages,
        withCast: withCast,
      ),
    );
  }

  @override
  Future<List<Movie>> getMovieSuggestions(int movieId) {
    return _guard(() => _remoteDataSource.getMovieSuggestions(movieId));
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
