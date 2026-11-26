import '../repositories/profile_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final ProfileRepository _repository;

  Future<void> call({
    required String name,
    required String phone,
    required int avatarIndex,
  }) {
    return _repository.updateProfile(
      name: name,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }
}
