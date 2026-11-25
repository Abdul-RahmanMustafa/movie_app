import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/movie_row.dart';
import '../../../watchlist/domain/watchlist_failure.dart';
import '../../../watchlist/presentation/providers/watchlist_controller.dart';
import '../../domain/entities/movie.dart';
import '../../domain/movie_failure.dart';
import '../providers/movies_controller.dart';
import '../widgets/movie_poster_image.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    this.moviesController,
    this.watchlistController,
  });

  final int movieId;
  final MoviesController? moviesController;
  final WatchlistController? watchlistController;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late final MoviesController _moviesController =
      widget.moviesController ?? MoviesDependencies.controller;
  late final WatchlistController _watchlistController =
      widget.watchlistController ?? WatchlistDependencies.controller;

  Movie? _movie;
  List<Movie> _suggestions = const [];
  String? _errorMessage;
  bool _isLoading = true;
  StreamSubscription<bool>? _bookmarkSubscription;
  bool _isBookmarked = false;
  bool _isBookmarkLoading = true;
  bool _isBookmarkBusy = false;

  @override
  void initState() {
    super.initState();
    _observeBookmark();
    _loadMovie();
  }

  @override
  void dispose() {
    unawaited(_bookmarkSubscription?.cancel());
    super.dispose();
  }

  void _observeBookmark() {
    _bookmarkSubscription = _watchlistController
        .observeSaved(widget.movieId)
        .listen(
          (isSaved) {
            if (!mounted) return;
            setState(() {
              _isBookmarked = isSaved;
              _isBookmarkLoading = false;
            });
          },
          onError: (Object error) {
            if (!mounted) return;
            setState(() => _isBookmarkLoading = false);
            _showWatchlistError(error);
          },
        );
  }

  Future<void> _toggleBookmark() async {
    final movie = _movie;
    if (movie == null || _isBookmarkBusy || _isBookmarkLoading) return;
    setState(() => _isBookmarkBusy = true);

    try {
      final isSaved = await _watchlistController.toggle(movie);
      if (!mounted) return;
      setState(() => _isBookmarked = isSaved);
    } catch (error) {
      if (!mounted) return;
      _showWatchlistError(error);
    } finally {
      if (mounted) setState(() => _isBookmarkBusy = false);
    }
  }

  void _showWatchlistError(Object error) {
    final message = error is WatchlistFailure
        ? error.message
        : 'Something went wrong with your Watch List.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadMovie() async {
    if (widget.movieId <= 0) {
      setState(() {
        _errorMessage = 'This movie is unavailable.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detailsFuture = _moviesController.getMovieDetails(
        movieId: widget.movieId,
      );
      final suggestionsFuture = _moviesController
          .getMovieSuggestions(widget.movieId)
          .then<List<Movie>>(
            (suggestions) => suggestions,
            onError: (_) => const <Movie>[],
          );
      final movie = await detailsFuture;
      final suggestions = await suggestionsFuture;

      if (!mounted) return;
      setState(() {
        _movie = movie;
        _suggestions = suggestions;
        _isLoading = false;
      });
    } on MovieFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Something went wrong while loading this movie.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _StateBody(
        onBack: () => context.pop(),
        child: const CircularProgressIndicator(color: AppColors.accent),
      );
    }
    if (_errorMessage != null) {
      return _StateBody(
        onBack: () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(onPressed: _loadMovie, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    final movie = _movie!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = AppLayout.scaleForWidth(screenWidth);
    final heroHeight = (screenWidth * 1.22).clamp(430.0, 560.0).toDouble();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: heroHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MoviePosterImage(imageUrl: movie.largePosterUrl),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x40000000),
                        Colors.transparent,
                        AppColors.background,
                      ],
                      stops: [0, 0.58, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: MediaQuery.paddingOf(context).top + 4,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: MediaQuery.paddingOf(context).top + 4,
                  child: IconButton(
                    onPressed: _isBookmarkLoading || _isBookmarkBusy
                        ? null
                        : _toggleBookmark,
                    icon: _isBookmarkLoading || _isBookmarkBusy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: AppColors.accent,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: _isBookmarked
                                ? AppColors.accent
                                : AppColors.white,
                            size: 30,
                          ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 42,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  40 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (movie.year > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${movie.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 16,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: const Color(0xFFE53935),
                          disabledForegroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Watch',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoBadge(
                            icon: Icons.favorite,
                            value: movie.likeCount?.toString() ?? '—',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoBadge(
                            icon: Icons.access_time_filled,
                            value: movie.runtimeMinutes > 0
                                ? '${movie.runtimeMinutes}'
                                : '—',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoBadge(
                            icon: Icons.star,
                            value: movie.rating > 0
                                ? movie.rating.toStringAsFixed(1)
                                : '—',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const _SectionTitle('Screen Shots'),
                    const SizedBox(height: 12),
                    if (movie.screenshotImageUrls.isEmpty)
                      const Text(
                        'No screenshots are available.',
                        style: TextStyle(color: Color(0xFFAAAAAA)),
                      )
                    else
                      SizedBox(
                        height: 128,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.screenshotImageUrls.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 220,
                                child: MoviePosterImage(
                                  imageUrl: movie.screenshotImageUrls[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 28),
                    const _SectionTitle('Similar Movies'),
                    const SizedBox(height: 12),
                    if (_suggestions.isEmpty)
                      const Text(
                        'No similar movies are available.',
                        style: TextStyle(color: Color(0xFFAAAAAA)),
                      )
                    else
                      MovieRow(
                        movies: _suggestions,
                        scale: scale,
                        onMovieTap: (suggestion) {
                          context.pushReplacement('/movie/${suggestion.id}');
                        },
                      ),
                    const SizedBox(height: 28),
                    const _SectionTitle('Summary'),
                    const SizedBox(height: 10),
                    Text(
                      movie.description.isEmpty
                          ? 'No summary is available.'
                          : movie.description,
                      style: const TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle('Cast'),
                    const SizedBox(height: 12),
                    if (movie.cast.isEmpty)
                      const Text(
                        'No cast information is available.',
                        style: TextStyle(color: Color(0xFFAAAAAA)),
                      )
                    else
                      SizedBox(
                        height: 126,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.cast.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return _CastCard(member: movie.cast[index]);
                          },
                        ),
                      ),
                    const SizedBox(height: 28),
                    const _SectionTitle('Genres'),
                    const SizedBox(height: 12),
                    if (movie.genres.isEmpty)
                      const Text(
                        'No genres are available.',
                        style: TextStyle(color: Color(0xFFAAAAAA)),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: movie.genres
                            .map(
                              (genre) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateBody extends StatelessWidget {
  const _StateBody({required this.onBack, required this.child});

  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
            ),
          ),
          Expanded(child: Center(child: child)),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.member});

  final MovieCastMember member;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: 72,
              height: 72,
              child: member.imageUrl.isEmpty
                  ? const ColoredBox(
                      color: AppColors.surface,
                      child: Icon(Icons.person, color: AppColors.accent),
                    )
                  : MoviePosterImage(imageUrl: member.imageUrl),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            member.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
