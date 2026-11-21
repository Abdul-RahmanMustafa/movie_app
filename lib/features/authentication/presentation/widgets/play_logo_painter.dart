import 'package:flutter/material.dart';

import '../theme/auth_styles.dart';

class PlayLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = authYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.5),
      size.width * 0.37,
      stroke,
    );
    final path = Path()
      ..moveTo(size.width * 0.23, size.height * 0.24)
      ..lineTo(size.width * 0.23, size.height * 0.76)
      ..lineTo(size.width * 0.64, size.height * 0.5)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = authYellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
