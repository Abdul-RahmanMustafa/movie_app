import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/entities/movie_list_query.dart';
import '../../../movies/domain/movie_failure.dart';
import '../../../movies/presentation/providers/movies_controller.dart';
import '../../../movies/presentation/utils/movie_failure_localization.dart';
import '../widgets/home_hero.dart';
import '../widgets/movie_row.dart';
import '../widgets/section_heading.dart';

/// Figma Home frame 47:1248, rebuilt as a real scrollable page.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.moviesController, this.onExploreRequested});

  final MoviesController? moviesController;
  final VoidCallback? onExploreRequested;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MoviesController _moviesController =
      widget.moviesController ?? MoviesDependencies.controller;

  List<Movie> _featuredMovies = const [];
  List<Movie> _actionMovies = const [];
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pages = await Future.wait([
        _moviesController.listMovies(
          const MovieListQuery(
            limit: 5,
            minimumRating: 7,
            sortBy: MovieSortBy.rating,
          ),
        ),
        _moviesController.listMovies(
          const MovieListQuery(
            limit: 12,
            genre: 'Action',
            minimumRating: 6,
            sortBy: MovieSortBy.rating,
          ),
        ),
      ]);
      if (!mounted) return;
      setState(() {
        _featuredMovies = pages[0].movies;
        _actionMovies = pages[1].movies;
        _isLoading = false;
      });
    } on MovieFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _errorMessage = localizedMovieFailure(context.l10n, failure);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.errorLoadMovies;
        _isLoading = false;
      });
    }
  }

  void _openMovie(Movie movie) => context.push('/movie/${movie.id}');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 430;

        // HomeHero owns the top SafeArea. The carousel is layered inside it,
        // not stacked below it, so the hero matches the Figma frame.
        return SingleChildScrollView(
          // Lets the page grow beyond the 932px design height on small devices.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHero(
                scale: scale,
                movies: _featuredMovies,
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                onRetry: _loadMovies,
                onMovieTap: _openMovie,
              ),
              SectionHeading(
                scale: scale,
                onSeeMore: widget.onExploreRequested,
              ),
              SizedBox(height: 12 * scale),
              if (_isLoading)
                SizedBox(
                  height: 220 * scale,
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                SizedBox(
                  height: 220 * scale,
                  child: Center(
                    child: TextButton(
                      onPressed: _loadMovies,
                      child: Text(context.l10n.commonTryAgain),
                    ),
                  ),
                )
              else if (_actionMovies.isEmpty)
                SizedBox(
                  height: 220 * scale,
                  child: Center(child: Text(context.l10n.homeNoActionMovies)),
                )
              else
                MovieRow(
                  movies: _actionMovies,
                  scale: scale,
                  onMovieTap: _openMovie,
                ),

              // Extra space so the last card is not hidden behind the nav bar.
              SizedBox(height: 96 * scale),
            ],
          ),
        );
      },
    );
  }
}
