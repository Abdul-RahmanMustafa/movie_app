import '../../data/datasources/firebase_auth_data_source.dart';
import '../../data/datasources/firestore_user_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/email_login.dart';
import '../../domain/usecases/google_login.dart';
import '../../domain/usecases/observe_auth_state.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/send_password_reset.dart';
import '../../domain/usecases/sign_out.dart';

class AuthController {
  AuthController._({
    required this._login,
    required this._googleLogin,
    required this._register,
    required this._observeAuthState,
    required this._sendPasswordReset,
    required this._signOut,
  });

  factory AuthController.firebase() => _shared;

  static final AuthController _shared = AuthController._build();

  static AuthController _build() {
    final repository = AuthRepositoryImpl(
      FirebaseAuthDataSourceImpl(),
      FirestoreUserDataSourceImpl(),
    );
    return AuthController._(
      login: EmailLogin(repository),
      googleLogin: GoogleLogin(repository),
      register: RegisterUser(repository),
      observeAuthState: ObserveAuthState(repository),
      sendPasswordReset: SendPasswordReset(repository),
      signOut: SignOut(repository),
    );
  }

  final EmailLogin _login;
  final GoogleLogin _googleLogin;
  final RegisterUser _register;
  final ObserveAuthState _observeAuthState;
  final SendPasswordReset _sendPasswordReset;
  final SignOut _signOut;

  Stream<AuthUser?> authStateChanges() => _observeAuthState();

  Future<AuthUser> login({required String email, required String password}) {
    return _login(email: email, password: password);
  }

  Future<AuthUser> loginWithGoogle() => _googleLogin();

  Future<void> sendPasswordResetEmail(String email) {
    return _sendPasswordReset(email);
  }

  Future<void> signOut() => _signOut();

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) {
    return _register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }
}
