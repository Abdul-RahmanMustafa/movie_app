import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class FirebaseAuthDataSource {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  Future<User> signInWithGoogle();

  Future<User> createUserWithEmail({
    required String email,
    required String password,
  });

  Future<User> updateDisplayName(User user, String name);

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  FirebaseAuthDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  static Future<void>? _googleInitialization;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user ??
        (throw StateError('Firebase returned no user after sign in.'));
  }

  @override
  Future<User> signInWithGoogle() async {
    await (_googleInitialization ??= _googleSignIn.initialize());
    if (!_googleSignIn.supportsAuthenticate()) {
      throw UnsupportedError(
        'Interactive Google Sign-In is unavailable on this platform.',
      );
    }

    final googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google Sign-In returned no ID token.');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user ??
        (throw StateError('Firebase returned no user after Google Sign-In.'));
  }

  @override
  Future<User> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user ??
        (throw StateError('Firebase returned no user after registration.'));
  }

  @override
  Future<User> updateDisplayName(User user, String name) async {
    await user.updateDisplayName(name);
    await user.reload();
    return _firebaseAuth.currentUser ?? user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    final usesGoogle =
        _firebaseAuth.currentUser?.providerData.any(
          (provider) => provider.providerId == GoogleAuthProvider.PROVIDER_ID,
        ) ??
        false;

    if (usesGoogle) {
      await (_googleInitialization ??= _googleSignIn.initialize());
      await _googleSignIn.signOut();
    }

    await _firebaseAuth.signOut();
  }
}
