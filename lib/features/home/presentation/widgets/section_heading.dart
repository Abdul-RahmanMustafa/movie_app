import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// "Action" heading with the gold "See More" link from the Figma frame.
class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
      child: Row(
        children: [
          Text(
            'Action',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Roboto',
              fontSize: 20 * scale,
            ),
          ),
          const Spacer(),
          Text(
            'See More',
            style: TextStyle(
              color: AppColors.accent,
              fontFamily: 'Roboto',
              fontSize: 16 * scale,
            ),
          ),
          SizedBox(width: 4 * scale),
          Icon(
            Icons.arrow_forward_ios,
            size: 14 * scale,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}
