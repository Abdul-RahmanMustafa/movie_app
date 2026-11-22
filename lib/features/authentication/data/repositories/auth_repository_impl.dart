import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/auth_failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';
import '../datasources/firestore_user_data_source.dart';
import '../firebase_failure_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authDataSource, this._firestoreUserDataSource);

  final FirebaseAuthDataSource _authDataSource;
  final FirestoreUserDataSource _firestoreUserDataSource;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _authDataSource.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _toAuthUser(firebaseUser);
    });
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final user = await _authDataSource.signInWithEmail(
        email: normalizedEmail,
        password: password,
      );
      return _toAuthUser(user, fallbackEmail: normalizedEmail);
    } catch (error) {
      throw FirebaseFailureMapper.fromAuth(error);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    late User firebaseUser;
    try {
      firebaseUser = await _authDataSource.signInWithGoogle();
    } catch (error) {
      throw FirebaseFailureMapper.fromGoogle(error);
    }

    final user = AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email?.trim().toLowerCase() ?? '',
      name: firebaseUser.displayName?.trim() ?? '',
      phone: firebaseUser.phoneNumber?.trim() ?? '',
      authProvider: 'google',
    );

    try {
      await _firestoreUserDataSource.mergeGoogleProfile(user);
    } catch (error) {
      throw FirebaseFailureMapper.fromGoogleProfileWrite(error);
    }

    return user;
  }

  @override
  Future<AuthUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedName = name.trim();
    final normalizedPhone = phone.trim();

    late User firebaseUser;
    try {
      final currentUser = _authDataSource.currentUser;
      if (currentUser != null) {
        if (currentUser.email?.toLowerCase() != normalizedEmail) {
          throw const AuthFailure(
            type: AuthFailureType.unexpected,
            message:
                'Another account is already signed in. Please restart '
                'the registration flow and try again.',
          );
        }
        firebaseUser = currentUser;
      } else {
        firebaseUser = await _authDataSource.createUserWithEmail(
          email: normalizedEmail,
          password: password,
        );
      }

      firebaseUser = await _authDataSource.updateDisplayName(
        firebaseUser,
        normalizedName,
      );
    } catch (error) {
      throw FirebaseFailureMapper.fromAuth(error);
    }

    final user = AuthUser(
      uid: firebaseUser.uid,
      email: normalizedEmail,
      name: normalizedName,
      phone: normalizedPhone,
      avatarIndex: avatarIndex,
    );

    try {
      await _firestoreUserDataSource.saveProfile(user);
    } catch (error) {
      throw FirebaseFailureMapper.fromProfileWrite(error);
    }

    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      await _authDataSource.sendPasswordResetEmail(normalizedEmail);
    } on FirebaseAuthException catch (error) {
      // A reset request must not reveal whether an account exists.
      if (error.code == 'user-not-found') return;
      throw FirebaseFailureMapper.fromPasswordReset(error);
    } catch (error) {
      throw FirebaseFailureMapper.fromPasswordReset(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authDataSource.signOut();
    } catch (error) {
      throw FirebaseFailureMapper.fromSignOut(error);
    }
  }

  AuthUser _toAuthUser(User user, {String? fallbackEmail}) {
    final usesGoogle = user.providerData.any(
      (provider) => provider.providerId == GoogleAuthProvider.PROVIDER_ID,
    );

    return AuthUser(
      uid: user.uid,
      email: user.email?.trim().toLowerCase() ?? fallbackEmail ?? '',
      name: user.displayName?.trim() ?? '',
      phone: user.phoneNumber?.trim() ?? '',
      authProvider: usesGoogle ? 'google' : 'password',
    );
  }
}
