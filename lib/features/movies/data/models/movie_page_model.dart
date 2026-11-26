import '../../domain/entities/movie_page.dart';
import 'movie_model.dart';
import 'yts_envelope_model.dart';

class MoviePageModel extends MoviePage {
  const MoviePageModel({
    required super.movies,
    required super.movieCount,
    required super.limit,
    required super.pageNumber,
  });

  factory MoviePageModel.fromJson(Map<String, dynamic> json) {
    final rawMovies = json['movies'];
    if (rawMovies != null && rawMovies is! List) {
      throw const YtsInvalidResponseException();
    }

    final movies = rawMovies == null
        ? const <MovieModel>[]
        : List<MovieModel>.unmodifiable(
            rawMovies.whereType<Map>().map(
              (movie) => MovieModel.fromJson(Map<String, dynamic>.from(movie)),
            ),
          );

    return MoviePageModel(
      movies: movies,
      movieCount: _asInt(json['movie_count']) ?? movies.length,
      limit: _asInt(json['limit']) ?? movies.length,
      pageNumber: _asInt(json['page_number']) ?? 1,
    );
  }
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
