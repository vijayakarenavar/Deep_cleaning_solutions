import 'package:flutter/material.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/widgets/section_title.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/app_images.dart';
import 'package:dcs_app/widgets/app_network_image.dart';

class OurTeamSection extends StatelessWidget {
  final List<dynamic> team;

  const OurTeamSection({
    super.key,
    this.team = const [],
  });

  @override
  Widget build(BuildContext context) {
    // API data असेल तर API image, नाहीतर static image
    final imageUrl = team.isNotEmpty
        ? (team[0]['image'] ?? team[0]['photo'] ?? AppImages.team).toString()
        : AppImages.team;

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
                url: imageUrl,
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