import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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

    return Image.network(
      imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => const _PosterFallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(
          color: Color(0xFF1E201E),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.accent,
              strokeWidth: 2,
            ),
          ),
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
