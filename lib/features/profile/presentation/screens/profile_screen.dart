import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../profile_section.dart';
import '../models/profile_list_entry.dart';
import '../widgets/profile_list.dart';
import '../widgets/profile_shortcut.dart';
import '../widgets/profile_stat.dart';

/// Profile screen from Figma frame `51:511` (430 × 932).
///
/// Widget helpers live in their own files under `../widgets`; this file only
/// owns the screen and its private state. The shared bottom navigation is
/// drawn by `MainShell`, so the frame's own nav bar is not duplicated here.
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
  ProfileSection _section = ProfileSection.watchList;
  String _name = 'John Safwat';

  Future<void> _openEditProfile() async {
    final editedName = await context.push<String>('/edit-profile');
    if (!mounted || editedName == null || editedName.trim().isEmpty) return;
    setState(() => _name = editedName.trim());
  }

  void _selectSection(ProfileSection section) {
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
                ProfileStat(
                  scale: s,
                  top: 84 * scale,
                  centerX: 238 * scale,
                  number: '12',
                  label: 'Wish List',
                ),
                ProfileStat(
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
                        side: BorderSide(
                          color: AppColors.accent,
                          width: 1.2 * s,
                        ),
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
                ProfileShortcut(
                  scale: s,
                  centerX: 112 * scale,
                  top: 300 * scale,
                  iconAsset: AppAssets.profileWatchListIcon,
                  label: 'Watch List',
                  selected: _section == ProfileSection.watchList,
                  onTap: () => _selectSection(ProfileSection.watchList),
                ),
                ProfileShortcut(
                  scale: s,
                  centerX: 318 * scale,
                  top: 300 * scale,
                  iconAsset: AppAssets.profileHistoryIcon,
                  label: 'History',
                  selected: _section == ProfileSection.history,
                  onTap: () => _selectSection(ProfileSection.history),
                ),

                // Content area switches between Watch List and History.
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
      case ProfileSection.watchList:
        return ProfileList(
          key: const ValueKey('watch-list'),
          scale: s,
          title: 'Watch List',
          badge: '12 saved',
          icon: Icons.bookmark,
          items: const [
            ProfileListEntry(
              asset: AppAssets.homeCardCenter,
              title: 'Oppenheimer',
              subtitle: 'Drama · 3h 0m',
              trailingIcon: Icons.play_arrow,
            ),
            ProfileListEntry(
              asset: AppAssets.homeCardLeft,
              title: 'Interstellar',
              subtitle: 'Sci-fi · 2h 49m',
              trailingIcon: Icons.play_arrow,
            ),
            ProfileListEntry(
              asset: AppAssets.homeCardRight,
              title: 'The Dark Knight',
              subtitle: 'Action · 2h 32m',
              trailingIcon: Icons.play_arrow,
            ),
          ],
        );
      case ProfileSection.history:
        return ProfileList(
          key: const ValueKey('history'),
          scale: s,
          title: 'History',
          badge: '10 watched',
          icon: Icons.history,
          items: const [
            ProfileListEntry(
              asset: AppAssets.homeActionCard1,
              title: 'Inception',
              subtitle: 'Watched today',
              trailingIcon: Icons.check,
            ),
            ProfileListEntry(
              asset: AppAssets.homeActionCard2,
              title: 'Parasite',
              subtitle: 'Watched yesterday',
              trailingIcon: Icons.check,
            ),
            ProfileListEntry(
              asset: AppAssets.homeActionCard3,
              title: 'Joker',
              subtitle: 'Watched 3 days ago',
              trailingIcon: Icons.check,
            ),
          ],
        );
      case ProfileSection.none:
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
