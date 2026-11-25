import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_profile.dart';

class ProfileDataException implements Exception {
  const ProfileDataException();
}

abstract interface class FirebaseProfileDataSource {
  Stream<UserProfile> observeProfile();

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  });
}

class FirebaseProfileDataSourceImpl implements FirebaseProfileDataSource {
  FirebaseProfileDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User _currentUser() =>
      _firebaseAuth.currentUser ?? (throw const ProfileDataException());

  @override
  Stream<UserProfile> observeProfile() {
    final user = _currentUser();
    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      final data = doc.data() ?? const <String, dynamic>{};
      return UserProfile(
        uid: user.uid,
        email: _string(data['email'], user.email),
        name: _string(data['name'], user.displayName),
        phone: _string(data['phone'], user.phoneNumber),
        avatarIndex: _avatarIndex(data['avatarIndex']),
      );
    });
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    final user = _currentUser();
    await user.updateDisplayName(name);
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'phone': phone,
      'avatarIndex': avatarIndex,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

String _string(Object? value, String? fallback) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  return fallback?.trim() ?? '';
}

int _avatarIndex(Object? value) {
  final index = value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  return index.clamp(0, 8).toInt();
}
