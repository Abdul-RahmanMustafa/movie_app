import 'package:flutter/material.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/widgets/movie_poster_image.dart';

/// Horizontally scrollable movie cards.
///
/// Reusing the supplied card assets is intentional for this UI-only pass.
class MovieRow extends StatelessWidget {
  const MovieRow({
    super.key,
    required this.movies,
    required this.scale,
    required this.onMovieTap,
  });

  final List<Movie> movies;
  final double scale;
  final ValueChanged<Movie> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
        itemCount: movies.length,
        separatorBuilder: (_, _) => SizedBox(width: 12 * scale),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            key: Key('movie_row_item_${movie.id}'),
            onTap: () => onMovieTap(movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12 * scale),
              child: SizedBox(
                width: 146 * scale,
                height: 220 * scale,
                child: MoviePosterImage(imageUrl: movie.mediumPosterUrl),
              ),
            ),
          );
        },
      ),
    );
  }
}
