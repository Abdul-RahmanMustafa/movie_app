import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/layout/app_layout.dart';

void main() {
  test('scales to the design width on a typical phone', () {
    expect(AppLayout.scaleForWidth(430), 1);
    expect(AppLayout.scaleForWidth(360), closeTo(360 / 430, 0.0001));
  });

  test('clamps very small and very large widths', () {
    expect(AppLayout.scaleForWidth(320), AppLayout.minScale);
    expect(AppLayout.scaleForWidth(1200), AppLayout.maxScale);
  });
}
