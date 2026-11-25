import 'package:flutter/material.dart';

/// One row in the Watch List / History section.
class ProfileListEntry {
  const ProfileListEntry({
    required this.movieId,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    this.asset,
    this.posterUrl = '',
  });

  final int movieId;
  final String? asset;
  final String posterUrl;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
}
