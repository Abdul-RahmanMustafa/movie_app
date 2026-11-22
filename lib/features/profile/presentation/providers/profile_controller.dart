import '../../data/datasources/firebase_profile_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/observe_profile.dart';
import '../../domain/usecases/update_profile.dart';

abstract interface class ProfileController {
  Stream<UserProfile> observeProfile();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });
}

class ProfileControllerImpl implements ProfileController {
  const ProfileControllerImpl(this._observeProfile, this._updateProfile);

  factory ProfileControllerImpl.firebase() {
    final repository = ProfileRepositoryImpl(FirebaseProfileDataSourceImpl());
    return ProfileControllerImpl(
      ObserveProfile(repository),
      UpdateProfile(repository),
    );
  }

  final ObserveProfile _observeProfile;
  final UpdateProfile _updateProfile;

  @override
  Stream<UserProfile> observeProfile() => _observeProfile();

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) {
    return _updateProfile(name: name, phone: phone, avatarIndex: avatarIndex);
  }
}

abstract final class ProfileDependencies {
  static final ProfileController controller = ProfileControllerImpl.firebase();
}
