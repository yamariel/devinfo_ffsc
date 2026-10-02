import 'package:dio/dio.dart';
import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient(AuthInterceptor authInterceptor)
      : dio = Dio(
    BaseOptions(
      baseUrl: "https://dev.to/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(authInterceptor);
  }
}