import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Number + caption block. Both texts live in one narrow centred column, so
/// there is no loose gap between the count and what it counts.
class ProfileStat extends StatelessWidget {
  const ProfileStat({
    super.key,
    required this.scale,
    this.top = 0,
    this.centerX = 0,
    required this.number,
    required this.label,
    this.positioned = true,
  });

  final double scale;
  final double top;
  final double centerX;
  final String number;
  final String label;
  final bool positioned;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: 82 * scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Roboto',
              fontSize: 25 * scale,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          SizedBox(height: 8 * scale),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'Roboto',
              fontSize: 14 * scale,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
    if (!positioned) return content;
    return Positioned(left: centerX - 41 * scale, top: top, child: content);
  }
}
