import 'package:flutter/material.dart';
import 'package:dcs_app/demo/app_colors.dart';
import 'package:dcs_app/demo/responsive.dart';
import 'package:dcs_app/demo/srg_app_bar.dart';
import 'package:dcs_app/demo/srg_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              // ── Hero ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF3A1F6E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Welcome back!\nVijayatest',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: R.sp(context, 22),
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your account and track your cleaning services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: R.sp(context, 13),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Menu ──────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    _ProfileMenuItem(
                      icon: Icons.person_outline,
                      label: 'My Profile',
                      isActive: true,
                      onTap: () {},
                    ),
                    _ProfileMenuItem(
                      icon: Icons.receipt_long,
                      label: 'My Orders',
                      onTap: () {},
                    ),
                    _ProfileMenuItem(
                      icon: Icons.favorite_outline,
                      label: 'Wishlist',
                      onTap: () {},
                    ),
                    _ProfileMenuItem(
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      onTap: () {},
                    ),
                    _ProfileMenuItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      isRed: true,
                      isLast: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive, isRed, isLast;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isRed    = false,
    this.isLast   = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isRed
        ? AppColors.secondary
        : isActive
        ? AppColors.secondary
        : AppColors.black;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isActive ? AppColors.redLight : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? const Border(left: BorderSide(color: AppColors.secondary, width: 3))
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: R.sp(context, 14),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: color,
                    ),
                  ),
                ),
                if (!isRed)
                  Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
          if (!isLast)
            const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}