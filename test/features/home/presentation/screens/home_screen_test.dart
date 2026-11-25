import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/layout/app_layout.dart';
import 'package:movie_app/features/home/presentation/screens/home_screen.dart';
import 'package:movie_app/features/home/presentation/widgets/home_carousel.dart';
import 'package:movie_app/features/home/presentation/widgets/home_hero.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_row.dart';
import 'package:movie_app/features/home/presentation/widgets/section_heading.dart';

import '../../../../helpers/fake_movies_controller.dart';
import '../../../../helpers/test_surface.dart';

void main() {
  testWidgets('renders the home sections with a package carousel', (
    tester,
  ) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(moviesController: FakeMoviesController())),
    );
    await tester.pump();

    expect(find.byType(HomeHero), findsOneWidget);
    expect(find.byType(HomeCarousel), findsOneWidget);
    expect(find.byType(CarouselSlider), findsOneWidget);
    expect(find.byType(SectionHeading), findsOneWidget);
    expect(find.byType(MovieRow), findsOneWidget);

    // Group 7 supplies the hero typography/CTA itself; do not add duplicates.
    expect(find.text('Available Now'), findsNothing);
    expect(find.text('Watch Now'), findsNothing);
    expect(find.byKey(const Key('home_hero_group')), findsOneWidget);
  });

  testWidgets('keeps the hero full-bleed and Group 7 at its Figma size', (
    tester,
  ) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(moviesController: FakeMoviesController())),
    );
    await tester.pump();
    final scale = AppLayout.scaleForWidth(
      MediaQuery.of(tester.element(find.byType(HomeScreen))).size.width,
    );

    final topInset = MediaQuery.of(
      tester.element(find.byType(HomeHero)),
    ).padding.top;
    final hero = tester.renderObject<RenderBox>(find.byType(HomeHero));
    expect(hero.size.height, 640 * scale + topInset);

    final group = tester.renderObject<RenderBox>(
      find.byKey(const Key('home_hero_group')),
    );
    expect(group.size.width, 354 * scale);
    expect(group.size.height, 632 * scale);
  });

  testWidgets('moves the active dot when the carousel auto-advances', (
    tester,
  ) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(moviesController: FakeMoviesController())),
    );
    await tester.pump();
    final scale = AppLayout.scaleForWidth(
      MediaQuery.of(tester.element(find.byType(HomeScreen))).size.width,
    );

    // The keyed render box includes the dot's 3*scale horizontal margins on
    // each side: active = (18 + 6)*scale, inactive = (6 + 6)*scale.
    double dotWidth(int index) => tester
        .renderObject<RenderBox>(find.byKey(Key('home_carousel_dot_$index')))
        .size
        .width;

    expect(dotWidth(0), 24 * scale);
    expect(dotWidth(1), 12 * scale);

    // CarouselSlider owns the 3s auto-play timer and the 450ms page animation.
    // The trailing pump lets the 250ms dot animation finish after the page
    // callback fires.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));

    expect(dotWidth(0), 12 * scale);
    expect(dotWidth(1), 24 * scale);
  });
}
