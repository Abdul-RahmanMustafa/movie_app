import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../movies/domain/entities/movie.dart';
import 'home_carousel.dart';

/// Figma Home hero (frame 47:1248).
///
/// The background and gradient fill the whole 640px hero, including the area
/// behind the status bar. The carousel and the supplied Group 7 artwork are
/// kept inside [SafeArea] so they never collide with the notch/camera hole.
class HomeHero extends StatelessWidget {
  const HomeHero({
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
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 640 * scale + topInset,
      child: Stack(
        children: [
          // Layer 1: full-bleed background, deliberately outside SafeArea.
          Positioned.fill(
            child: Image.asset(
              key: const Key('home_hero_background'),
              AppAssets.homeBackground,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),

          // Layer 2: black at the bottom, clear at the top. The middle stop
          // starts the fade higher up to match the Figma frame.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Color(0x59000000), Colors.transparent],
                  stops: [0.0, 0.72, 1.0],
                ),
              ),
            ),
          ),

          // Layers 3-5: carousel, supplied Group 7 artwork, and dots. They all
          // stay below the system top inset.
          Positioned.fill(
            child: SafeArea(
              top: true,
              bottom: false, // MainShell owns the shared bottom navigation.
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: HomeCarousel(
                      scale: scale,
                      movies: movies,
                      isLoading: isLoading,
                      errorMessage: errorMessage,
                      onRetry: onRetry,
                      onMovieTap: onMovieTap,
                    ),
                  ),

                  // Group 7 already contains the hero typography/button, so no
                  // hand-built Text/FilledButton is layered on top of it.
                  Positioned(
                    left: 38 * scale,
                    top: 7 * scale,
                    width: 354 * scale,
                    height: 632 * scale,
                    child: IgnorePointer(
                      child: Image.asset(
                        key: const Key('home_hero_group'),
                        AppAssets.homeHeroGroup,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
