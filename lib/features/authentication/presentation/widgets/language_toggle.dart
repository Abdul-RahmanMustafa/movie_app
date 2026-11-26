
import 'package:flutter/material.dart';

import '../theme/auth_styles.dart';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  int selected = 0;




  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: authYellow,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          2,
              (i) => GestureDetector(
            onTap: () => setState(() => selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: selected == i
                    ? authYellow
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ClipOval(
                  child: CustomPaint(
                    size: const Size(27, 27),
                    painter: _FlagPainter(isEgypt: i == 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



}

class _FlagPainter extends CustomPainter {
  const _FlagPainter({required this.isEgypt});

  final bool isEgypt;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.save();
    canvas.clipPath(
      Path()..addOval(rect),
    );

    if (isEgypt) {
      _drawEgyptFlag(canvas, size);
    } else {
      _drawUsFlag(canvas, size);
    }

    canvas.restore();
  }

  void _drawUsFlag(Canvas canvas, Size size) {
    final stripeHeight = size.height / 13;

    for (int i = 0; i < 13; i++) {
      final paint = Paint()
        ..color = i.isEven
            ? const Color(0xFFB22234)
            : Colors.white;

      canvas.drawRect(
        Rect.fromLTWH(
          0,
          i * stripeHeight,
          size.width,
          stripeHeight + 0.2,
        ),
        paint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width * 0.52,
        stripeHeight * 7,
      ),
      Paint()..color = const Color(0xFF3C3B6E),
    );

    final starPaint = Paint()..color = Colors.white;

    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(
            size.width * (0.07 + col * 0.12),
            size.height * (0.07 + row * 0.105),
          ),
          0.65,
          starPaint,
        );
      }
    }
  }

  void _drawEgyptFlag(Canvas canvas, Size size) {
    final stripeHeight = size.height / 3;

    final colors = [
      const Color(0xFFCE1126),
      Colors.white,
      Colors.black,
    ];

    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          i * stripeHeight,
          size.width,
          stripeHeight + 0.2,
        ),
        Paint()..color = colors[i],
      );
    }

    final emblemPaint = Paint()
      ..color = const Color(0xFFC09300)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.085,
      emblemPaint,
    );

    final wingPaint = Paint()
      ..color = const Color(0xFFC09300)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = size.width / 2;
    final middle = size.height / 2;

    canvas.drawLine(
      Offset(center - 4, middle),
      Offset(center + 4, middle),
      wingPaint,
    );
    canvas.drawLine(
      Offset(center - 4, middle),
      Offset(center - 2, middle - 2),
      wingPaint,
    );
    canvas.drawLine(
      Offset(center + 4, middle),
      Offset(center + 2, middle - 2),
      wingPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FlagPainter oldDelegate) {
    return oldDelegate.isEgypt != isEgypt;
  }
}
