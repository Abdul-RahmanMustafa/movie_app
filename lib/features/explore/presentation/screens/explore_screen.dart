import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/entities/movie_list_query.dart';
import '../../../movies/domain/movie_failure.dart';
import '../../../movies/presentation/providers/movies_controller.dart';
import '../widgets/explore_genre_chip.dart';
import '../widgets/explore_movie_card.dart';

/// Figma Browse frame `50:462`, used as the app's Explore tab.
///
/// The top genre buttons query YTS while preserving the original Figma layout.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.moviesController});

  final MoviesController? moviesController;

  @override
  State<ExploreScreen> createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  late final MoviesController _moviesController =
      widget.moviesController ?? MoviesDependencies.controller;

  // Figma shows the first genre selected by default.
  int _selectedGenreIndex = 0;

  // YTS accepts genre names directly; these labels remain local UI filters.
  static const List<String> _genreLabels = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
  ];

  // Widths measured from the Figma Browse frame for the four genre groups.
  static const List<double> _genreWidths = [132, 126, 126, 126];

  List<Movie> _movies = const [];
  bool _isLoading = true;
  String? _errorMessage;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _loadGenre();
  }

  Future<void> _loadGenre() async {
    final requestId = ++_requestId;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final page = await _moviesController.listMovies(
        MovieListQuery(
          limit: 20,
          genre: _genreLabels[_selectedGenreIndex],
          sortBy: MovieSortBy.rating,
        ),
      );
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _movies = page.movies;
        _isLoading = false;
      });
    } on MovieFailure catch (failure) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _errorMessage = 'Something went wrong while loading movies.';
        _isLoading = false;
      });
    }
  }

  void _selectGenre(int index) {
    if (index == _selectedGenreIndex) return;
    setState(() => _selectedGenreIndex = index);
    _loadGenre();
  }

  void showGenre(String genre) {
    final index = _genreLabels.indexOf(genre);
    if (index < 0) return;
    if (index == _selectedGenreIndex) {
      _loadGenre();
      return;
    }
    _selectGenre(index);
  }

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
                          onTap: () => _selectGenre(index),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 24 * scale),

                  if (_isLoading)
                    SizedBox(
                      height: 420 * scale,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    SizedBox(
                      height: 420 * scale,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_errorMessage!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _loadGenre,
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_movies.isEmpty)
                    SizedBox(
                      height: 420 * scale,
                      child: Center(
                        child: Text(
                          'No ${_genreLabels[_selectedGenreIndex]} movies found.',
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _movies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12 * scale,
                        crossAxisSpacing: 12 * scale,
                        childAspectRatio: 189 / 279,
                      ),
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ExploreMovieCard(
                          key: Key('explore_movie_slot_$index'),
                          movie: movie,
                          index: index,
                          scale: scale,
                          onTap: () => context.push('/movie/${movie.id}'),
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
