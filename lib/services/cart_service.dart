// lib/services/cart_service.dart

import 'api_client.dart';

class CartService {
  final ApiClient _api = ApiClient();

  // ── Get Cart ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getCart() async {
    final response = await _api.get('/cart');
    return response.data;
  }

  // ── Add to Cart ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int quantity,
    Map<String, dynamic>? extras,
  }) async {
    final response = await _api.post(
      '/cart/add',
      data: {
        'product_id': productId,
        'quantity':   quantity,
        if (extras != null) ...extras,
      },
    );
    return response.data;
  }

  // ── Add Flat to Cart ──────────────────────────────────────────────
  Future<Map<String, dynamic>> addFlatToCart({
    required int productId,
    required String bhkType,
    required String flatType,
    required double sqft,
    bool cleanWalls   = false,
    bool cleanPaint   = false,
    bool removeCover  = false,
  }) async {
    final response = await _api.post(
      '/cart/add-flat',
      data: {
        'product_id':   productId,
        'bhk_type':     bhkType,
        'flat_type':    flatType,
        'sqft':         sqft,
        'clean_walls':  cleanWalls,
        'clean_paint':  cleanPaint,
        'remove_cover': removeCover,
      },
    );
    return response.data;
  }

  // ── Update Cart Item ──────────────────────────────────────────────
  Future<Map<String, dynamic>> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    final response = await _api.put(
      '/cart/update/$cartItemId',
      data: {'quantity': quantity},
    );
    return response.data;
  }

  // ── Remove Cart Item ──────────────────────────────────────────────
  Future<Map<String, dynamic>> removeCartItem(int cartItemId) async {
    final response = await _api.delete('/cart/remove/$cartItemId');
    return response.data;
  }

  // ── Clear Cart ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> clearCart() async {
    final response = await _api.delete('/cart/clear');
    return response.data;
  }

  // ── Apply Coupon ──────────────────────────────────────────────────
  Future<Map<String, dynamic>> applyCoupon(String couponCode) async {
    final response = await _api.post(
      '/cart/coupon',
      data: {'coupon_code': couponCode},
    );
    return response.data;
  }

  // ── Remove Coupon ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> removeCoupon() async {
    final response = await _api.delete('/cart/coupon');
    return response.data;
  }

  // ── Get Cart Count ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getCartCount() async {
    final response = await _api.get('/cart/count');
    return response.data;
  }
}