import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Placeholder for one genre chip in the Figma Browse/Explore frame.
///
/// The label is static for now. When the database is connected, replace the
/// `label` passed by `ExploreScreen` with `genre.name` from the genre query.
class ExploreGenreChip extends StatelessWidget {
  const ExploreGenreChip({
    super.key,
    required this.label,
    required this.width,
    required this.scale,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final double width;
  final double scale;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48 * scale,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12 * scale),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12 * scale),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12 * scale),
              border: Border.all(
                color: selected ? AppColors.accent : AppColors.surface,
                width: 1.2 * scale,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Roboto',
                fontSize: 16 * scale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
