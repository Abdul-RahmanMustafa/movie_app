import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app/app.dart';

void main() {
  testWidgets('MovieApp renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieApp());

    expect(find.byType(MovieApp), findsOneWidget);
  });
}
