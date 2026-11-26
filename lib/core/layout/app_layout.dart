import 'package:flutter/widgets.dart';

/// Shared layout metrics for the 430px Figma design frames.
///
/// Screens derive a single scale from the available width, but it is clamped so
/// tablets and small phones keep readable text and do not overflow.
abstract final class AppLayout {
  static const double designWidth = 430;
  static const double minScale = 0.8;
  static const double maxScale = 1.25;

  static double scaleForWidth(double width) =>
      (width / designWidth).clamp(minScale, maxScale).toDouble();

  static double scaleOf(BuildContext context) =>
      scaleForWidth(MediaQuery.sizeOf(context).width);

  /// Extra space reserved at the bottom of scrollable tab pages for the
  /// floating navigation bar plus the system gesture inset.
  static double bottomContentPadding(BuildContext context, double scale) {
    return 96 * scale + MediaQuery.paddingOf(context).bottom;
  }
}
