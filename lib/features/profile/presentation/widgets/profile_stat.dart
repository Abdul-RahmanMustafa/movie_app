
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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
      width: 100 * scale,
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
              fontSize: 36 * scale,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          SizedBox(height: 20 * scale),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Roboto',
                fontSize: 24 * scale,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );

    if (!positioned) return content;

    return Positioned(
      left: centerX - 50 * scale,
      top: top,
      child: content,
    );
  }
}
