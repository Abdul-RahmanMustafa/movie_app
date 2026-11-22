import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/network/yts_api_client.dart';
import 'package:movie_app/features/movies/data/datasources/yts_movies_remote_data_source.dart';
import 'package:movie_app/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:movie_app/features/movies/domain/entities/movie_list_query.dart';
import 'package:movie_app/features/movies/domain/movie_failure.dart';

void main() {
  late FakeYtsApiClient apiClient;
  late MoviesRepositoryImpl repository;

  setUp(() {
    apiClient = FakeYtsApiClient();
    repository = MoviesRepositoryImpl(YtsMoviesRemoteDataSourceImpl(apiClient));
  });

  test(
    'list movies maps filters, pagination, sorting, and movie fields',
    () async {
      apiClient.response = {
        'status': 'ok',
        'status_message': 'Query was successful',
        'data': {
          'movie_count': 21,
          'limit': 10,
          'page_number': 2,
          'movies': [
            {
              'id': 42,
              'title': 'Example Movie',
              'year': 2024,
              'rating': 7.8,
              'genres': ['Drama', 'Mystery'],
              'summary': 'A test description.',
              'small_cover_image': 'https://images.test/small.jpg',
              'medium_cover_image': 'https://images.test/medium.jpg',
              'large_cover_image': 'https://images.test/large.jpg',
            },
          ],
        },
      };

      final page = await repository.listMovies(
        const MovieListQuery(
          page: 2,
          limit: 10,
          queryTerm: 'example',
          genre: 'Drama',
          minimumRating: 7,
          sortBy: MovieSortBy.rating,
          order: MovieOrder.descending,
        ),
      );

      expect(apiClient.lastPath, 'list_movies.json');
      expect(apiClient.lastQuery, containsPair('query_term', 'example'));
      expect(apiClient.lastQuery, containsPair('genre', 'Drama'));
      expect(apiClient.lastQuery, containsPair('minimum_rating', 7));
      expect(apiClient.lastQuery, containsPair('sort_by', 'rating'));
      expect(apiClient.lastQuery, containsPair('order_by', 'desc'));
      expect(page.pageNumber, 2);
      expect(page.hasNextPage, isTrue);
      expect(page.movies.single.id, 42);
      expect(page.movies.single.title, 'Example Movie');
      expect(page.movies.single.rating, 7.8);
      expect(page.movies.single.genres, ['Drama', 'Mystery']);
      expect(page.movies.single.largePosterUrl, endsWith('large.jpg'));
    },
  );

  test('movie details requests images and cast and parses both', () async {
    apiClient.response = {
      'status': 'ok',
      'status_message': 'Query was successful',
      'data': {
        'movie': {
          'id': 99,
          'title': 'Detailed Movie',
          'year': 2023,
          'rating': 8,
          'runtime': 115,
          'genres': ['Action'],
          'description_full': 'Full description.',
          'medium_cover_image': 'https://images.test/poster.jpg',
          'background_image_original': 'https://images.test/background.jpg',
          'cast': [
            {
              'name': 'Actor Name',
              'character_name': 'Character Name',
              'url_small_image': 'https://images.test/actor.jpg',
              'imdb_code': '1234',
            },
          ],
        },
      },
    };

    final movie = await repository.getMovieDetails(movieId: 99);

    expect(apiClient.lastPath, 'movie_details.json');
    expect(apiClient.lastQuery, containsPair('movie_id', 99));
    expect(apiClient.lastQuery, containsPair('with_images', true));
    expect(apiClient.lastQuery, containsPair('with_cast', true));
    expect(movie.description, 'Full description.');
    expect(movie.runtimeMinutes, 115);
    expect(movie.largePosterUrl, 'https://images.test/poster.jpg');
    expect(movie.cast.single.name, 'Actor Name');
    expect(movie.cast.single.characterName, 'Character Name');
  });

  test('suggestions returns an empty list when movies is missing', () async {
    apiClient.response = {
      'status': 'ok',
      'status_message': 'Query was successful',
      'data': {'movie_count': 0},
    };

    final movies = await repository.getMovieSuggestions(99);

    expect(apiClient.lastPath, 'movie_suggestions.json');
    expect(apiClient.lastQuery, containsPair('movie_id', 99));
    expect(movies, isEmpty);
  });

  test('API error envelope becomes a typed API failure', () async {
    apiClient.response = {
      'status': 'error',
      'status_message': 'Invalid movie id',
      'data': null,
    };

    expect(
      () => repository.getMovieDetails(movieId: 999),
      throwsA(
        isA<MovieFailure>()
            .having((failure) => failure.type, 'type', MovieFailureType.api)
            .having(
              (failure) => failure.message,
              'message',
              'Invalid movie id',
            ),
      ),
    );
  });

  test('timeout becomes a typed timeout failure', () async {
    apiClient.error = const YtsApiClientException(
      YtsApiClientFailureType.timeout,
    );

    expect(
      () => repository.listMovies(const MovieListQuery()),
      throwsA(
        isA<MovieFailure>().having(
          (failure) => failure.type,
          'type',
          MovieFailureType.timeout,
        ),
      ),
    );
  });

  test('missing envelope data becomes an invalid-response failure', () async {
    apiClient.response = {
      'status': 'ok',
      'status_message': 'Query was successful',
    };

    expect(
      () => repository.listMovies(const MovieListQuery()),
      throwsA(
        isA<MovieFailure>().having(
          (failure) => failure.type,
          'type',
          MovieFailureType.invalidResponse,
        ),
      ),
    );
  });
}

class FakeYtsApiClient implements YtsApiClient {
  Map<String, dynamic> response = const {};
  Object? error;
  String? lastPath;
  Map<String, dynamic>? lastQuery;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    lastPath = path;
    lastQuery = queryParameters;
    final requestError = error;
    if (requestError != null) throw requestError;
    return response;
  }
}
