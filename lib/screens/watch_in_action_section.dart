import 'package:flutter/material.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/widgets/section_title.dart';

import 'package:dcs_app/utils/app_colors.dart';

class WatchInActionSection extends StatelessWidget {
  const WatchInActionSection({super.key});

  static const List<Map<String, String>> _videos = [
    {'title': 'Hall Cleaning That Shines! | SRG Cleaning', 'channel': 'Suvarnaraj Group', 'desc': 'Our Advanced Equipments',      'sub': 'Watch how our professionals transform spaces with our comprehensive cleaning process.'},
    {'title': 'SRG – Our Cleaning Process Results',        'channel': 'Suvarnaraj Group', 'desc': 'Our Cleaning Process Results', 'sub': 'Watch how our professionals transform spaces with our comprehensive cleaning process.'},
    {'title': 'Glass Cleaning – Expert Method | SRG',      'channel': 'Suvarnaraj Group', 'desc': 'Glass Cleaning Expertise',     'sub': 'See our experts tackle the toughest glass surfaces with precision.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          const SectionTitle('Watch Us In Action'),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: _videos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, i) => _VideoCard(data: _videos[i]),
          ),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Map<String, String> data;
  const _VideoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YouTube thumbnail style
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              height: R.wp(context, 55),
              color: const Color(0xFF2A2A2A),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 10, left: 10, right: 60,
                    child: Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Center(
                            child: Text('SRG', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['title']!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                              Text(data['channel']!, style: const TextStyle(color: Colors.white70, fontSize: 9)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Play button
                  Container(
                    width: 50, height: 50,
                    decoration: const BoxDecoration(color: Color(0xFFFF0000), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                  ),
                  // YouTube badge
                  Positioned(
                    bottom: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.play_circle_fill, color: Colors.white, size: 12),
                          SizedBox(width: 3),
                          Text('Watch on YouTube', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  // Link icon
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.link, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Card body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['desc']!,
                    style: TextStyle(fontSize: R.sp(context, 14), fontWeight: FontWeight.w700, color: AppColors.black)),
                const SizedBox(height: 4),
                Text(data['sub']!,
                    style: TextStyle(fontSize: R.sp(context, 12), color: AppColors.textMuted, height: 1.4),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('Watch More',
                    style: TextStyle(fontSize: R.sp(context, 12), color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}