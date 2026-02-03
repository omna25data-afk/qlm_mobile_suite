import 'package:qlm_mobile_suite/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
