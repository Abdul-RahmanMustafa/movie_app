import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetMovieSuggestions {
  const GetMovieSuggestions(this._repository);

  final MoviesRepository _repository;

  Future<List<Movie>> call(int movieId) {
    if (movieId <= 0) {
      throw ArgumentError.value(movieId, 'movieId', 'Must be positive.');
    }
    return _repository.getMovieSuggestions(movieId);
  }
}
