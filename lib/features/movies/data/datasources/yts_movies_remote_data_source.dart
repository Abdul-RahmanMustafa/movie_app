import '../../../../core/network/yts_api_client.dart';
import '../../domain/entities/movie_list_query.dart';
import '../models/movie_model.dart';
import '../models/movie_page_model.dart';
import '../models/yts_envelope_model.dart';

abstract interface class YtsMoviesRemoteDataSource {
  Future<MoviePageModel> listMovies(MovieListQuery query);

  Future<MovieModel> getMovieDetails({
    required int movieId,
    required bool withImages,
    required bool withCast,
  });

  Future<List<MovieModel>> getMovieSuggestions(int movieId);
}

class YtsMoviesRemoteDataSourceImpl implements YtsMoviesRemoteDataSource {
  const YtsMoviesRemoteDataSourceImpl(this._apiClient);

  final YtsApiClient _apiClient;

  @override
  Future<MoviePageModel> listMovies(MovieListQuery query) async {
    final envelope = await _getEnvelope(
      'list_movies.json',
      queryParameters: {
        'page': query.page,
        'limit': query.limit,
        if (query.queryTerm?.trim().isNotEmpty ?? false)
          'query_term': query.queryTerm!.trim(),
        if (query.genre?.trim().isNotEmpty ?? false)
          'genre': query.genre!.trim(),
        'minimum_rating': query.minimumRating,
        'sort_by': _sortValue(query.sortBy),
        'order_by': query.order == MovieOrder.ascending ? 'asc' : 'desc',
      },
    );
    return MoviePageModel.fromJson(envelope.requireSuccessfulData());
  }

  @override
  Future<MovieModel> getMovieDetails({
    required int movieId,
    required bool withImages,
    required bool withCast,
  }) async {
    final envelope = await _getEnvelope(
      'movie_details.json',
      queryParameters: {
        'movie_id': movieId,
        'with_images': withImages,
        'with_cast': withCast,
      },
    );
    final movie = envelope.requireSuccessfulData()['movie'];
    if (movie is! Map) throw const YtsInvalidResponseException();
    return MovieModel.fromJson(Map<String, dynamic>.from(movie));
  }

  @override
  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    final envelope = await _getEnvelope(
      'movie_suggestions.json',
      queryParameters: {'movie_id': movieId},
    );
    final rawMovies = envelope.requireSuccessfulData()['movies'];
    if (rawMovies == null) return const [];
    if (rawMovies is! List) throw const YtsInvalidResponseException();
    return List.unmodifiable(
      rawMovies.whereType<Map>().map(
        (movie) => MovieModel.fromJson(Map<String, dynamic>.from(movie)),
      ),
    );
  }

  Future<YtsEnvelopeModel> _getEnvelope(
    String path, {
    required Map<String, dynamic> queryParameters,
  }) async {
    final json = await _apiClient.get(path, queryParameters: queryParameters);
    return YtsEnvelopeModel.fromJson(json);
  }
}

String _sortValue(MovieSortBy sortBy) {
  return switch (sortBy) {
    MovieSortBy.title => 'title',
    MovieSortBy.year => 'year',
    MovieSortBy.rating => 'rating',
    MovieSortBy.peers => 'peers',
    MovieSortBy.seeds => 'seeds',
    MovieSortBy.downloadCount => 'download_count',
    MovieSortBy.likeCount => 'like_count',
    MovieSortBy.dateAdded => 'date_added',
  };
}
