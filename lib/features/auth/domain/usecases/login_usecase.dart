import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(String email, String password) {
    return _repository.login(email, password);
  }
}
