import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> authStateChanges();

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser> signInWithGoogle();

  Future<AuthUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
