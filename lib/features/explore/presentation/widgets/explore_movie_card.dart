import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/widgets/movie_poster_image.dart';

/// Movie card retaining the Figma Browse footprint (189 x 279 design pixels).
class ExploreMovieCard extends StatelessWidget {
  const ExploreMovieCard({
    super.key,
    required this.movie,
    required this.index,
    required this.scale,
    required this.onTap,
  });

  final Movie movie;
  final int index;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12 * scale),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12 * scale),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12 * scale),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MoviePosterImage(imageUrl: movie.mediumPosterUrl),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Color(0xD9000000), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  top: 8 * scale,
                  left: 8 * scale,
                  child: Container(
                    key: Key('explore_rating_slot_$index'),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8 * scale,
                      vertical: 4 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xB3000000),
                      borderRadius: BorderRadius.circular(8 * scale),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 3 * scale),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Roboto',
                            fontSize: 16 * scale,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: AppColors.accent,
                          size: 16 * scale,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10 * scale,
                  right: 10 * scale,
                  bottom: 10 * scale,
                  child: Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto',
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
