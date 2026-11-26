
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../movies/presentation/widgets/movie_poster_image.dart';
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
    required this.emptyMessage,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onItemTap,
    this.showHeader = true,
    this.emptyAsset,
  });

  static const Color _cardBackground = Color(0xFF1D1D1D);

  final double scale;
  final String title;
  final String badge;
  final IconData icon;
  final List<ProfileListEntry> items;
  final String emptyMessage;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<ProfileListEntry>? onItemTap;
  final bool showHeader;
  final String? emptyAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
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
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12 * scale,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * scale),
        ],
        Expanded(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.accent,
            ),
          )
              : errorMessage != null
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFAAAAAA),
                    fontSize: 14 * scale,
                  ),
                ),
                if (onRetry != null) ...[
                  SizedBox(height: 8 * scale),
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('Try again'),
                  ),
                ],
              ],
            ),
          )
              : items.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (emptyAsset != null)
                  Image.asset(
                    emptyAsset!,
                    width: 126 * scale,
                    height: 126 * scale,
                    fit: BoxFit.contain,
                  ),
                if (emptyAsset == null ||
                    emptyMessage.isNotEmpty) ...[
                  SizedBox(height: 10 * scale),
                  Text(
                    emptyMessage,
                    style: TextStyle(
                      color: const Color(0xFFAAAAAA),
                      fontSize: 15 * scale,
                    ),
                  ),
                ],
              ],
            ),
          )
              : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: 10 * scale),
            itemBuilder: (context, index) {
              final item = items[index];

              return InkWell(
                onTap: onItemTap == null
                    ? null
                    : () => onItemTap!(item),
                borderRadius: BorderRadius.circular(12 * scale),
                child: Container(
                  height: 88 * scale,
                  padding: EdgeInsets.all(8 * scale),
                  decoration: BoxDecoration(
                    color: _cardBackground,
                    borderRadius:
                    BorderRadius.circular(12 * scale),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(8 * scale),
                        child: SizedBox(
                          width: 64 * scale,
                          height: 72 * scale,
                          child: item.posterUrl.isNotEmpty
                              ? MoviePosterImage(
                            imageUrl: item.posterUrl,
                          )
                              : item.asset != null
                              ? Image.asset(
                            item.asset!,
                            fit: BoxFit.cover,
                          )
                              : const MoviePosterImage(
                            imageUrl: '',
                          ),
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 17 * scale,
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
                                fontSize: 13 * scale,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
