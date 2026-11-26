
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarIndex,
    required this.size,
  });

  final int avatarIndex;
  final double size;

  @override
  Widget build(BuildContext context) {
    final index = avatarIndex.clamp(0, 8).toInt();

    return ClipOval(
      child: Image.asset(
        'assets/images/profile/profile${index + 1}.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
