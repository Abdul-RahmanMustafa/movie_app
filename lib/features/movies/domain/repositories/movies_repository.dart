import '../entities/movie.dart';
import '../entities/movie_list_query.dart';
import '../entities/movie_page.dart';

abstract interface class MoviesRepository {
  Future<MoviePage> listMovies(MovieListQuery query);

  Future<Movie> getMovieDetails({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  });

  Future<List<Movie>> getMovieSuggestions(int movieId);
}
