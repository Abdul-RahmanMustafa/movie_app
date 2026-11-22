import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/auth_user.dart';

abstract interface class FirestoreUserDataSource {
  Future<void> saveProfile(AuthUser user);

  Future<void> mergeGoogleProfile(AuthUser user);
}

class FirestoreUserDataSourceImpl implements FirestoreUserDataSource {
  FirestoreUserDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveProfile(AuthUser user) async {
    final reference = _firestore.collection('users').doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);
      final data = <String, Object?>{
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'avatarIndex': user.avatarIndex,
        'updatedAt': FieldValue.serverTimestamp(),
        'authProvider': user.authProvider,
      };

      if (!snapshot.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      transaction.set(reference, data, SetOptions(merge: true));
    });
  }

  @override
  Future<void> mergeGoogleProfile(AuthUser user) async {
    final reference = _firestore.collection('users').doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);
      final existingData = snapshot.data() ?? <String, Object?>{};
      final data = <String, Object?>{'updatedAt': FieldValue.serverTimestamp()};

      void addIfMissing(String key, Object? value) {
        if (!existingData.containsKey(key)) data[key] = value;
      }

      addIfMissing('uid', user.uid);
      addIfMissing('name', user.name);
      addIfMissing('email', user.email);
      addIfMissing('phone', user.phone);
      addIfMissing('avatarIndex', user.avatarIndex);
      addIfMissing('authProvider', user.authProvider);
      if (!existingData.containsKey('createdAt')) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      transaction.set(reference, data, SetOptions(merge: true));
    });
  }
}
