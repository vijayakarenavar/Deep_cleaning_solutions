import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/app_images.dart';
import 'package:dcs_app/widgets/app_network_image.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/providers/product_provider.dart';
import 'service_detail_sheet.dart';

class BHKListScreen extends ConsumerStatefulWidget {
  final String type;
  const BHKListScreen({super.key, required this.type});

  @override
  ConsumerState<BHKListScreen> createState() => _BHKListScreenState();
}

class _BHKListScreenState extends ConsumerState<BHKListScreen> {

  static const List<Map<String, dynamic>> _bhkList = [
    {'name': '1 BHK'},
    {'name': '2 BHK'},
    {'name': '3 BHK'},
    {'name': '4 BHK'},
    {'name': '5 BHK'},
  ];

  static const Map<String, List<Map<String, String>>> _furnishedServices = {
    '1 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Inside & Outside), Fans/AC, Floor Scrubbing & Mopping, Tables/Chairs/Lamp/Frames/TV set etc.'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Inside & Outside), Fans/AC, Floor Scrubbing & Mopping, Bed (Inside/Outside)'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior), Cabinets & Trolly Cleaning (Inside & Outside, Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Exhaust (WetWiping), Hard Stain Removal, Drill Brush Scrubbing, Sink Cleaning, Mirrors/Glass wiping'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '2 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Inside & Outside), Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets (Inside & Outside), Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 2 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior), Steam Cleaner'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Exhaust (WetWiping), Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 2 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '3 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping, Tables/Chairs/Lamp/Frames/TV set etc.'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 3 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing, Chimney/Stove (Exterior), Cabinets & Trolly (Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 3 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '4 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 4 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior), Cabinets & Trolly (Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 4 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '5 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 5 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior), Cabinets & Trolly (Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 5 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
  };

  static const Map<String, List<Map<String, String>>> _unfurnishedServices = {
    '1 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Outside), Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Exhaust (WetWiping), Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '2 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Outside), Fans/AC, Floor Scrubbing & Mopping — 2 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 2 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '3 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping — 3 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 3 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '4 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping — 4 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 4 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '5 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping — 5 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 5 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.type == 'Furnished') {
        ref.read(productProvider.notifier).getFurnishedFlats();
      } else {
        ref.read(productProvider.notifier).getUnfurnishedFlats();
      }
    });
  }

  List<Map<String, String>> _getServices(String bhk) {
    if (widget.type == 'Furnished') {
      return _furnishedServices[bhk] ?? _furnishedServices['1 BHK']!;
    }
    return _unfurnishedServices[bhk] ?? _unfurnishedServices['1 BHK']!;
  }

  String _getImageUrl(int index) {
    final productState = ref.read(productProvider);
    final products = widget.type == 'Furnished'
        ? productState.furnishedFlats
        : productState.unfurnishedFlats;

    if (products.isNotEmpty && index < products.length) {
      return (products[index]['image'] ?? products[index]['thumbnail'] ?? '').toString();
    }

    if (widget.type == 'Furnished') {
      return AppImages.furnishedBHK[index % AppImages.furnishedBHK.length];
    }
    return AppImages.unfurnishedBHK[index % AppImages.unfurnishedBHK.length];
  }

  int? _getProductId(int index) {
    final productState = ref.read(productProvider);
    final products = widget.type == 'Furnished'
        ? productState.furnishedFlats
        : productState.unfurnishedFlats;

    if (products.isNotEmpty && index < products.length) {
      return products[index]['id'] as int?;
    }
    return null;
  }
  // _getProductId च्या खाली हा नवीन method add करा:
  String? _getSlug(int index) {
    final productState = ref.read(productProvider);
    final products = widget.type == 'Furnished'
        ? productState.furnishedFlats
        : productState.unfurnishedFlats;

    if (products.isNotEmpty && index < products.length) {
      return products[index]['slug'] as String?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.type} Flats',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: productState.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bhkList.length,
              itemBuilder: (_, i) {
                final bhkName  = _bhkList[i]['name'] as String;
                final fullName = '$bhkName ${widget.type} Homes';

                return GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ServiceDetailSheet(
                      title:     fullName,
                      services:  _getServices(bhkName),
                      productId: _getProductId(i),
                      slug:      _getSlug(i),    // ← हे add केलं
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            AppNetworkImage(
                              url: _getImageUrl(i),
                              width: double.infinity,
                              height: R.wp(context, 60),
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            Positioned(
                              top: 10, left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'NEW',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fullName,
                          style: TextStyle(
                            fontSize: R.sp(context, 15),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5, (_) => const Icon(Icons.star, color: AppColors.star, size: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}