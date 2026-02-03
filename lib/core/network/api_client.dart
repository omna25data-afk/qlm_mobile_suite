import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
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
        onRequest: (options, handler) {
          // TODO: Fetch token from secure storage and add to headers
          // options.headers['Authorization'] = 'Bearer $token';
          // options.headers['X-Auth-Token'] = token; // Hostinger fix
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
