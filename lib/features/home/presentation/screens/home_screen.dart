import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

/// Figma Home frame `47:1248`, rebuilt as a real scrollable page.
///
/// Structure of the top banner:
/// 1. Outer Stack fills the hero from y=0 so the background can extend behind
///    the status bar / notch (it deliberately surpasses the SafeArea).
/// 2. Stack layer 1: static full-bleed background using the supplied home_bg.png.
/// 3. Stack layer 2: bottom-to-top gradient (black at the bottom, clear at top)
///    with the fade starting higher up to match the Figma frame.
/// 4. Foreground content (carousel, Group 7 overlay, dots) stays inside a
///    SafeArea so it never collides with the notch / camera hole.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy movie art for the carousel. Repeats are intentional for this UI pass.
  static const List<String> _carouselImages = [
    AppAssets.homeCardCenter,
    AppAssets.homePoster,
    AppAssets.homeCardLeft,
    AppAssets.homeCardRight,
    AppAssets.homeActionCard1,
  ];

  // Dummy movie art for the horizontally scrolling "Action" row.
  static const List<String> _movieImages = [
    AppAssets.homeActionCard1,
    AppAssets.homeActionCard2,
    AppAssets.homeActionCard3,
    AppAssets.homeCardCenter,
    AppAssets.homePoster,
    AppAssets.homeActionCard2,
  ];

  // Which carousel dot is active; updated by CarouselSlider.onPageChanged.
  int _currentCarouselPage = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale every measured Figma pixel by the current screen width.
        final scale = constraints.maxWidth / 430;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HomeHero(
                scale: scale,
                carouselImages: _carouselImages,
                currentPage: _currentCarouselPage,
                onPageChanged: (index) {
                  // Keep dots in sync with the visible carousel page.
                  setState(() => _currentCarouselPage = index);
                },
              ),
              SizedBox(height: 24 * scale),
              _SectionHeading(scale: scale),
              SizedBox(height: 12 * scale),
              _MovieRow(images: _movieImages, scale: scale),

              // Clearance so the last card is not hidden behind the nav bar.
              SizedBox(height: 96 * scale),
            ],
          ),
        );
      },
    );
  }
}

/// Hero banner with a full-bleed background outside SafeArea and the
/// interactive content kept notch-safe inside it.
class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.scale,
    required this.carouselImages,
    required this.currentPage,
    required this.onPageChanged,
  });

  final double scale;
  final List<String> carouselImages;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    // Reserve the system top inset so foreground content keeps its Figma
    // position while the background is free to fill all the way to y = 0.
    final topInset = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 640 * scale + topInset,
      child: Stack(
        children: [
          // Layer 1: static full-bleed background (supplied home_bg.png).
          // It sits OUTSIDE the SafeArea, so it also covers the status bar.
          Positioned.fill(
            child: Image.asset(
              AppAssets.homeBackground,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),

          // Layer 2: linear fade, bottom = solid black, top = clear.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                  // Start the fade higher up so the dark area matches Figma.
                  stops: const [0.0, 0.72, 1.0],
                ),
              ),
            ),
          ),

          // Foreground stays inside SafeArea so the carousel and overlay clear
          // the notch / camera hole, while the layers above remain full-bleed.
          Positioned.fill(
            child: SafeArea(
              top: true,
              bottom: false, // MainShell draws the shared bottom navigation.
              child: Stack(
                children: [
                  // Layer 3: carousel from pub.dev `carousel_slider`.
                  // The slider itself is full-bleed (left/right = 0) and
                  // infinite scroll keeps neighbour items at both screen
                  // edges, while padEnds keeps the enlarged page snapped to
                  // the centre of the viewport instead of the left edge.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 110 * scale,
                    height: 380 * scale,
                    child: CarouselSlider.builder(
                      itemCount: carouselImages.length,
                      options: CarouselOptions(
                        height: 380 * scale,
                        // Ratio between items: 0.82 leaves a gap between the
                        // centred card and the ones on either side.
                        viewportFraction: 0.82,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                        autoPlayCurve: Curves.easeInOut,
                        // The centre card is scaled up, as in the first pass.
                        enlargeCenterPage: true,
                        // Page snapping centres the focused card. With an
                        // infinite slider there are no real ends, so this
                        // does not add visible padding at the screen edges.
                        padEnds: true,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, _) => onPageChanged(index),
                      ),
                      itemBuilder: (context, index, realIndex) {
                        // BoxFit.fill fills the card without cropping, and the
                        // rounded corners match the original carousel cards.
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(18 * scale),
                          child: Image.asset(
                            carouselImages[index % carouselImages.length],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                  ),

                  // Layer 4: Group 7 overlay on top. It is mostly transparent
                  // and IgnorePointer keeps the carousel underneath tappable.
                  Positioned(
                    left: 38 * scale,
                    top: 7 * scale,
                    width: 354 * scale,
                    height: 632 * scale,
                    child: IgnorePointer(
                      child: Image.asset(
                        AppAssets.homeHeroGroup,
                        width: 354 * scale,
                        height: 632 * scale,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // Carousel page dots are drawn above every other layer.
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16 * scale,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(carouselImages.length, (index) {
                        final isActive = index == currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(horizontal: 3 * scale),
                          width: isActive ? 18 * scale : 6 * scale,
                          height: 6 * scale,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.accent
                                : AppColors.white.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(6 * scale),
                          ),
                        );
                      }),
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

/// "Action" heading with the gold "See More" link from the Figma frame.
class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
      child: Row(
        children: [
          Text(
            'Action',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Roboto',
              fontSize: 20 * scale,
            ),
          ),
          const Spacer(),
          Text(
            'See More',
            style: TextStyle(
              color: AppColors.accent,
              fontFamily: 'Roboto',
              fontSize: 16 * scale,
            ),
          ),
          SizedBox(width: 4 * scale),
          Icon(
            Icons.arrow_forward_ios,
            size: 14 * scale,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

/// Horizontally scrollable movie cards.
///
/// Reusing the supplied card assets is intentional for this UI-only pass.
class _MovieRow extends StatelessWidget {
  const _MovieRow({required this.images, required this.scale});

  final List<String> images;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
        itemCount: images.length,
        separatorBuilder: (_, _) => SizedBox(width: 12 * scale),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12 * scale),
            child: SizedBox(
              width: 146 * scale,
              height: 220 * scale,
              child: Image.asset(
                images[index % images.length],
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }
}
