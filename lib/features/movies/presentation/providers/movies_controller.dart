import '../../../../core/network/yts_api_client.dart';
import '../../data/datasources/yts_movies_remote_data_source.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_list_query.dart';
import '../../domain/entities/movie_page.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_movie_suggestions.dart';
import '../../domain/usecases/list_movies.dart';

abstract interface class MoviesController {
  Future<MoviePage> listMovies(MovieListQuery query);

  Future<Movie> getMovieDetails({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  });

  Future<List<Movie>> getMovieSuggestions(int movieId);
}

class MoviesControllerImpl implements MoviesController {
  const MoviesControllerImpl._(
    this._listMovies,
    this._getMovieDetails,
    this._getMovieSuggestions,
  );

  factory MoviesControllerImpl.yts() {
    final repository = MoviesRepositoryImpl(
      YtsMoviesRemoteDataSourceImpl(DioYtsApiClient()),
    );
    return MoviesControllerImpl._(
      ListMovies(repository),
      GetMovieDetails(repository),
      GetMovieSuggestions(repository),
    );
  }

  final ListMovies _listMovies;
  final GetMovieDetails _getMovieDetails;
  final GetMovieSuggestions _getMovieSuggestions;

  @override
  Future<MoviePage> listMovies(MovieListQuery query) => _listMovies(query);

  @override
  Future<Movie> getMovieDetails({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  }) {
    return _getMovieDetails(
      movieId: movieId,
      withImages: withImages,
      withCast: withCast,
    );
  }

  @override
  Future<List<Movie>> getMovieSuggestions(int movieId) {
    return _getMovieSuggestions(movieId);
  }
}

abstract final class MoviesDependencies {
  static final MoviesController controller = MoviesControllerImpl.yts();
}
