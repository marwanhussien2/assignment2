import 'package:dio/dio.dart';

/// Lightweight service for DummyJSON auth.
class AuthService {
  AuthService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://dummyjson.com',
              ),
            );

  final Dio _dio;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }

      final message = response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'Login failed with status ${response.statusCode}';
      throw Exception(message);
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : e.message ?? 'Network error';
      throw Exception(msg);
    }
  }
}

