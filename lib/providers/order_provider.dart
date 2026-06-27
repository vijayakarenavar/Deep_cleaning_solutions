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

  const OrderState({
    this.isLoading     = false,
    this.orders        = const [],
    this.selectedOrder,
    this.timeSlots     = const {},
    this.redirectUrl,
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    List<dynamic>? orders,
    Map<String, dynamic>? selectedOrder,
    Map<String, dynamic>? timeSlots,
    String? redirectUrl,
    String? error,
  }) {
    return OrderState(
      isLoading:     isLoading     ?? this.isLoading,
      orders:        orders        ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      timeSlots:     timeSlots     ?? this.timeSlots,
      redirectUrl:   redirectUrl   ?? this.redirectUrl,
      error:         error         ?? this.error,
    );
  }
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
  // ✅ FIX: serviceType parameter काढला — API ला फक्त date लागतो
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

  // ── Process Order (Full Payment) ───────────────────────────────────
  // ✅ FIX: सर्व required fields — first_name, last_name, email, country, mobile, booking_date, booking_time
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
  // ✅ FIX: same complete body
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
