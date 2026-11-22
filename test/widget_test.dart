import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/app.dart';

void main() {
  testWidgets('MovieApp renders successfully', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold()),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MovieApp(routerConfig: router));

    expect(find.byType(MovieApp), findsOneWidget);
  });
}
