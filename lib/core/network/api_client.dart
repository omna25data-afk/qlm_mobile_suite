import 'package:dio/dio.dart';
import 'package:qlm_mobile_suite/core/constants/app_constants.dart';
import 'package:qlm_mobile_suite/core/services/token_service.dart';

class ApiClient {
  final TokenService _tokenService;
  late Dio dio;

  ApiClient(this._tokenService) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add Interceptors for Auth and Logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['X-Auth-Token'] = token; // Hostinger fix
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Global Error Handling
          return handler.next(e);
        },
      ),
    );
  }
}
