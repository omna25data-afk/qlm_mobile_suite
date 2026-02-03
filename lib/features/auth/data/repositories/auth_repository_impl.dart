import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/token_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._apiClient, this._tokenService);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      final token = data['token'];
      final userModel = UserModel.fromJson(data['user']);

      // Save session info
      await _tokenService.saveToken(token);
      await _tokenService.saveRole(userModel.role);

      return userModel;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/logout');
    } finally {
      await _tokenService.clearAll();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    // Implement as needed, e.g., fetch from profile endpoint or local cache
    return null;
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Invalid credentials');
    }
    return Exception(e.message ?? 'Unknown error occurred');
  }
}
