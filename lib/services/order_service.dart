// lib/services/order_service.dart

import 'api_client.dart';

class OrderService {
  final ApiClient _api = ApiClient();

  // ✅ GET /orders
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

  // ✅ GET /orders/{orderId}
  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    final response = await _api.get('/orders/$orderId');
    return response.data;
  }

  // ✅ GET /orders/{orderId}/payment-status
  Future<Map<String, dynamic>> getPaymentStatus(int orderId) async {
    final response = await _api.get('/orders/$orderId/payment-status');
    return response.data;
  }

  // ✅ GET /checkout/init
  Future<Map<String, dynamic>> checkoutInit() async {
    final response = await _api.get('/checkout/init');
    return response.data;
  }

  Future<Map<String, dynamic>> getTimeSlots({
    required String date,
  }) async {
    final response = await _api.post(
      '/checkout/time-slots',
      data: {
        'date': date,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> checkoutSummary({
    required int countryId,
  }) async {
    final response = await _api.post(
      '/checkout/summary',
      data: {
        'country_id': countryId,
      },
    );
    return response.data;
  }

  // ✅ POST /checkout/apply-coupon
  Future<Map<String, dynamic>> applyCoupon({required String code}) async {
    final response = await _api.post(
      '/checkout/apply-coupon',
      data: {
        'code': code,
      },
    );
    return response.data;
  }

  // ✅ POST /checkout/remove-coupon
  Future<Map<String, dynamic>> removeCoupon() async {
    final response = await _api.post(
      '/checkout/remove-coupon',
      data: {},
    );
    return response.data;
  }

  // ── Process Order (Full Payment) ───────────────────────────────────
  Future<Map<String, dynamic>> processOrder({
    required String firstName,
    required String lastName,
    required String email,
    required int country,
    String? apartment, // ✅ NEW: matches website's Flat/Bungalow No. + Wing
    required String address,
    required String city,
    required String state,
    required String zip,
    required String mobile,
    required String bookingDate,
    required String bookingTime,
    String? orderNotes,
  }) async {
    final response = await _api.post(
      '/checkout/process',
      data: {
        'first_name':   firstName,
        'last_name':    lastName,
        'email':        email,
        'country':      country,
        if (apartment != null && apartment.isNotEmpty) 'apartment': apartment, // ✅ NEW
        'address':      address,
        'city':         city,
        'state':        state,
        'zip':          zip,
        'mobile':       mobile,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
        if (orderNotes != null && orderNotes.isNotEmpty) 'order_notes': orderNotes,
      },
    );
    return response.data;
  }

  // ── Process Advance Order (Advance Payment) ────────────────────────
  Future<Map<String, dynamic>> processAdvanceOrder({
    required String firstName,
    required String lastName,
    required String email,
    required int country,
    String? apartment, // ✅ NEW: matches website's Flat/Bungalow No. + Wing
    required String address,
    required String city,
    required String state,
    required String zip,
    required String mobile,
    required String bookingDate,
    required String bookingTime,
    String? orderNotes,
  }) async {
    final response = await _api.post(
      '/checkout/process-advance',
      data: {
        'first_name':   firstName,
        'last_name':    lastName,
        'email':        email,
        'country':      country,
        if (apartment != null && apartment.isNotEmpty) 'apartment': apartment, // ✅ NEW
        'address':      address,
        'city':         city,
        'state':        state,
        'zip':          zip,
        'mobile':       mobile,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
        if (orderNotes != null && orderNotes.isNotEmpty) 'order_notes': orderNotes,
      },
    );
    return response.data;
  }
}