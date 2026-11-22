import '../entities/movie_list_query.dart';
import '../entities/movie_page.dart';
import '../repositories/movies_repository.dart';

class ListMovies {
  const ListMovies(this._repository);

  final MoviesRepository _repository;

  Future<MoviePage> call(MovieListQuery query) {
    query.validate();
    return _repository.listMovies(query);
  }
}
