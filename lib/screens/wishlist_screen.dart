// lib/screens/wishlist_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/app_images.dart';
import 'package:dcs_app/utils/service_catalog.dart';
import 'package:dcs_app/providers/wishlist_provider.dart';
import 'package:dcs_app/providers/product_provider.dart';
import 'package:dcs_app/widgets/app_network_image.dart';
import 'service_detail_sheet.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(wishlistProvider.notifier).getWishlist();
      // ✅ wishlist API मध्ये sqft_min/sqft_max नाही, म्हणून furnished/
      // unfurnished flats (जिथे तो backend कडून dynamically येतो) इथेच
      // आधी लोड करून घेतो
      await ref.read(productProvider.notifier).getFurnishedFlats();
      await ref.read(productProvider.notifier).getUnfurnishedFlats();
    });
  }

  num? _parseNum(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  // ✅ wishlist item च्या id वरून furnished/unfurnished flats मध्ये matching
  // product शोधतो आणि backend चाच actual sqft_min/sqft_max परत देतो —
  // कुठलाही number इथे hardcode नाही, backend कडून जो range येईल तोच वापरला जातो
  Map<String, num?> _getSqftRange(int? productId) {
    if (productId == null) return {'min': null, 'max': null};

    final productState = ref.read(productProvider);
    final allFlats = [
      ...productState.furnishedFlats,
      ...productState.unfurnishedFlats,
    ];

    Map<String, dynamic>? match;
    for (final p in allFlats) {
      if (p['id'] == productId) {
        match = p;
        break;
      }
    }

    if (match == null) return {'min': null, 'max': null};

    return {
      'min': _parseNum(match['sqft_min']),
      'max': _parseNum(match['sqft_max']),
    };
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistProvider);
    ref.watch(productProvider); // ✅ flats load झाल्यावर rebuild होण्यासाठी

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
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
              onAddToCart: () {
                final title     = item['title'] ?? item['name'] ?? 'Service';
                final productId = item['id'] as int?;
                final slug      = item['slug'] as String?;

                // ✅ dynamic — backend च्या actual product data मधून sqft घेतो
                final sqftRange = _getSqftRange(productId);

                // ✅ title वरून योग्य services breakdown शोधतो (BHK screen सारखं)
                final services = ServiceCatalog.fromTitle(title) ?? const [];

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ServiceDetailSheet(
                    title: title,
                    services: services,
                    productId: productId,
                    slug: slug,
                    sqftMin: sqftRange['min'],
                    sqftMax: sqftRange['max'],
                  ),
                );
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

String _getImageForItem(String name) {
  final n = name.toLowerCase();

  int bhkIndex = 0;
  if (n.contains('2 bhk') || n.contains('2bhk')) bhkIndex = 1;
  else if (n.contains('3 bhk') || n.contains('3bhk')) bhkIndex = 2;
  else if (n.contains('4 bhk') || n.contains('4bhk')) bhkIndex = 3;
  else if (n.contains('5 bhk') || n.contains('5bhk')) bhkIndex = 4;

  if (n.contains('unfurnished')) {
    return AppImages.unfurnishedBHK[bhkIndex % AppImages.unfurnishedBHK.length];
  } else if (n.contains('furnished')) {
    return AppImages.furnishedBHK[bhkIndex % AppImages.furnishedBHK.length];
  }

  if (n.contains('bungalow'))   return AppImages.bungalow;
  if (n.contains('office'))     return AppImages.office;
  if (n.contains('society'))    return AppImages.society;
  if (n.contains('restaurant')) return AppImages.restaurant;
  if (n.contains('shop'))       return AppImages.shop;
  if (n.contains('school'))     return AppImages.school;
  if (n.contains('car'))        return AppImages.carWash;
  if (n.contains('kitchen'))    return AppImages.kitchen[0];
  if (n.contains('bathroom') || n.contains('bath')) return AppImages.bathroom[0];
  if (n.contains('bedroom') || n.contains('bed'))   return AppImages.bedroom[0];
  if (n.contains('hall'))       return AppImages.hall[0];
  if (n.contains('floor'))      return AppImages.floor[0];
  if (n.contains('window'))     return AppImages.window[0];

  return AppImages.flat;
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

    final String? apiImage = item['image'] ?? item['thumbnail'];
    final bool hasApiImage = apiImage != null && apiImage.isNotEmpty;
    final String fallbackImage = _getImageForItem(name);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                url: hasApiImage ? apiImage : fallbackImage,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
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
                    '₹${price.toStringAsFixed(0)}/sq.ft',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.favorite,
                      color: AppColors.secondary, size: 22),
                  tooltip: 'Remove from wishlist',
                ),
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