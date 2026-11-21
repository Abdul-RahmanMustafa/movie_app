import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../widgets/home_hero.dart';
import '../widgets/movie_row.dart';
import '../widgets/section_heading.dart';

/// Figma Home frame 47:1248, rebuilt as a real scrollable page.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Dummy movie art for the horizontal "Action" row. Repeats are intentional
  // for this UI-only pass.
  static const List<String> _movieImages = [
    AppAssets.homeActionCard1,
    AppAssets.homeActionCard2,
    AppAssets.homeActionCard3,
    AppAssets.homeCardCenter,
    AppAssets.homePoster,
    AppAssets.homeActionCard2,
  ];

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
              HomeHero(scale: scale),
              SectionHeading(scale: scale),
              SizedBox(height: 12 * scale),
              MovieRow(images: _movieImages, scale: scale),

              // Extra space so the last card is not hidden behind the nav bar.
              SizedBox(height: 96 * scale),
            ],
          ),
        );
      },
    );
  }
}
