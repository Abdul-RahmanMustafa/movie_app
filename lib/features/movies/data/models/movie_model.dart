import '../../domain/entities/movie.dart';
import 'yts_envelope_model.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.genres,
    required super.description,
    required super.smallPosterUrl,
    required super.mediumPosterUrl,
    required super.largePosterUrl,
    super.backgroundImageUrl,
    super.runtimeMinutes,
    super.likeCount,
    super.screenshotImageUrls,
    super.cast,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final id = _asInt(json['id']);
    if (id == null || id <= 0) throw const YtsInvalidResponseException();

    final smallPoster = _asString(json['small_cover_image']);
    final mediumPoster = _asString(json['medium_cover_image']);
    final largePoster = _asString(json['large_cover_image']);

    return MovieModel(
      id: id,
      title: _firstNonEmpty([
        _asString(json['title']),
        _asString(json['title_english']),
        'Untitled',
      ]),
      year: _asInt(json['year']) ?? 0,
      rating: _asDouble(json['rating']) ?? 0,
      genres: _asStringList(json['genres']),
      description: _firstNonEmpty([
        _asString(json['description_full']),
        _asString(json['description_intro']),
        _asString(json['summary']),
        _asString(json['synopsis']),
      ]),
      smallPosterUrl: _firstNonEmpty([smallPoster, mediumPoster, largePoster]),
      mediumPosterUrl: _firstNonEmpty([mediumPoster, largePoster, smallPoster]),
      largePosterUrl: _firstNonEmpty([largePoster, mediumPoster, smallPoster]),
      backgroundImageUrl: _firstNonEmpty([
        _asString(json['background_image_original']),
        _asString(json['background_image']),
      ]),
      runtimeMinutes: _asInt(json['runtime']) ?? 0,
      likeCount: _asInt(json['like_count']),
      screenshotImageUrls: _asScreenshotUrls(json),
      cast: _asCast(json['cast']),
    );
  }
}

List<String> _asScreenshotUrls(Map<String, dynamic> json) {
  final urls = <String>[];
  for (var index = 1; index <= 3; index++) {
    final url = _firstNonEmpty([
      _asString(json['large_screenshot_image$index']),
      _asString(json['medium_screenshot_image$index']),
    ]);
    if (url.isNotEmpty) urls.add(url);
  }
  return List.unmodifiable(urls);
}

List<MovieCastMember> _asCast(Object? value) {
  if (value == null) return const [];
  if (value is! List) throw const YtsInvalidResponseException();

  return List.unmodifiable(
    value
        .whereType<Map>()
        .map((rawCastMember) {
          final json = Map<String, dynamic>.from(rawCastMember);
          return MovieCastMember(
            name: _asString(json['name']),
            characterName: _asString(json['character_name']),
            imageUrl: _asString(json['url_small_image']),
            imdbCode: _asString(json['imdb_code']),
          );
        })
        .where((castMember) => castMember.name.isNotEmpty),
  );
}

List<String> _asStringList(Object? value) {
  if (value == null) return const [];
  if (value is! List) throw const YtsInvalidResponseException();
  return List.unmodifiable(
    value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty),
  );
}

String _firstNonEmpty(List<String> values) {
  return values.firstWhere((value) => value.isNotEmpty, orElse: () => '');
}

String _asString(Object? value) => value is String ? value.trim() : '';

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
