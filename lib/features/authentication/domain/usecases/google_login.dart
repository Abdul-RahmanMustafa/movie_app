import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class GoogleLogin {
  const GoogleLogin(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call() => _repository.signInWithGoogle();
}
