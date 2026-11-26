import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/widgets/movie_poster_image.dart';

/// Carousel and page dots for the Home hero.
///
/// The slider is positioned inside the hero's [SafeArea] by [HomeHero]. Only
/// the dots are rebuilt on a page change: rebuilding [CarouselSlider] would
/// reset its internal [PageController] in carousel_slider 5.x.
class HomeCarousel extends StatefulWidget {
  const HomeCarousel({
    super.key,
    required this.scale,
    required this.movies,
    required this.isLoading,
    required this.onRetry,
    required this.onMovieTap,
    this.errorMessage,
  });

  final double scale;
  final List<Movie> movies;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final ValueChanged<Movie> onMovieTap;

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    // MainShell disables tickers for hidden tabs, so the carousel must not
    // keep auto-playing (and scheduling frames) off screen.
    final tickerEnabled = TickerMode.valuesOf(context).enabled;

    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }
    if (widget.errorMessage != null) {
      return Center(
        child: TextButton(
          onPressed: widget.onRetry,
          child: Text(context.l10n.commonTryAgain),
        ),
      );
    }
    if (widget.movies.isEmpty) {
      return Center(child: Text(context.l10n.homeNoFeaturedMovies));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-bleed slider with neighbour cards peeking at both screen edges.
        Positioned(
          left: 0,
          right: 0,
          top: 110 * scale,
          height: 380 * scale,
          child: CarouselSlider.builder(
            itemCount: widget.movies.length,
            options: CarouselOptions(
              height: 380 * scale,
              viewportFraction: 0.82,
              autoPlay: tickerEnabled,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 500),
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: true,
              padEnds: true,
              enableInfiniteScroll: true,
              onPageChanged: (index, _) => _currentPage.value = index,
            ),
            itemBuilder: (context, index, realIndex) {
              final movie = widget.movies[index];
              return GestureDetector(
                key: Key('home_featured_movie_${movie.id}'),
                onTap: () => widget.onMovieTap(movie),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18 * scale),
                  child: MoviePosterImage(
                    imageUrl: movie.largePosterUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),

        // Dots stay at the bottom of the 640px hero, above the overlay.
        Positioned(
          left: 0,
          right: 0,
          bottom: 16 * scale,
          child: ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (context, currentPage, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.movies.length, (index) {
                  final isActive = index == currentPage;
                  return AnimatedContainer(
                    key: Key('home_carousel_dot_$index'),
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 3 * scale),
                    width: (isActive ? 18 : 6) * scale,
                    height: 6 * scale,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.accent
                          : AppColors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(6 * scale),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
