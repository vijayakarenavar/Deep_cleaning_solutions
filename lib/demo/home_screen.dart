import 'package:flutter/material.dart';
import 'package:dcs_app/demo/services_section.dart';
import 'package:dcs_app/demo/srg_app_bar.dart';
import 'package:dcs_app/demo/srg_drawer.dart';
import 'package:dcs_app/demo/watch_in_action_section.dart';
import 'package:dcs_app/demo/why_choose_us_section.dart';

import 'app_colors.dart';
import 'banner_section.dart';
import 'faq_section.dart';
import 'how_we_work_section.dart';
import 'our_team_section.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      drawer: const SRGDrawer(),
      body: CustomScrollView(
        slivers: [
          const SRGSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              const BannerSection(),
              const SizedBox(height: 8),
              const ServicesSection(),
              const SizedBox(height: 8),
              const OurTeamSection(),
              const SizedBox(height: 8),
              const WhyChooseUsSection(),
              const SizedBox(height: 8),
              const HowWeWorkSection(),
              const SizedBox(height: 8),
              const WatchInActionSection(),
              const SizedBox(height: 8),
              const FAQSection(),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }
}