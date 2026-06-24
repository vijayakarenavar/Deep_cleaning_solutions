import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/widgets/srg_app_bar.dart';
import 'package:dcs_app/widgets/srg_drawer.dart';
import 'package:dcs_app/providers/auth_provider.dart';
import 'package:dcs_app/providers/order_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).getProfile();
      ref.read(orderProvider.notifier).getOrders();
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState  = ref.watch(authProvider);
    final orderState = ref.watch(orderProvider);

    final userName = authState.user?['name']  ?? 'Guest';
    final userEmail = authState.user?['email'] ?? '';

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
                    authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Welcome back!\n$userName',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: R.sp(context, 22),
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    if (userEmail.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: R.sp(context, 12),
                        ),
                      ),
                    ],
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

              // ── Orders Count ───────────────────────
              if (orderState.orders.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Total Orders',
                        value: orderState.orders.length.toString(),
                        icon: Icons.receipt_long,
                        color: AppColors.primary,
                      ),
                      Container(width: 1, height: 40, color: AppColors.border),
                      _StatItem(
                        label: 'Active',
                        value: orderState.orders
                            .where((o) => o['status'] == 'active')
                            .length
                            .toString(),
                        icon: Icons.pending_actions,
                        color: AppColors.green,
                      ),
                      Container(width: 1, height: 40, color: AppColors.border),
                      _StatItem(
                        label: 'Completed',
                        value: orderState.orders
                            .where((o) => o['status'] == 'completed')
                            .length
                            .toString(),
                        icon: Icons.check_circle_outline,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),

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
                      onTap: _logout,
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

// ── Stat Item ─── ──────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: R.sp(context, 18),
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: R.sp(context, 11),
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ── Profile Menu Item ─────────────────────────────────────────────────
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