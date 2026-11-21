import 'package:flutter/material.dart';

/// One demo row in the Watch List / History section.
class ProfileListEntry {
  const ProfileListEntry({
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
