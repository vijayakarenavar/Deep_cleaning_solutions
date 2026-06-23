import 'package:flutter/material.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/widgets/section_title.dart';

import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/app_images.dart';
import 'package:dcs_app/widgets/app_network_image.dart';

class HowWeWorkSection extends StatefulWidget {
  const HowWeWorkSection({super.key});

  @override
  State<HowWeWorkSection> createState() => _HowWeWorkSectionState();
}

class _HowWeWorkSectionState extends State<HowWeWorkSection> {
  int _current = 0;
  final PageController _ctrl = PageController();

  // Each item: label + list of image URLs from AppImages
  static final List<Map<String, dynamic>> _items = [
    {'label': 'Kitchen Deep Cleaning', 'images': AppImages.kitchen},
    {'label': 'Bedroom Cleaning',      'images': AppImages.bedroom},
    {'label': 'Bathroom Cleaning',     'images': AppImages.bathroom},
    {'label': 'Hall Cleaning',         'images': AppImages.hall},
    {'label': 'Window Cleaning',       'images': AppImages.window},
    {'label': 'Floor Cleaning',        'images': AppImages.floor},
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _prev() {
    if (_current > 0) {
      setState(() => _current--);
      _ctrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _next() {
    if (_current < _items.length - 1) {
      setState(() => _current++);
      _ctrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgH = R.wp(context, 65);

    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          const SectionTitle('How We Work'),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: imgH,
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _items.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (_, i) {
                    final item   = _items[i];
                    final images = item['images'] as List<String>;
                    // Pick first image as hero
                    final imageUrl = images.isNotEmpty ? images[0] : '';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppNetworkImage(
                            url: imageUrl,
                            width: double.infinity,
                            height: imgH,
                            fit: BoxFit.cover,
                          ),
                          // Label overlay
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                              ),
                              child: Text(
                                item['label'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Prev button
              Positioned(
                left: 20,
                child: GestureDetector(
                  onTap: _prev,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
                    ),
                    child: const Icon(Icons.chevron_left, size: 20),
                  ),
                ),
              ),
              // Next button
              Positioned(
                right: 20,
                child: GestureDetector(
                  onTap: _next,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
                    ),
                    child: const Icon(Icons.chevron_right, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}