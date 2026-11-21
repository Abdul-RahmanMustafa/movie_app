import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/profile_list_entry.dart';

/// Visible content for the selected Watch List / History shortcut.
class ProfileList extends StatelessWidget {
  const ProfileList({
    super.key,
    required this.scale,
    required this.title,
    required this.badge,
    required this.icon,
    required this.items,
  });

  static const Color _cardBackground = Color(0xFF1D1D1D);

  final double scale;
  final String title;
  final String badge;
  final IconData icon;
  final List<ProfileListEntry> items;

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
