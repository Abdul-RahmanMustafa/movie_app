import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../layout/app_layout.dart';
import '../localization/localization_extensions.dart';
import '../theme/app_colors.dart';

/// Figma Home frame `47:1248` bottom navigation bar.
///
/// Measured in the 430 x 932 design frame:
/// - bar: X 9, Y 862, 413 x 61, radius 16, fill #282A28
/// - home icon: 26 x 23, active #F6BD00
/// - vector icon: 24 x 24
/// - explore / profile icons: 22.42 x 22.42
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const int homeIndex = 0;
  static const int vectorIndex = 1;
  static const int exploreIndex = 2;
  static const int profileIndex = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = AppLayout.scaleForWidth(constraints.maxWidth);
        final bottomInset = MediaQuery.paddingOf(context).bottom;
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            9 * scale,
            0,
            8 * scale,
            9 * scale + bottomInset,
          ),
          child: SizedBox(
            height: 61 * scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16 * scale),
              ),
              child: Row(
                // Four equal slots distribute the icons across the bar.
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Semantics(
                      button: true,
                      selected: selectedIndex == index,
                      label: _label(context, index),
                      child: InkWell(
                        onTap: () => onTap(index),
                        borderRadius: BorderRadius.circular(16 * scale),
                        child: Center(
                          child: _icon(index, selectedIndex == index, scale),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  String _label(BuildContext context, int index) {
    return switch (index) {
      homeIndex => context.l10n.navHome,
      vectorIndex => context.l10n.navSearch,
      exploreIndex => context.l10n.navExplore,
      _ => context.l10n.navProfile,
    };
  }

  /// Returns the correct supplied icon for a tab, tinted by active state.
  Widget _icon(int index, bool active, double scale) {
    final color = active ? AppColors.accent : AppColors.white;
    final filter = ColorFilter.mode(color, BlendMode.srcIn);

    switch (index) {
      case homeIndex:
        return SvgPicture.asset(
          AppAssets.icHome,
          width: 26 * scale,
          height: 23 * scale,
          colorFilter: filter,
        );
      case vectorIndex:
        return Image.asset(
          AppAssets.icVector,
          width: 24 * scale,
          height: 24 * scale,
          color: color,
        );
      case exploreIndex:
        return SvgPicture.asset(
          AppAssets.icExplore,
          width: 22.42 * scale,
          height: 22.42 * scale,
          colorFilter: filter,
        );
      default:
        return SvgPicture.asset(
          AppAssets.icProfile,
          width: 22.42 * scale,
          height: 22.42 * scale,
          colorFilter: filter,
        );
    }
  }
}
