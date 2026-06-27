// lib/providers/cart_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cart_service.dart';

class CartState {
  final bool isLoading;
  final List<dynamic> cartItems;
  final int cartCount;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final String? couponCode;
  final String? error;

  const CartState({
    this.isLoading      = false,
    this.cartItems      = const [],
    this.cartCount      = 0,
    this.totalAmount    = 0.0,
    this.discountAmount = 0.0,
    this.finalAmount    = 0.0,
    this.couponCode,
    this.error,
  });

  CartState copyWith({
    bool? isLoading,
    List<dynamic>? cartItems,
    int? cartCount,
    double? totalAmount,
    double? discountAmount,
    double? finalAmount,
    String? couponCode,
    String? error,
  }) {
    return CartState(
      isLoading:      isLoading      ?? this.isLoading,
      cartItems:      cartItems      ?? this.cartItems,
      cartCount:      cartCount      ?? this.cartCount,
      totalAmount:    totalAmount    ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      finalAmount:    finalAmount    ?? this.finalAmount,
      couponCode:     couponCode     ?? this.couponCode,
      error:          error          ?? this.error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartService _cartService = CartService();

  CartNotifier() : super(const CartState()) {
    getCart();
  }

  Future<void> getCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _cartService.getCart();
      state = state.copyWith(
        isLoading:      false,
        cartItems:      response['cart_items']     ?? [],
        cartCount:      response['cart_count']     ?? 0,
        totalAmount:    (response['total_amount']  ?? 0.0).toDouble(),
        discountAmount: (response['discount']      ?? 0.0).toDouble(),
        finalAmount:    (response['final_amount']  ?? 0.0).toDouble(),
        couponCode:     response['coupon_code'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ✅ FIX: quantity param काढला — service मध्ये नाही
  Future<bool> addToCart({
    required int productId,
    Map<String, dynamic>? extras,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.addToCart(
        productId: productId,
        extras:    extras,
      );
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ✅ FIX: params आता service शी match होतात
  Future<bool> addFlatToCart({
    required int mainProductId,
    required double sqft,
    required List<Map<String, dynamic>> addons,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.addFlatToCart(
        mainProductId: mainProductId,
        sqft:          sqft,
        addons:        addons,
      );
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ✅ FIX: cartItemId → rowId, quantity → qty
  Future<bool> updateCartItem({
    required String rowId,
    required int qty,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.updateCartItem(
        rowId: rowId,
        qty:   qty,
      );
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ✅ OK — rowId string आहे, service शी match
  Future<bool> removeCartItem(String rowId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.removeCartItem(rowId);
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> clearCart() async {
    state = const CartState();
    return true;
  }

  Future<bool> applyCoupon(String couponCode) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.applyCoupon(couponCode);
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> removeCoupon() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.removeCoupon();
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
      (ref) => CartNotifier(),
);

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).cartCount;
});