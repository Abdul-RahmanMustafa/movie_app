import 'package:movie_app/features/profile/domain/entities/user_profile.dart';
import 'package:movie_app/features/profile/presentation/providers/profile_controller.dart';

/// In-memory profile controller for widget tests.
class FakeProfileController implements ProfileController {
  FakeProfileController({
    this.profile = const UserProfile(
      uid: 'fake-uid',
      email: 'qa@example.com',
      name: 'QA User',
      phone: '01000000000',
      avatarIndex: 0,
    ),
    this.error,
  });

  final UserProfile profile;
  final Object? error;

  @override
  Stream<UserProfile> observeProfile() {
    final failure = error;
    if (failure != null) return Stream<UserProfile>.error(failure);
    return Stream<UserProfile>.value(profile);
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {}
}
