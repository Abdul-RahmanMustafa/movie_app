import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';

/// "Action" heading with the gold "See More" link from the Figma frame.
class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.scale, this.onSeeMore});

  final double scale;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
      child: Row(
        children: [
          Text(
            context.l10n.homeAction,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Roboto',
              fontSize: 20 * scale,
            ),
          ),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSeeMore,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.homeSeeMore,
                  style: TextStyle(
                    color: AppColors.accent,
                    fontFamily: 'Roboto',
                    fontSize: 16 * scale,
                  ),
                ),
                SizedBox(width: 4 * scale),
                Icon(
                  context.isArabic
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios,
                  size: 14 * scale,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
