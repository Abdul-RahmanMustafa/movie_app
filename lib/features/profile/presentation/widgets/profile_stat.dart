import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Number + caption block. Both texts live in one narrow centred column, so
/// there is no loose gap between the count and what it counts.
class ProfileStat extends StatelessWidget {
  const ProfileStat({
    super.key,
    required this.scale,
    required this.top,
    required this.centerX,
    required this.number,
    required this.label,
  });

  final double scale;
  final double top;
  final double centerX;
  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: centerX - 60 * scale,
      top: top,
      child: SizedBox(
        width: 120 * scale,
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
                fontSize: 30 * scale,
                height: 1,
              ),
            ),
            SizedBox(height: 4 * scale),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Roboto',
                fontSize: 17 * scale,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
