import 'package:qlm_mobile_suite/features/auth/domain/entities/user_entity.dart';
import 'package:qlm_mobile_suite/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(String email, String password) {
    return _repository.login(email, password);
  }
}
