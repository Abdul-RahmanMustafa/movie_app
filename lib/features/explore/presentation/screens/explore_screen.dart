import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/explore_genre_chip.dart';
import '../widgets/explore_movie_card.dart';

/// Figma Browse frame `50:462`, used as the app's Explore tab.
///
/// This is an intentional UI-only scaffold: the lists below are the exact
/// places to plug in database/API results later. Each slot also has a stable
/// key so widget tests can find it. The top genre buttons are interactive;
/// tapping one moves the accent highlight. Filtering the cards by the
/// selected genre is left for the database integration.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Figma shows the first genre selected by default.
  int _selectedGenreIndex = 0;

  // TODO(db): replace with genres fetched from the database.
  static const List<String> _genreLabels = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
  ];

  // Widths measured from the Figma Browse frame for the four genre groups.
  static const List<double> _genreWidths = [132, 126, 126, 126];

  // TODO(db): replace with movie DTOs from the database/API.
  // Four slots mirror the 2 x 2 poster grid in the Figma frame.
  static const List<int> _movieSlots = [0, 1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 430;

        return ColoredBox(
          color: AppColors.background,
          child: SafeArea(
            top: true,
            bottom: false,
            child: SingleChildScrollView(
              // Extra bottom padding keeps the last row clear of the shared
              // bottom navigation bar drawn by MainShell.
              padding: EdgeInsets.fromLTRB(
                16 * scale,
                16 * scale,
                16 * scale,
                96 * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48 * scale,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _genreLabels.length,
                      separatorBuilder: (_, _) => SizedBox(width: 8 * scale),
                      itemBuilder: (context, index) {
                        return ExploreGenreChip(
                          key: Key('explore_genre_slot_$index'),
                          label: _genreLabels[index],
                          width: _genreWidths[index] * scale,
                          scale: scale,
                          selected: index == _selectedGenreIndex,
                          onTap: () {
                            setState(() => _selectedGenreIndex = index);
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 24 * scale),

                  // TODO(db): feed this grid from the movie query result.
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _movieSlots.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12 * scale,
                      crossAxisSpacing: 12 * scale,
                      // Figma card size: 189 x 279 design pixels.
                      childAspectRatio: 189 / 279,
                    ),
                    itemBuilder: (context, index) {
                      return ExploreMovieCard(
                        key: Key('explore_movie_slot_$index'),
                        index: index,
                        scale: scale,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
