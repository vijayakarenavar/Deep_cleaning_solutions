import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;

  // ✅ 401 वर callback — main.dart मधून set करा
  static void Function()? onUnauthorized;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000')),
        receiveTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000')),
        headers: {
          'Content-Type': 'application/json',
          'Accept':       'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          if (token != null) {
            // ✅ Logged in — Bearer token
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            // ✅ Guest — proper UUID v4
            final guestId = prefs.getString('guest_id')
                ?? await _createGuestId(prefs);
            options.headers['X-Guest-Id'] = guestId;
          }
          return handler.next(options);
        },

        onResponse: (response, handler) {
          return handler.next(response);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // ✅ Token invalid — clear + login redirect
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
            onUnauthorized?.call();
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ✅ Proper UUID v4
  Future<String> _createGuestId(SharedPreferences prefs) async {
    final id = const Uuid().v4();
    await prefs.setString('guest_id', id);
    return id;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.delete(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message    = e.response?.data?['message'] ?? 'Something went wrong.';
        if (statusCode == 400) return 'Bad request: $message';
        if (statusCode == 401) return 'Unauthorized. Please login again.';
        if (statusCode == 403) return 'Access denied.';
        if (statusCode == 404) return 'Not found.';
        if (statusCode == 500) return 'Server error. Please try again later.';
        return message;
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}