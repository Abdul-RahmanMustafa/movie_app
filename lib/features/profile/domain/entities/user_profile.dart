class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.avatarIndex,
  });

  final String uid;
  final String email;
  final String name;
  final String phone;
  final int avatarIndex;
}
