import 'package:flutter/material.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/widgets/section_title.dart';

import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/app_images.dart';
import 'package:dcs_app/widgets/app_network_image.dart';

class OurTeamSection extends StatelessWidget {
  const OurTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          const SectionTitle('Our Team'),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            height: R.wp(context, 55),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppNetworkImage(
                url: AppImages.team,
                width: double.infinity,
                height: R.wp(context, 55),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}