import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Stream<UserProfile> observeProfile();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });
}
