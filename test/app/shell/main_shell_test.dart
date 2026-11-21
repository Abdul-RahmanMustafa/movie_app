import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app/shell/main_shell.dart';
import 'package:movie_app/app/shell/widgets/placeholder_tab.dart';
import 'package:movie_app/features/explore/presentation/screens/explore_screen.dart';

void main() {
  testWidgets('uses the Explore scaffold instead of a generic placeholder',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));

    // IndexedStack keeps the other tabs offstage but mounted.
    expect(find.byType(ExploreScreen, skipOffstage: false), findsOneWidget);
    expect(
      find.widgetWithText(PlaceholderTab, 'Explore', skipOffstage: false),
      findsNothing,
    );

    // Search still uses the temporary placeholder tab.
    expect(
      find.widgetWithText(PlaceholderTab, 'Search', skipOffstage: false),
      findsOneWidget,
    );
  });
}
