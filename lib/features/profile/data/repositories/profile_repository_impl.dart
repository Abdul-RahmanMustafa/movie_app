import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/profile_failure.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/firebase_profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final FirebaseProfileDataSource _dataSource;

  @override
  Stream<UserProfile> observeProfile() {
    try {
      return _dataSource.observeProfile().handleError(
        (Object error) => throw _mapFailure(error),
      );
    } catch (error) {
      return Stream.error(_mapFailure(error));
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    try {
      await _dataSource.updateProfile(
        name: name.trim(),
        phone: phone.trim(),
        avatarIndex: avatarIndex,
      );
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  ProfileFailure _mapFailure(Object error) {
    if (error is ProfileFailure) return error;
    if (error is ProfileDataException) {
      return const ProfileFailure(
        type: ProfileFailureType.unauthenticated,
        message: 'Please sign in to manage your profile.',
      );
    }
    if (error is FirebaseException) {
      final code = error.code;
      if (code == 'permission-denied') {
        return const ProfileFailure(
          type: ProfileFailureType.permissionDenied,
          message: 'You do not have permission to update this profile.',
        );
      }
      if (code == 'unavailable' ||
          code == 'deadline-exceeded' ||
          code == 'network-request-failed') {
        return const ProfileFailure(
          type: ProfileFailureType.network,
          message: 'Could not reach your profile. Check your connection.',
        );
      }
    }
    return const ProfileFailure(
      type: ProfileFailureType.unexpected,
      message: 'Something went wrong with your profile. Please try again.',
    );
  }
}
