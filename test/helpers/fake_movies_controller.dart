import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/entities/movie_list_query.dart';
import 'package:movie_app/features/movies/domain/entities/movie_page.dart';
import 'package:movie_app/features/movies/presentation/providers/movies_controller.dart';

typedef ListMoviesHandler = Future<MoviePage> Function(MovieListQuery query);

class FakeMoviesController implements MoviesController {
  FakeMoviesController({
    List<Movie>? movies,
    this.listMoviesHandler,
    Movie? details,
    List<Movie>? suggestions,
  }) : movies = movies ?? sampleMovies,
       details = details ?? sampleMovies.first,
       suggestions = suggestions ?? sampleMovies.skip(1).toList();

  final List<Movie> movies;
  final Movie details;
  final List<Movie> suggestions;
  final ListMoviesHandler? listMoviesHandler;
  final List<MovieListQuery> queries = [];

  @override
  Future<MoviePage> listMovies(MovieListQuery query) {
    queries.add(query);
    final handler = listMoviesHandler;
    if (handler != null) return handler(query);
    return Future.value(
      MoviePage(
        movies: movies,
        movieCount: movies.length,
        limit: query.limit,
        pageNumber: query.page,
      ),
    );
  }

  @override
  Future<Movie> getMovieDetails({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  }) async {
    return details;
  }

  @override
  Future<List<Movie>> getMovieSuggestions(int movieId) async => suggestions;
}

const sampleMovies = [
  Movie(
    id: 1,
    title: 'First Movie',
    year: 2024,
    rating: 8.1,
    genres: ['Action'],
    description: 'First synopsis.',
    smallPosterUrl: '',
    mediumPosterUrl: '',
    largePosterUrl: '',
    runtimeMinutes: 110,
    cast: [MovieCastMember(name: 'First Actor')],
  ),
  Movie(
    id: 2,
    title: 'Second Movie',
    year: 2023,
    rating: 7.4,
    genres: ['Drama'],
    description: 'Second synopsis.',
    smallPosterUrl: '',
    mediumPosterUrl: '',
    largePosterUrl: '',
  ),
  Movie(
    id: 3,
    title: 'Third Movie',
    year: 2022,
    rating: 6.9,
    genres: ['Animation'],
    description: '',
    smallPosterUrl: '',
    mediumPosterUrl: '',
    largePosterUrl: '',
  ),
  Movie(
    id: 4,
    title: 'Fourth Movie',
    year: 2021,
    rating: 6.5,
    genres: ['Biography'],
    description: '',
    smallPosterUrl: '',
    mediumPosterUrl: '',
    largePosterUrl: '',
  ),
];
