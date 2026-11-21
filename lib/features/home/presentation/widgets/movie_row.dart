import 'package:flutter/material.dart';

/// Horizontally scrollable movie cards.
///
/// Reusing the supplied card assets is intentional for this UI-only pass.
class MovieRow extends StatelessWidget {
  const MovieRow({super.key, required this.images, required this.scale});

  final List<String> images;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
        itemCount: images.length,
        separatorBuilder: (_, _) => SizedBox(width: 12 * scale),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12 * scale),
            child: SizedBox(
              width: 146 * scale,
              height: 220 * scale,
              child: Image.asset(
                images[index % images.length],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
