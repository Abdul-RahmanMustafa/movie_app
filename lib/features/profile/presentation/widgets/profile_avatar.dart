import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarIndex,
    required this.size,
  });

  final int avatarIndex;
  final double size;

  static const _backgrounds = <Color>[
    Color(0xFF9DDCF4),
    Color(0xFFF4C27A),
    Color(0xFFC5A7E8),
    Color(0xFF8FD4B4),
    Color(0xFFE9A3A3),
    Color(0xFF9EB8E7),
    Color(0xFFF0D682),
    Color(0xFFB7D38A),
    Color(0xFFD5A8C8),
  ];

  static const _icons = <IconData>[
    Icons.face_6,
    Icons.face,
    Icons.face_3,
    Icons.face_4,
    Icons.face_2,
    Icons.sentiment_very_satisfied,
    Icons.emoji_people,
    Icons.person_2,
    Icons.person_4,
  ];

  @override
  Widget build(BuildContext context) {
    final index = avatarIndex.clamp(0, 8).toInt();
    if (index == 0) {
      return ClipOval(
        child: Image.asset(
          AppAssets.profilePfp,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _backgrounds[index],
      ),
      child: Icon(
        _icons[index],
        size: size * 0.68,
        color: const Color(0xFF48332A),
      ),
    );
  }
}
