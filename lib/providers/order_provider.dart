// lib/providers/order_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/order_service.dart';

class OrderState {
  final bool isLoading;
  final List<dynamic> orders;
  final Map<String, dynamic>? selectedOrder;
  final Map<String, dynamic> timeSlots;
  final String? redirectUrl;
  final String? error;

  // Checkout area + summary state
  final List<Map<String, dynamic>> cityAreas;
  final int? selectedAreaId;
  final double shippingCharge;
  final double subtotal;
  final double discount;
  final String? couponCode;
  final double grandTotal;
  final bool isInitLoading;
  final bool isCouponLoading;
  final String? couponError;

  // ✅ NEW: area suggested from the customer's saved address (country_id),
  // returned by /checkout/init. This is a HINT for the UI dropdown only —
  // it must never be auto-applied to shipping/grandTotal. The user has to
  // actually pick an area before any charge is calculated.
  final int? suggestedAreaId;

  const OrderState({
    this.isLoading     = false,
    this.orders        = const [],
    this.selectedOrder,
    this.timeSlots     = const {},
    this.redirectUrl,
    this.error,
    this.cityAreas       = const [],
    this.selectedAreaId,
    this.shippingCharge  = 0,
    this.subtotal        = 0,
    this.discount        = 0,
    this.couponCode,
    this.grandTotal       = 0,
    this.isInitLoading    = false,
    this.isCouponLoading  = false,
    this.couponError,
    this.suggestedAreaId,
  });

  OrderState copyWith({
    bool? isLoading,
    List<dynamic>? orders,
    Map<String, dynamic>? selectedOrder,
    Map<String, dynamic>? timeSlots,
    String? redirectUrl,
    String? error,
    List<Map<String, dynamic>>? cityAreas,
    int? selectedAreaId,
    double? shippingCharge,
    double? subtotal,
    double? discount,
    String? couponCode,
    double? grandTotal,
    bool? isInitLoading,
    bool? isCouponLoading,
    String? couponError,
    int? suggestedAreaId,
  }) {
    return OrderState(
      isLoading:     isLoading     ?? this.isLoading,
      orders:        orders        ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      timeSlots:     timeSlots     ?? this.timeSlots,
      redirectUrl:   redirectUrl   ?? this.redirectUrl,
      error:         error         ?? this.error,
      cityAreas:      cityAreas      ?? this.cityAreas,
      selectedAreaId: selectedAreaId ?? this.selectedAreaId,
      shippingCharge: shippingCharge ?? this.shippingCharge,
      subtotal:       subtotal       ?? this.subtotal,
      discount:       discount       ?? this.discount,
      couponCode:     couponCode     ?? this.couponCode,
      grandTotal:     grandTotal     ?? this.grandTotal,
      isInitLoading:   isInitLoading   ?? this.isInitLoading,
      isCouponLoading: isCouponLoading ?? this.isCouponLoading,
      couponError:     couponError     ?? this.couponError,
      suggestedAreaId: suggestedAreaId ?? this.suggestedAreaId,
    );
  }
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderService _orderService = OrderService();
  OrderNotifier() : super(const OrderState());

  // ── Get All Orders ─────────────────────────────────────────────────
  Future<void> getOrders({String? status, int page = 1}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.getOrders(status: status, page: page);
      state = state.copyWith(
        isLoading: false,
        orders:    (response['data']?['orders']) ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Order Detail ───────────────────────────────────────────────
  Future<void> getOrderDetail(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.getOrderDetail(orderId);
      state = state.copyWith(
        isLoading:     false,
        selectedOrder: response['data'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Get Payment Status ─────────────────────────────────────────────
  Future<Map<String, dynamic>?> getPaymentStatus(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.getPaymentStatus(orderId);
      state = state.copyWith(isLoading: false);
      return response['data'];
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  // ── Get Time Slots ─────────────────────────────────────────────────
  Future<void> getTimeSlots({required String date}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.getTimeSlots(date: date);
      final slots = response['data']?['time_slots'];
      state = state.copyWith(
        isLoading: false,
        timeSlots: slots is Map<String, dynamic> ? slots : {},
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Checkout Init (area list + prefilled subtotal) ──────────────────
  // ✅ FIX: previously this auto-called selectArea(preselected) using the
  // customer's saved-address country_id, which silently applied that
  // area's shipping charge to the summary/grandTotal before the user ever
  // touched the area dropdown (e.g. Baner ₹425 showing with nothing
  // selected on screen). We now only STORE the suggestion in
  // `suggestedAreaId` so the UI can pre-highlight it if it wants to, but
  // we never call selectArea() here. Shipping/discount/grandTotal stay at
  // 0 until the user explicitly picks an area.
  Future<void> getCheckoutInit() async {
    state = state.copyWith(isInitLoading: true, error: null);
    try {
      final response = await _orderService.checkoutInit();
      final data = response['data'] ?? {};

      final areas = (data['city_areas'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      int? preselected;
      final custAddr = data['customer_address'];
      if (custAddr != null && custAddr['country_id'] != null) {
        final raw = custAddr['country_id'];
        preselected = raw is int ? raw : int.tryParse(raw.toString());
      }

      state = state.copyWith(
        isInitLoading:   false,
        cityAreas:       areas,
        subtotal:        _toDouble(data['subtotal']),
        suggestedAreaId: preselected,
      );

      // ❌ REMOVED: no longer auto-applying the saved address's area.
      // if (preselected != null) {
      //   await selectArea(preselected);
      // }
    } catch (e) {
      state = state.copyWith(isInitLoading: false, error: e.toString());
    }
  }

  // ── User picks an area → fetch live shipping/discount/total ─────────
  Future<void> selectArea(int areaId) async {
    state = state.copyWith(selectedAreaId: areaId, isInitLoading: true);
    try {
      final response = await _orderService.checkoutSummary(countryId: areaId);
      _applySummary(response['data'] ?? {});
    } catch (e) {
      state = state.copyWith(isInitLoading: false, error: e.toString());
    }
  }

  // ── Apply Coupon ─────────────────────────────────────────────────
  Future<bool> applyCoupon(String code) async {
    state = OrderState(
      isLoading: state.isLoading, orders: state.orders, selectedOrder: state.selectedOrder,
      timeSlots: state.timeSlots, redirectUrl: state.redirectUrl, error: state.error,
      cityAreas: state.cityAreas, selectedAreaId: state.selectedAreaId,
      shippingCharge: state.shippingCharge, subtotal: state.subtotal, discount: state.discount,
      couponCode: state.couponCode, grandTotal: state.grandTotal,
      isInitLoading: state.isInitLoading, isCouponLoading: true, couponError: null,
      suggestedAreaId: state.suggestedAreaId,
    );
    try {
      final response = await _orderService.applyCoupon(code: code);
      _applySummary(response['data'] ?? {}, couponLoadingDone: true);
      return true;
    } catch (e) {
      state = OrderState(
        isLoading: state.isLoading, orders: state.orders, selectedOrder: state.selectedOrder,
        timeSlots: state.timeSlots, redirectUrl: state.redirectUrl, error: state.error,
        cityAreas: state.cityAreas, selectedAreaId: state.selectedAreaId,
        shippingCharge: state.shippingCharge, subtotal: state.subtotal, discount: state.discount,
        couponCode: state.couponCode, grandTotal: state.grandTotal,
        isInitLoading: state.isInitLoading, isCouponLoading: false,
        couponError: 'Invalid or expired coupon code',
        suggestedAreaId: state.suggestedAreaId,
      );
      return false;
    }
  }

  // ── Remove Coupon ────────────────────────────────────────────────
  Future<void> removeCoupon() async {
    state = state.copyWith(isCouponLoading: true);
    try {
      final response = await _orderService.removeCoupon();
      _applySummary(response['data'] ?? {}, couponLoadingDone: true);
    } catch (e) {
      state = state.copyWith(isCouponLoading: false, error: e.toString());
    }
  }

  // ── shared helper: apply a /checkout/summary-shaped response ────────
  void _applySummary(Map<String, dynamic> data, {bool couponLoadingDone = false}) {
    state = OrderState(
      isLoading: state.isLoading, orders: state.orders, selectedOrder: state.selectedOrder,
      timeSlots: state.timeSlots, redirectUrl: state.redirectUrl, error: null,
      cityAreas: state.cityAreas, selectedAreaId: state.selectedAreaId,
      shippingCharge: _toDouble(data['shipping_charge']),
      subtotal:       _toDouble(data['subtotal']),
      discount:       _toDouble(data['discount']),
      couponCode:     data['coupon_code']?.toString(),
      grandTotal:     _toDouble(data['grand_total']),
      isInitLoading:   false,
      isCouponLoading: couponLoadingDone ? false : state.isCouponLoading,
      couponError:     null,
      suggestedAreaId: state.suggestedAreaId,
    );
  }

  // ── Process Order (Full Payment) ───────────────────────────────────
  // ✅ orderNotes added (optional)
  Future<bool> processOrder({
    required String firstName,
    required String lastName,
    required String email,
    required int country,
    required String address,
    required String city,
    required String state_,
    required String zip,
    required String mobile,
    required String bookingDate,
    required String bookingTime,
    String? orderNotes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.processOrder(
        firstName:   firstName,
        lastName:    lastName,
        email:       email,
        country:     country,
        address:     address,
        city:        city,
        state:       state_,
        zip:         zip,
        mobile:      mobile,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        orderNotes:  orderNotes,
      );
      final data = response['data'];
      state = state.copyWith(
        isLoading:    false,
        selectedOrder: data,
        redirectUrl:  data?['redirect_url'],
      );
      await getOrders();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Process Advance Order (Advance Payment) ────────────────────────
  // ✅ orderNotes added (optional)
  Future<bool> processAdvanceOrder({
    required String firstName,
    required String lastName,
    required String email,
    required int country,
    required String address,
    required String city,
    required String state_,
    required String zip,
    required String mobile,
    required String bookingDate,
    required String bookingTime,
    String? orderNotes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.processAdvanceOrder(
        firstName:   firstName,
        lastName:    lastName,
        email:       email,
        country:     country,
        address:     address,
        city:        city,
        state:       state_,
        zip:         zip,
        mobile:      mobile,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        orderNotes:  orderNotes,
      );
      final data = response['data'];
      state = state.copyWith(
        isLoading:     false,
        selectedOrder: data,
        redirectUrl:   data?['redirect_url'],
      );
      await getOrders();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void addOrder(Map<String, dynamic> order) {
    final updated = [...state.orders];
    updated.insert(0, order);
    state = state.copyWith(orders: updated);
  }

  void clearSelectedOrder() => state = state.copyWith(selectedOrder: null);
  void clearRedirectUrl()   => state = state.copyWith(redirectUrl: null);
  void clearError()         => state = state.copyWith(error: null);
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
      (ref) => OrderNotifier(),
);