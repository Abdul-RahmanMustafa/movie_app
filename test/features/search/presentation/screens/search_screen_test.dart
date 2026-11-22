import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/entities/movie_page.dart';
import 'package:movie_app/features/search/presentation/screens/search_screen.dart';

import '../../../../helpers/fake_movies_controller.dart';

void main() {
  testWidgets('debounces non-empty searches and sends query_term', (
    tester,
  ) async {
    final controller = FakeMoviesController();
    await tester.pumpWidget(
      MaterialApp(home: SearchScreen(moviesController: controller)),
    );

    await tester.enterText(
      find.byKey(const Key('movie_search_field')),
      'matrix',
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.queries, isEmpty);

    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();

    expect(controller.queries, hasLength(1));
    expect(controller.queries.single.queryTerm, 'matrix');
    expect(find.text('First Movie'), findsOneWidget);
  });

  testWidgets('older responses cannot replace newer search results', (
    tester,
  ) async {
    final oldResult = Completer<MoviePage>();
    final newResult = Completer<MoviePage>();
    final controller = FakeMoviesController(
      listMoviesHandler: (query) {
        return query.queryTerm == 'old' ? oldResult.future : newResult.future;
      },
    );
    await tester.pumpWidget(
      MaterialApp(home: SearchScreen(moviesController: controller)),
    );

    await tester.enterText(find.byType(TextField), 'old');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.enterText(find.byType(TextField), 'new');
    await tester.pump(const Duration(milliseconds: 450));

    newResult.complete(_pageWith(_movie(20, 'New Result')));
    await tester.pump();
    expect(find.text('New Result'), findsOneWidget);

    oldResult.complete(_pageWith(_movie(10, 'Old Result')));
    await tester.pump();
    expect(find.text('New Result'), findsOneWidget);
    expect(find.text('Old Result'), findsNothing);
  });
}

MoviePage _pageWith(Movie movie) {
  return MoviePage(movies: [movie], movieCount: 1, limit: 20, pageNumber: 1);
}

Movie _movie(int id, String title) {
  return Movie(
    id: id,
    title: title,
    year: 2024,
    rating: 7,
    genres: const [],
    description: '',
    smallPosterUrl: '',
    mediumPosterUrl: '',
    largePosterUrl: '',
  );
}
