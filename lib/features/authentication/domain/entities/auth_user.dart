class AuthUser {
  const AuthUser({
    required this.uid,
    required this.email,
    this.name = '',
    this.phone = '',
    this.avatarIndex = 0,
    this.authProvider = 'password',
  });

  final String uid;
  final String email;
  final String name;
  final String phone;
  final int avatarIndex;
  final String authProvider;
}
