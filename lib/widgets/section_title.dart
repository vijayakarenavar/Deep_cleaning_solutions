import 'package:flutter/material.dart';
import 'package:dcs_app/utils/responsive.dart';

import 'package:dcs_app/utils/app_colors.dart';


class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: R.sp(context, 18),
              fontWeight: FontWeight.w800,
              color: AppColors.black,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 40, height: 3,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}