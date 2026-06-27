// lib/services/cart_service.dart

import 'api_client.dart';

class CartService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> getCart() async {
    final response = await _api.get('/cart');
    final data = response.data['data'] ?? {};
    return {
      'cart_items':   data['items']    ?? [],
      'cart_count':   data['count']    ?? 0,
      'total_amount': double.tryParse(data['subtotal']?.toString() ?? '0') ?? 0.0,
      'discount':     double.tryParse(data['discount']?.toString() ?? '0') ?? 0.0,
      'final_amount': double.tryParse(data['final_amount']?.toString() ?? data['subtotal']?.toString() ?? '0') ?? 0.0,
      'coupon_code':  data['coupon_code'],
    };
  }

  // ✅ FIX: product_id → id (API ला 'id' लागतो)
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    Map<String, dynamic>? extras,
  }) async {
    final response = await _api.post(
      '/cart/add',
      data: {
        'id': productId,
        if (extras != null) ...extras,
      },
    );
    return response.data;
  }

  // ✅ FIX: product_id → id, units + unit_type API (cart/add-with-unit)
  Future<Map<String, dynamic>> addToCartWithUnit({
    required int productId,
    required int units,
    required String unitType,
  }) async {
    final response = await _api.post(
      '/cart/add-with-unit',
      data: {
        'id':        productId,
        'units':     units,
        'unit_type': unitType,
      },
    );
    return response.data;
  }

  // ✅ FIX: API body → main_product_id, sqft, addons array
  Future<Map<String, dynamic>> addFlatToCart({
    required int mainProductId,
    required double sqft,
    required List<Map<String, dynamic>> addons,
  }) async {
    final response = await _api.post(
      '/cart/add-flat',
      data: {
        'main_product_id': mainProductId,
        'sqft':            sqft,
        'addons':          addons,
      },
    );
    return response.data;
  }

  // ✅ FIX: row_id → rowId, quantity → qty
  Future<Map<String, dynamic>> updateCartItem({
    required String rowId,
    required int qty,
  }) async {
    final response = await _api.put(
      '/cart/update',
      data: {
        'rowId': rowId,
        'qty':   qty,
      },
    );
    return response.data;
  }

  // ✅ FIX: row_id → rowId
  Future<Map<String, dynamic>> removeCartItem(String rowId) async {
    final response = await _api.delete(
      '/cart/item',
      data: {'rowId': rowId},
    );
    return response.data;
  }

  // ✅ FIX: coupon_code → code
  Future<Map<String, dynamic>> applyCoupon(String couponCode) async {
    final response = await _api.post(
      '/checkout/apply-coupon',
      data: {'code': couponCode},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> removeCoupon() async {
    final response = await _api.post('/checkout/remove-coupon', data: {});
    return response.data;
  }

  // ✅ FIX: product_id → id
  Future<Map<String, dynamic>> getCartRowId({
    required int productId,
  }) async {
    final response = await _api.post(
      '/cart/row-id',
      data: {'id': productId},
    );
    return response.data;
  }
}
