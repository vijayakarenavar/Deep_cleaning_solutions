// lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  // ── Register ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/register',
      data: {
        'name':     name,
        'email':    email,
        'mobile':   mobile,
        'password': password,
      },
    );
    return response.data;
  }

  // ── Login ─────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/login',
      data: {
        'email':    email,
        'password': password,
      },
    );

    // Token save करा
    if (response.data['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.data['token']);
    }

    return response.data;
  }

  // ── Logout ────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _api.post('/auth/logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ── Get Profile ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _api.get('/auth/profile');
    return response.data;
  }

  // ── Update Profile ────────────────────────────────────────────────
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String mobile,
  }) async {
    final response = await _api.put(
      '/auth/profile',
      data: {
        'name':   name,
        'email':  email,
        'mobile': mobile,
      },
    );
    return response.data;
  }

  // ── Change Password ───────────────────────────────────────────────
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _api.put(
      '/auth/password',
      data: {
        'current_password': currentPassword,
        'new_password':     newPassword,
      },
    );
    return response.data;
  }

  // ── Forgot Password ───────────────────────────────────────────────
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await _api.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
    return response.data;
  }

  // ── Reset Password ────────────────────────────────────────────────
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _api.post(
      '/auth/reset-password',
      data: {
        'token':        token,
        'new_password': newPassword,
      },
    );
    return response.data;
  }

  // ── Check Login Status ────────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }

  // ── Get Saved Token ───────────────────────────────────────────────
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}