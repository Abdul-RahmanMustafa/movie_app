import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Network poster with a stable placeholder and a short fade-in.
///
/// The decoded bitmap is capped to the rendered width, which keeps large YTS
/// artwork from allocating several megabytes per visible card.
class MoviePosterImage extends StatelessWidget {
  const MoviePosterImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const _PosterFallback();

    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cacheWidth = width.isFinite && width > 0
            ? (width * devicePixelRatio).round()
            : null;

        return Image.network(
          imageUrl,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: cacheWidth,
          gaplessPlayback: true,
          filterQuality: FilterQuality.low,
          errorBuilder: (_, _, _) => const _PosterFallback(),
          // No progress spinner: rebuilding a spinner per visible card during
          // scrolling was a measurable source of jank.
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return const ColoredBox(color: Color(0xFF1E201E));
          },
        );
      },
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF1E201E),
      child: Center(
        child: Icon(Icons.movie_outlined, color: AppColors.accent, size: 42),
      ),
    );
  }
}
