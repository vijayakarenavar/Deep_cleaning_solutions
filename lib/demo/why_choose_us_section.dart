import 'package:flutter/material.dart';
import 'package:dcs_app/demo/responsive.dart';

import 'app_colors.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.calendar_today,  'title': 'User-Friendly Booking',    'sub': 'Online Appointment Scheduling (with date/time selection)'},
    {'icon': Icons.local_offer,     'title': 'Discount Coupons & Offers', 'sub': 'Seasonal Cleaning Offers – Limited Time Only!'},
    {'icon': Icons.headset_mic,     'title': 'Customer Support',          'sub': 'Dedicated support'},
    {'icon': Icons.lock_outline,    'title': 'Payment Secure',            'sub': '100% secure payment'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: _items.map((item) => _WhyItem(data: item)).toList(),
      ),
    );
  }
}

class _WhyItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const _WhyItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(color: AppColors.redLight, shape: BoxShape.circle),
            child: Icon(data['icon'] as IconData, color: AppColors.secondary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] as String,
                    style: TextStyle(fontSize: R.sp(context, 14), fontWeight: FontWeight.w600, color: AppColors.black)),
                const SizedBox(height: 3),
                Text(data['sub'] as String,
                    style: TextStyle(fontSize: R.sp(context, 12), color: AppColors.textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}