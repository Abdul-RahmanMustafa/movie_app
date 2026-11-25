import 'package:movie_app/features/authentication/domain/entities/auth_user.dart';
import 'package:movie_app/features/authentication/presentation/providers/auth_controller.dart';

/// In-memory auth controller so auth screens can render without Firebase.
class FakeAuthController implements AuthController {
  FakeAuthController({this.user});

  final AuthUser? user;

  @override
  Stream<AuthUser?> authStateChanges() => Stream<AuthUser?>.value(user);

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async => _user(email: email);

  @override
  Future<AuthUser> loginWithGoogle() async => _user();

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) async => AuthUser(
    uid: 'fake-uid',
    email: email,
    name: name,
    phone: phone,
    avatarIndex: avatarIndex,
  );

  AuthUser _user({String email = 'qa@example.com'}) =>
      user ?? AuthUser(uid: 'fake-uid', email: email, name: 'QA User');
}
