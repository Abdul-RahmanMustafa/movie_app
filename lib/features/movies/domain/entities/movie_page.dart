import 'movie.dart';

class MoviePage {
  const MoviePage({
    required this.movies,
    required this.movieCount,
    required this.limit,
    required this.pageNumber,
  });

  final List<Movie> movies;
  final int movieCount;
  final int limit;
  final int pageNumber;

  bool get hasNextPage => pageNumber * limit < movieCount;
}
