// lib/providers/wishlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/wishlist_service.dart';
import 'auth_provider.dart';

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

class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistService _wishlistService = WishlistService();
  final Ref _ref;

  WishlistNotifier(this._ref) : super(const WishlistState());

  // ✅ Login check helper
  bool _isLoggedIn() => _ref.read(authProvider).isLoggedIn;

  // ── Get Wishlist ───────────────────────────────────────────────────
  Future<void> getWishlist() async {
    // ✅ Guest असेल तर wishlist fetch नको
    if (!_isLoggedIn()) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _wishlistService.getWishlist();
      final items = response['items'] ?? [];
      state = state.copyWith(
        isLoading:     false,
        wishlistItems: items,
        wishlistCount: response['count'] ?? items.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Add to Wishlist ────────────────────────────────────────────────
  // ✅ Guest असेल तर 'login_required' return करा
  Future<String> addToWishlist(int productId) async {
    if (!_isLoggedIn()) return 'login_required';

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _wishlistService.addToWishlist(productId);
      await getWishlist();
      return 'success';
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return 'error';
    }
  }

  // ── Remove from Wishlist ───────────────────────────────────────────
  Future<bool> removeFromWishlist(int productId) async {
    if (!_isLoggedIn()) return false;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _wishlistService.removeFromWishlist(productId);
      await getWishlist();
      return true;
    } catch (e) {
      // Backend bug — local state मधून remove
      final updated = state.wishlistItems
          .where((item) => item['id'] != productId)
          .toList();
      state = state.copyWith(
        isLoading:     false,
        wishlistItems: updated,
        wishlistCount: updated.length,
        error:         null,
      );
      return true;
    }
  }

  // ── Toggle Wishlist ────────────────────────────────────────────────
  // ✅ 'login_required', 'success', 'error' return करतो
  Future<String> toggleWishlist(int productId) async {
    if (!_isLoggedIn()) return 'login_required';

    final inWishlist = state.wishlistItems
        .any((item) => item['id'] == productId);
    if (inWishlist) {
      final success = await removeFromWishlist(productId);
      return success ? 'removed' : 'error';
    } else {
      return await addToWishlist(productId);
    }
  }

  // ── Clear Wishlist ─────────────────────────────────────────────────
  Future<bool> clearWishlist() async {
    state = const WishlistState();
    return true;
  }

  // ── Check Wishlist ─────────────────────────────────────────────────
  bool isInWishlist(int productId) {
    if (!_isLoggedIn()) return false;
    return state.wishlistItems
        .any((item) => item['id'] == productId);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>(
      (ref) => WishlistNotifier(ref),
);

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).wishlistCount;
});

final isInWishlistProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(wishlistProvider.notifier).isInWishlist(productId);
});