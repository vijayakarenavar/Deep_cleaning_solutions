// lib/providers/cart_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cart_service.dart';

// ── Cart State ────────────────────────────────────────────────────────
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

// ── Cart Notifier ─────────────────────────────────────────────────────
class CartNotifier extends StateNotifier<CartState> {
  final CartService _cartService = CartService();

  CartNotifier() : super(const CartState()) {
    getCart();
  }

  // ── Get Cart ───────────────────────────────────────────────────────
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

  // ── Add to Cart ────────────────────────────────────────────────────
  Future<bool> addToCart({
    required int productId,
    required int quantity,
    Map<String, dynamic>? extras,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.addToCart(
        productId: productId,
        quantity:  quantity,
        extras:    extras,
      );
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Add Flat to Cart ───────────────────────────────────────────────
  Future<bool> addFlatToCart({
    required int productId,
    required String bhkType,
    required String flatType,
    required double sqft,
    bool cleanWalls  = false,
    bool cleanPaint  = false,
    bool removeCover = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.addFlatToCart(
        productId:   productId,
        bhkType:     bhkType,
        flatType:    flatType,
        sqft:        sqft,
        cleanWalls:  cleanWalls,
        cleanPaint:  cleanPaint,
        removeCover: removeCover,
      );
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Update Cart Item ───────────────────────────────────────────────
  Future<bool> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.updateCartItem(
        cartItemId: cartItemId,
        quantity:   quantity,
      );
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Remove Cart Item ───────────────────────────────────────────────
  Future<bool> removeCartItem(int cartItemId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.removeCartItem(cartItemId);
      await getCart();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Clear Cart ─────────────────────────────────────────────────────
  Future<bool> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cartService.clearCart();
      state = const CartState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Apply Coupon ───────────────────────────────────────────────────
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

  // ── Remove Coupon ──────────────────────────────────────────────────
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

  // ── Clear Error ────────────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ── Provider ──────────────────────────────────────────────────────────
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
      (ref) => CartNotifier(),
);

// ── Cart Count Provider ───────────────────────────────────────────────
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).cartCount;
});