class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.description,
    required this.smallPosterUrl,
    required this.mediumPosterUrl,
    required this.largePosterUrl,
    this.backgroundImageUrl = '',
    this.runtimeMinutes = 0,
    this.likeCount,
    this.screenshotImageUrls = const [],
    this.cast = const [],
  });

  final int id;
  final String title;
  final int year;
  final double rating;
  final List<String> genres;
  final String description;
  final String smallPosterUrl;
  final String mediumPosterUrl;
  final String largePosterUrl;
  final String backgroundImageUrl;
  final int runtimeMinutes;
  final int? likeCount;
  final List<String> screenshotImageUrls;
  final List<MovieCastMember> cast;
}

class MovieCastMember {
  const MovieCastMember({
    required this.name,
    this.characterName = '',
    this.imageUrl = '',
    this.imdbCode = '',
  });

  final String name;
  final String characterName;
  final String imageUrl;
  final String imdbCode;
}
