// lib/services/wishlist_service.dart

import 'api_client.dart';

class WishlistService {
  final ApiClient _api = ApiClient();

  // ── Get Wishlist ──────────────────────────────────────────────────
  Future<Map<String, dynamic>> getWishlist() async {
    final response = await _api.get('/wishlist');
    return response.data;
  }

  // ── Add to Wishlist ───────────────────────────────────────────────
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    final response = await _api.post(
      '/wishlist/add',
      data: {'product_id': productId},
    );
    return response.data;
  }

  // ── Remove from Wishlist ──────────────────────────────────────────
  Future<Map<String, dynamic>> removeFromWishlist(int productId) async {
    final response = await _api.delete(
      '/wishlist/remove/$productId',
    );
    return response.data;
  }

  // ── Clear Wishlist ────────────────────────────────────────────────
  Future<Map<String, dynamic>> clearWishlist() async {
    final response = await _api.delete('/wishlist/clear');
    return response.data;
  }

  // ── Check Wishlist ────────────────────────────────────────────────
  Future<Map<String, dynamic>> checkWishlist(int productId) async {
    final response = await _api.get('/wishlist/check/$productId');
    return response.data;
  }
}