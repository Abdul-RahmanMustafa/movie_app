import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class ObserveProfile {
  const ObserveProfile(this._repository);

  final ProfileRepository _repository;

  Stream<UserProfile> call() => _repository.observeProfile();
}
