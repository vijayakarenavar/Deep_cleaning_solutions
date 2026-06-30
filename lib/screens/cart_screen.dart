import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/app_images.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/providers/cart_provider.dart';
import 'package:dcs_app/widgets/app_network_image.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartProvider.notifier).getCart());
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.cartItems;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: cartState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : cartItems.isEmpty
          ? _EmptyCart()
          : Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(cartProvider.notifier).getCart(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _CartItemCard(
                  item: cartItems[i],
                  onRemove: () => ref.read(cartProvider.notifier).removeCartItem(
                    cartItems[i]['rowId']?.toString() ?? '',
                  ),
                ),
              ),
            ),
          ),
          _CartSummary(
            totalAmount: cartState.totalAmount,
            discountAmount: cartState.discountAmount,
            finalAmount: cartState.finalAmount,
            onCheckout: () => context.go('/checkout'),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, color: AppColors.textMuted, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add services to get started',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Shop Now'),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ service_name वरून BHK image काढणारा helper
String _getImageForService(String serviceName) {
  final name = serviceName.toLowerCase();

  // BHK index ठरव
  int bhkIndex = 0;
  if (name.contains('2 bhk') || name.contains('2bhk')) bhkIndex = 1;
  else if (name.contains('3 bhk') || name.contains('3bhk')) bhkIndex = 2;
  else if (name.contains('4 bhk') || name.contains('4bhk')) bhkIndex = 3;
  else if (name.contains('5 bhk') || name.contains('5bhk')) bhkIndex = 4;

  // Furnished / Unfurnished check
  if (name.contains('unfurnished')) {
    return AppImages.unfurnishedBHK[bhkIndex % AppImages.unfurnishedBHK.length];
  } else if (name.contains('furnished')) {
    return AppImages.furnishedBHK[bhkIndex % AppImages.furnishedBHK.length];
  }

  // Other services → category image
  if (name.contains('bungalow'))   return AppImages.bungalow;
  if (name.contains('office'))     return AppImages.office;
  if (name.contains('society'))    return AppImages.society;
  if (name.contains('restaurant')) return AppImages.restaurant;
  if (name.contains('shop'))       return AppImages.shop;
  if (name.contains('school'))     return AppImages.school;
  if (name.contains('car'))        return AppImages.carWash;
  if (name.contains('kitchen'))    return AppImages.kitchen[0];
  if (name.contains('bathroom') || name.contains('bath')) return AppImages.bathroom[0];
  if (name.contains('bedroom') || name.contains('bed'))   return AppImages.bedroom[0];
  if (name.contains('hall'))       return AppImages.hall[0];
  if (name.contains('floor'))      return AppImages.floor[0];
  if (name.contains('window'))     return AppImages.window[0];

  // Default fallback
  return AppImages.flat;
}

class _CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final int quantity    = item['quantity'] ?? 1;
    final double price    = (item['price'] ?? 0.0).toDouble();
    final String serviceName = item['service_name'] ?? item['name'] ?? 'Service';

    // ✅ service_name वरून local image URL मिळव
    final String imageUrl = _getImageForService(serviceName);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ✅ Service Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                url: imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // ✅ Name + Price + Qty
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
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
                  const SizedBox(height: 4),
                  Text(
                    'Qty: $quantity',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Delete Button only
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, size: 22),
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final VoidCallback onCheckout;

  const _CartSummary({
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (discountAmount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal', style: TextStyle(color: AppColors.textMuted)),
                Text(
                  '₹${totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount', style: TextStyle(color: AppColors.green)),
                Text(
                  '-₹${discountAmount.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.green),
                ),
              ],
            ),
            const Divider(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Text(
                '₹${finalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}