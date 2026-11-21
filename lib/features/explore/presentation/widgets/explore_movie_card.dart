import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Placeholder for one movie card in the Figma Browse/Explore frame.
///
/// The card keeps the Figma card footprint (189 x 279 design pixels) and marks
/// the two fields that will come from the database:
/// - poster image (`posterUrl`)
/// - rating (`voteAverage`)
///
/// Replace the grey poster area with a network/file image and the hard-coded
/// `7.7` badge with the movie's rating when the data source is wired up.
class ExploreMovieCard extends StatelessWidget {
  const ExploreMovieCard({
    super.key,
    required this.index,
    required this.scale,
  });

  final int index;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12 * scale),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.accent.withAlpha(90),
            width: 1 * scale,
          ),
          borderRadius: BorderRadius.circular(12 * scale),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster slot: swap this for Image.network(movie.posterUrl).
            ColoredBox(color: const Color(0xFF1E201E)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: AppColors.accent,
                    size: 44 * scale,
                  ),
                  SizedBox(height: 8 * scale),
                  Text(
                    'Poster slot',
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto',
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2 * scale),
                  Text(
                    'DB: posterUrl',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontFamily: 'Roboto',
                      fontSize: 10 * scale,
                    ),
                  ),
                ],
              ),
            ),

            // Rating slot: swap "7.7" for movie.voteAverage.toStringAsFixed(1).
            Positioned(
              top: 8 * scale,
              right: 8 * scale,
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
                    Icon(
                      Icons.star,
                      color: AppColors.accent,
                      size: 12 * scale,
                    ),
                    SizedBox(width: 3 * scale),
                    Text(
                      '7.7',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Roboto',
                        fontSize: 12 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title slot: swap this for movie.title.
            Positioned(
              left: 10 * scale,
              right: 10 * scale,
              bottom: 10 * scale,
              child: Text(
                'Title slot',
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
    );
  }
}
