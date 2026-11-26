import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetMovieDetails {
  const GetMovieDetails(this._repository);

  final MoviesRepository _repository;

  Future<Movie> call({
    required int movieId,
    bool withImages = true,
    bool withCast = true,
  }) {
    if (movieId <= 0) {
      throw ArgumentError.value(movieId, 'movieId', 'Must be positive.');
    }
    return _repository.getMovieDetails(
      movieId: movieId,
      withImages: withImages,
      withCast: withCast,
    );
  }
}
