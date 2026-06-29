// lib/screens/wishlist_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/providers/wishlist_provider.dart';
import 'package:dcs_app/providers/cart_provider.dart';
import 'package:dcs_app/widgets/app_network_image.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wishlistProvider.notifier).getWishlist());
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: wishlistState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : wishlistState.wishlistItems.isEmpty
          ? _EmptyWishlist()
          : RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(wishlistProvider.notifier).getWishlist(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: wishlistState.wishlistItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final item = wishlistState.wishlistItems[i];
            return _WishlistItemCard(
              item: item,
              onRemove: () async {
                await ref.read(wishlistProvider.notifier)
                    .removeFromWishlist(item['id']);
              },
              onAddToCart: () async {
                final success = await ref
                    .read(cartProvider.notifier)
                    .addToCart(productId: item['id']);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? '${item['title']} added to cart!'
                            : 'Failed to add to cart.',
                      ),
                      backgroundColor: success
                          ? AppColors.green
                          : AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border,
                color: AppColors.textMuted, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save services you love to your wishlist',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Explore Services'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistItemCard({
    required this.item,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final String name  = item['title'] ?? item['name'] ?? 'Service';
    final double price = (item['price'] ?? 0.0).toDouble();
    final String? image = item['image'] ?? item['thumbnail'];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image != null && image.isNotEmpty
                  ? AppNetworkImage(
                url: image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 70,
                height: 70,
                color: AppColors.surface,
                child: const Icon(Icons.cleaning_services,
                    color: AppColors.primary, size: 32),
              ),
            ),
            const SizedBox(width: 12),

            // Name + Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            Column(
              children: [
                // Remove
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.favorite,
                      color: AppColors.secondary, size: 22),
                  tooltip: 'Remove from wishlist',
                ),
                // Add to Cart
                ElevatedButton(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Add to Cart',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}