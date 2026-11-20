import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

/// Section shown below the profile header.
enum _ProfileSection { none, watchList, history }

const Color _cardBackground = Color(0xFF1D1D1D);

/// Profile screen from Figma frame `51:511` (430 × 932).
///
/// The Figma X/Y positions are kept, but every element is rendered slightly
/// smaller than the raw measurements (`_compact`) and paired items are centred
/// in equal-width columns so the Watch List / History icons and captions line
/// up. The shared bottom navigation is drawn by `MainShell`, so the frame's
/// own nav bar is not duplicated here.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Figma "Rectangle 18" fill (#212121), the lighter top panel of the frame.
  static const Color _panelBackground = Color(0xFF212121);

  // Slight reduction applied to all sizes for a tidier, less crowded layout.
  static const double _compact = 0.9;

  // Watch List is selected by default so its content is visible immediately.
  _ProfileSection _section = _ProfileSection.watchList;
  String _name = 'John Safwat';

  Future<void> _openEditProfile() async {
    final editedName = await context.push<String>('/edit-profile');
    if (!mounted || editedName == null || editedName.trim().isEmpty) return;
    setState(() => _name = editedName.trim());
  }

  void _selectSection(_ProfileSection section) {
    setState(() => _section = section);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 430;
        // All sizes use `s`; Figma positions stay on the original `scale`.
        final s = scale * _compact;

        return SingleChildScrollView(
          child: SizedBox(
            height: 900 * scale,
            child: Stack(
              children: [
                // Top panel: 430 × 389 at (0, 0), fill #212121.
                Positioned(
                  left: 0,
                  top: 0,
                  width: 430 * scale,
                  height: 389 * scale,
                  child: Container(color: _panelBackground),
                ),

                // Profile picture: measured 118 × 118 at (24, 52).
                Positioned(
                  left: 24 * scale,
                  top: 52 * scale,
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.profilePfp,
                      width: 118 * s,
                      height: 118 * s,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Counters. Each number and caption are one compact, centred
                // column so `12 / Wish List` and `10 / History` read as a pair.
                _ProfileStat(
                  scale: s,
                  top: 84 * scale,
                  centerX: 238 * scale,
                  number: '12',
                  label: 'Wish List',
                ),
                _ProfileStat(
                  scale: s,
                  top: 84 * scale,
                  centerX: 364 * scale,
                  number: '10',
                  label: 'History',
                ),

                // User name centred on the same axis as the profile picture.
                Positioned(
                  left: 24 * scale,
                  top: 178 * scale,
                  width: 118 * s,
                  child: Text(
                    _name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto',
                      fontSize: 18 * s,
                      height: 1,
                    ),
                  ),
                ),

                // "Button" layer: measured 398 × 56 at (16, 232). Centred
                // horizontally so both margins match.
                Positioned(
                  left: (430 * scale - 398 * s) / 2,
                  top: 232 * scale,
                  child: SizedBox(
                    width: 398 * s,
                    height: 56 * s,
                    child: OutlinedButton(
                      onPressed: _openEditProfile,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: BorderSide(color: AppColors.accent, width: 1.2 * s),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * s),
                        ),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18 * s,
                        ),
                      ),
                    ),
                  ),
                ),

                // Gold divider ("Line 1"): measured 215 × 1 at (0, 388).
                Positioned(
                  left: 0,
                  top: 388 * scale,
                  width: 215 * s,
                  height: 1 * scale,
                  child: Container(color: AppColors.accent),
                ),

                // Shortcut buttons. Each pair shares a centre X, so the icon
                // sits directly above its caption and both groups are balanced.
                _ProfileShortcut(
                  scale: s,
                  centerX: 112 * scale,
                  top: 300 * scale,
                  iconAsset: AppAssets.profileWatchListIcon,
                  label: 'Watch List',
                  selected: _section == _ProfileSection.watchList,
                  onTap: () => _selectSection(_ProfileSection.watchList),
                ),
                _ProfileShortcut(
                  scale: s,
                  centerX: 318 * scale,
                  top: 300 * scale,
                  iconAsset: AppAssets.profileHistoryIcon,
                  label: 'History',
                  selected: _section == _ProfileSection.history,
                  onTap: () => _selectSection(_ProfileSection.history),
                ),

                // Content area. The default state keeps the Figma popcorn art;
                // tapping either shortcut switches to its own visible section.
                Positioned(
                  left: 16 * scale,
                  right: 16 * scale,
                  top: 410 * scale,
                  bottom: 96 * scale,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildSectionContent(s),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionContent(double s) {
    switch (_section) {
      case _ProfileSection.watchList:
        return _ProfileList(
          key: const ValueKey('watch-list'),
          scale: s,
          title: 'Watch List',
          badge: '12 saved',
          icon: Icons.bookmark,
          items: const [
            _ListEntry(
              asset: AppAssets.homeCardCenter,
              title: 'Oppenheimer',
              subtitle: 'Drama · 3h 0m',
              trailingIcon: Icons.play_arrow,
            ),
            _ListEntry(
              asset: AppAssets.homeCardLeft,
              title: 'Interstellar',
              subtitle: 'Sci-fi · 2h 49m',
              trailingIcon: Icons.play_arrow,
            ),
            _ListEntry(
              asset: AppAssets.homeCardRight,
              title: 'The Dark Knight',
              subtitle: 'Action · 2h 32m',
              trailingIcon: Icons.play_arrow,
            ),
          ],
        );
      case _ProfileSection.history:
        return _ProfileList(
          key: const ValueKey('history'),
          scale: s,
          title: 'History',
          badge: '10 watched',
          icon: Icons.history,
          items: const [
            _ListEntry(
              asset: AppAssets.homeActionCard1,
              title: 'Inception',
              subtitle: 'Watched today',
              trailingIcon: Icons.check,
            ),
            _ListEntry(
              asset: AppAssets.homeActionCard2,
              title: 'Parasite',
              subtitle: 'Watched yesterday',
              trailingIcon: Icons.check,
            ),
            _ListEntry(
              asset: AppAssets.homeActionCard3,
              title: 'Joker',
              subtitle: 'Watched 3 days ago',
              trailingIcon: Icons.check,
            ),
          ],
        );
      case _ProfileSection.none:
        return Center(
          key: const ValueKey('popcorn'),
          child: Image.asset(
            AppAssets.profilePopcorn,
            width: 124 * s,
            height: 124 * s,
            fit: BoxFit.contain,
          ),
        );
    }
  }
}

/// Number + caption block. Both texts live in one narrow centred column, so
/// there is no loose gap between the count and what it counts.
class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
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

/// Tappable icon + caption pair. The active shortcut is highlighted in gold so
/// it is obvious which section is being shown.
class _ProfileShortcut extends StatelessWidget {
  const _ProfileShortcut({
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
                            selected ? AppColors.accent : const Color(0xFF9A9A9A),
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

class _ListEntry {
  const _ListEntry({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
  });

  final String asset;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
}

/// Visible content for the selected Watch List / History shortcut.
class _ProfileList extends StatelessWidget {
  const _ProfileList({
    super.key,
    required this.scale,
    required this.title,
    required this.badge,
    required this.icon,
    required this.items,
  });

  final double scale;
  final String title;
  final String badge;
  final IconData icon;
  final List<_ListEntry> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 20 * scale),
            SizedBox(width: 8 * scale),
            Text(
              title,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Roboto',
                fontSize: 22 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10 * scale,
                vertical: 5 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0x1AF6BD00),
                borderRadius: BorderRadius.circular(20 * scale),
              ),
              child: Text(
                badge,
                style: TextStyle(color: AppColors.accent, fontSize: 12 * scale),
              ),
            ),
          ],
        ),
        SizedBox(height: 14 * scale),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(height: 10 * scale),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                height: 72 * scale,
                padding: EdgeInsets.all(8 * scale),
                decoration: BoxDecoration(
                  color: _cardBackground,
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8 * scale),
                      child: Image.asset(
                        item.asset,
                        width: 52 * scale,
                        height: 56 * scale,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12 * scale),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4 * scale),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFFAAAAAA),
                              fontSize: 12 * scale,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      item.trailingIcon,
                      color: AppColors.accent,
                      size: 22 * scale,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
