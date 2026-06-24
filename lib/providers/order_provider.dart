// lib/providers/order_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/order_service.dart';

// ── Order State ───────────────────────────────────────────────────────
class OrderState {
  final bool isLoading;
  final List<dynamic> orders;
  final Map<String, dynamic>? selectedOrder;
  final List<dynamic> timeSlots;
  final String? error;

  const OrderState({
    this.isLoading     = false,
    this.orders        = const [],
    this.selectedOrder,
    this.timeSlots     = const [],
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    List<dynamic>? orders,
    Map<String, dynamic>? selectedOrder,
    List<dynamic>? timeSlots,
    String? error,
  }) {
    return OrderState(
      isLoading:     isLoading     ?? this.isLoading,
      orders:        orders        ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      timeSlots:     timeSlots     ?? this.timeSlots,
      error:         error         ?? this.error,
    );
  }
}

// ── Order Notifier ────────────────────────────────────────────────────
class OrderNotifier extends StateNotifier<OrderState> {
  final OrderService _orderService = OrderService();

  OrderNotifier() : super(const OrderState());

  // ── Get All Orders ─────────────────────────────────────────────────
  Future<void> getOrders({
    String? status,
    int page = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.getOrders(
        status: status,
        page:   page,
      );
      state = state.copyWith(
        isLoading: false,
        orders:    response['orders'] ?? [],
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
        selectedOrder: response['order'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Place Order ────────────────────────────────────────────────────
  Future<bool> placeOrder({
    required String address,
    required String city,
    required String state_,
    required String date,
    required String time,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.placeOrder(
        address: address,
        city:    city,
        state:   state_,
        date:    date,
        time:    time,
        notes:   notes,
      );
      state = state.copyWith(
        isLoading:     false,
        selectedOrder: response['order'],
      );
      await getOrders();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Cancel Order ───────────────────────────────────────────────────
  Future<bool> cancelOrder(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _orderService.cancelOrder(orderId);
      await getOrders();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Get Time Slots ─────────────────────────────────────────────────
  Future<void> getTimeSlots({
    required String date,
    required String serviceType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _orderService.getTimeSlots(
        date:        date,
        serviceType: serviceType,
      );
      state = state.copyWith(
        isLoading: false,
        timeSlots: response['time_slots'] ?? [],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Checkout Init ──────────────────────────────────────────────────
  Future<bool> checkoutInit({
    required String address,
    required String city,
    required String state_,
    required String date,
    required String time,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _orderService.checkoutInit(
        address: address,
        city:    city,
        state:   state_,
        date:    date,
        time:    time,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Process Payment ────────────────────────────────────────────────
  Future<bool> processPayment({
    required int orderId,
    required String paymentMethod,
    required double amount,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _orderService.processPayment(
        orderId:       orderId,
        paymentMethod: paymentMethod,
        amount:        amount,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Verify Payment ─────────────────────────────────────────────────
  Future<bool> verifyPayment({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _orderService.verifyPayment(
        paymentId: paymentId,
        orderId:   orderId,
        signature: signature,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Clear Error ────────────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(error: null);
  }

  // ── Clear Selected Order ───────────────────────────────────────────
  void clearSelectedOrder() {
    state = state.copyWith(selectedOrder: null);
  }
}

// ── Provider ──────────────────────────────────────────────────────────
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
      (ref) => OrderNotifier(),
);