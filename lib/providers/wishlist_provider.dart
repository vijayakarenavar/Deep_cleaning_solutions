// lib/providers/wishlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/wishlist_service.dart';

// ── Wishlist State ────────────────────────────────────────────────────
class WishlistState {
  final bool isLoading;
  final List<dynamic> wishlistItems;
  final int wishlistCount;
  final String? error;

  const WishlistState({
    this.isLoading     = false,
    this.wishlistItems = const [],
    this.wishlistCount = 0,
    this.error,
  });

  WishlistState copyWith({
    bool? isLoading,
    List<dynamic>? wishlistItems,
    int? wishlistCount,
    String? error,
  }) {
    return WishlistState(
      isLoading:     isLoading     ?? this.isLoading,
      wishlistItems: wishlistItems ?? this.wishlistItems,
      wishlistCount: wishlistCount ?? this.wishlistCount,
      error:         error         ?? this.error,
    );
  }
}

// ── Wishlist Notifier ─────────────────────────────────────────────────
class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistService _wishlistService = WishlistService();

  WishlistNotifier() : super(const WishlistState()) {
    getWishlist();
  }

  // ── Get Wishlist ───────────────────────────────────────────────────
  Future<void> getWishlist() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _wishlistService.getWishlist();
      final items = response['wishlist'] ?? [];
      state = state.copyWith(
        isLoading:     false,
        wishlistItems: items,
        wishlistCount: items.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Add to Wishlist ────────────────────────────────────────────────
  Future<bool> addToWishlist(int productId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _wishlistService.addToWishlist(productId);
      await getWishlist();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Remove from Wishlist ───────────────────────────────────────────
  Future<bool> removeFromWishlist(int productId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _wishlistService.removeFromWishlist(productId);
      await getWishlist();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Toggle Wishlist ────────────────────────────────────────────────
  Future<bool> toggleWishlist(int productId) async {
    final isInWishlist = state.wishlistItems
        .any((item) => item['product_id'] == productId);
    if (isInWishlist) {
      return await removeFromWishlist(productId);
    } else {
      return await addToWishlist(productId);
    }
  }

  // ── Clear Wishlist ─────────────────────────────────────────────────
  Future<bool> clearWishlist() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _wishlistService.clearWishlist();
      state = const WishlistState();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // ── Check Wishlist ─────────────────────────────────────────────────
  bool isInWishlist(int productId) {
    return state.wishlistItems
        .any((item) => item['product_id'] == productId);
  }

  // ── Clear Error ────────────────────────────────────────────────────
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ── Provider ──────────────────────────────────────────────────────────
final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>(
      (ref) => WishlistNotifier(),
);

// ── Wishlist Count Provider ───────────────────────────────────────────
final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).wishlistCount;
});

// ── Is In Wishlist Provider ───────────────────────────────────────────
final isInWishlistProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(wishlistProvider.notifier).isInWishlist(productId);
});