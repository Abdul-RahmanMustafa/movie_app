import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the test view to a 430 x 932 logical phone so layout assertions match
/// the Figma design frame regardless of the default 800 x 600 surface.
void usePhoneSurface(WidgetTester tester, {Size size = const Size(430, 932)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
