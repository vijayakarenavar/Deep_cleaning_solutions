// lib/services/order_service.dart

import 'api_client.dart';

class OrderService {
  final ApiClient _api = ApiClient();

  // ── Get All Orders ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getOrders({
    String? status,
    int page = 1,
  }) async {
    final response = await _api.get(
      '/orders',
      queryParams: {
        if (status != null) 'status': status,
        'page': page,
      },
    );
    return response.data;
  }

  // ── Get Order Detail ──────────────────────────────────────────────
  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    final response = await _api.get('/orders/$orderId');
    return response.data;
  }

  // ── Place Order ───────────────────────────────────────────────────
  Future<Map<String, dynamic>> placeOrder({
    required String address,
    required String city,
    required String state,
    required String date,
    required String time,
    String? notes,
  }) async {
    final response = await _api.post(
      '/orders/place',
      data: {
        'address': address,
        'city':    city,
        'state':   state,
        'date':    date,
        'time':    time,
        if (notes != null) 'notes': notes,
      },
    );
    return response.data;
  }

  // ── Cancel Order ──────────────────────────────────────────────────
  Future<Map<String, dynamic>> cancelOrder(int orderId) async {
    final response = await _api.put('/orders/$orderId/cancel');
    return response.data;
  }

  // ── Get Order Status ──────────────────────────────────────────────
  Future<Map<String, dynamic>> getOrderStatus(int orderId) async {
    final response = await _api.get('/orders/$orderId/status');
    return response.data;
  }

  // ── Get Time Slots ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getTimeSlots({
    required String date,
    required String serviceType,
  }) async {
    final response = await _api.get(
      '/checkout/time-slots',
      queryParams: {
        'date':         date,
        'service_type': serviceType,
      },
    );
    return response.data;
  }

  // ── Checkout Init ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> checkoutInit({
    required String address,
    required String city,
    required String state,
    required String date,
    required String time,
  }) async {
    final response = await _api.post(
      '/checkout/init',
      data: {
        'address': address,
        'city':    city,
        'state':   state,
        'date':    date,
        'time':    time,
      },
    );
    return response.data;
  }

  // ── Process Payment ───────────────────────────────────────────────
  Future<Map<String, dynamic>> processPayment({
    required int orderId,
    required String paymentMethod,
    required double amount,
  }) async {
    final response = await _api.post(
      '/checkout/process',
      data: {
        'order_id':       orderId,
        'payment_method': paymentMethod,
        'amount':         amount,
      },
    );
    return response.data;
  }

  // ── Verify Payment ────────────────────────────────────────────────
  Future<Map<String, dynamic>> verifyPayment({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    final response = await _api.post(
      '/checkout/verify',
      data: {
        'payment_id': paymentId,
        'order_id':   orderId,
        'signature':  signature,
      },
    );
    return response.data;
  }
}