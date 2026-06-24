import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcs_app/screens/services_section.dart';
import 'package:dcs_app/widgets/srg_app_bar.dart';
import 'package:dcs_app/widgets/srg_drawer.dart';
import 'package:dcs_app/screens/watch_in_action_section.dart';
import 'package:dcs_app/screens/why_choose_us_section.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/screens/banner_section.dart';
import 'package:dcs_app/screens/faq_section.dart';
import 'package:dcs_app/screens/how_we_work_section.dart';
import 'package:dcs_app/screens/our_team_section.dart';
import 'package:dcs_app/providers/home_provider.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // App start झाल्यावर home data load करा
    Future.microtask(() =>
        ref.read(homeProvider.notifier).getHomeData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      drawer: const SRGDrawer(),
      body: homeState.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      )
          : homeState.error != null
          ? _ErrorWidget(
        error: homeState.error!,
        onRetry: () => ref.read(homeProvider.notifier).refresh(),
      )
          : RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            const SRGSliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                BannerSection(
                  banners: homeState.banners,
                ),
                const SizedBox(height: 8),
                ServicesSection(
                  categories: homeState.categories,
                ),
                const SizedBox(height: 8),
                OurTeamSection(
                  team: homeState.team,
                ),
                const SizedBox(height: 8),
                const WhyChooseUsSection(),
                const SizedBox(height: 8),
                const HowWeWorkSection(),
                const SizedBox(height: 8),
                WatchInActionSection(
                  videos: homeState.videos,
                ),
                const SizedBox(height: 8),
                FAQSection(
                  faqs: homeState.faqs,
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error Widget ──────────────────────────────────────────────────────
class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.secondary,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}