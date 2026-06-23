import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_images.dart';
import 'app_network_image.dart';


class SRGAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SRGAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: Builder(
        builder: (c) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.black),
          onPressed: () => Scaffold.of(c).openDrawer(),
        ),
      ),
      title: AppNetworkImage(
        url: AppImages.logo,
        height: 48,
        width: 140,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.search,                color: AppColors.black), onPressed: () {}),
        IconButton(icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.black), onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }
}

// Sliver version for CustomScrollView
class SRGSliverAppBar extends StatelessWidget {
  const SRGSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      pinned: true,
      leading: Builder(
        builder: (c) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.black),
          onPressed: () => Scaffold.of(c).openDrawer(),
        ),
      ),
      title: AppNetworkImage(
        url: AppImages.logo,
        height: 48,
        width: 140,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.search,                color: AppColors.black), onPressed: () {}),
        IconButton(icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.black), onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }
}