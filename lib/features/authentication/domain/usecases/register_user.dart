import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  const RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) {
    return _repository.registerWithEmail(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }
}
