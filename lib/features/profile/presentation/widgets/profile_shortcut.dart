import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

/// Tappable icon + caption pair. The active shortcut is highlighted in gold so
/// it is obvious which section is being shown.
class ProfileShortcut extends StatelessWidget {
  const ProfileShortcut({
    super.key,
    required this.scale,
    required this.centerX,
    required this.top,
    required this.iconAsset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final double scale;
  final double centerX;
  final double top;
  final String iconAsset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: centerX - 60 * scale,
      top: top,
      child: SizedBox(
        width: 120 * scale,
        height: 76 * scale,
        child: Material(
          color: selected ? const Color(0xFF2C2C2C) : Colors.transparent,
          borderRadius: BorderRadius.circular(14 * scale),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14 * scale),
            // IntrinsicWidth hugs the content; Column's centre alignment then
            // puts the icon box and the caption on the exact same centre line.
            child: Center(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 34 * scale,
                      height: 34 * scale,
                      child: Center(
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            selected
                                ? AppColors.accent
                                : const Color(0xFF9A9A9A),
                            BlendMode.srcIn,
                          ),
                          child: SvgPicture.asset(
                            iconAsset,
                            width: 30 * scale,
                            height: 30 * scale,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2 * scale),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? AppColors.accent : AppColors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
