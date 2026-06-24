// lib/services/contact_service.dart

import 'api_client.dart';

class ContactService {
  final ApiClient _api = ApiClient();

  // ── Send Message ──────────────────────────────────────────────────
  Future<Map<String, dynamic>> sendMessage({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    final response = await _api.post(
      '/contact',
      data: {
        'name':    name,
        'email':   email,
        'phone':   phone,
        'message': message,
      },
    );
    return response.data;
  }

  // ── Get Contact Info ──────────────────────────────────────────────
  Future<Map<String, dynamic>> getContactInfo() async {
    final response = await _api.get('/contact');
    return response.data;
  }
}