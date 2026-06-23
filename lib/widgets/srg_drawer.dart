import 'package:flutter/material.dart';

import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/screens/contact_screen.dart';


class SRGDrawer extends StatelessWidget {
  const SRGDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(bottom: BorderSide(color: AppColors.secondary, width: 2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.purpleLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(Icons.person, color: AppColors.primary, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rahul Sharma',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.black)),
                        SizedBox(height: 2),
                        Text('rahul@gmail.com',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            DrawerItem(icon: Icons.person_outline,          label: 'My Profile',    isActive: true, onTap: () => Navigator.pop(context)),
            DrawerItem(icon: Icons.calendar_month_outlined, label: 'My Bookings',                  onTap: () => Navigator.pop(context)),
            const Divider(indent: 16, endIndent: 16),
            DrawerItem(icon: Icons.phone_outlined,          label: 'Contact Us',                   onTap: () => Navigator.pop(context)),
            DrawerItem(icon: Icons.language_outlined,       label: 'Visit Website',                onTap: () => Navigator.pop(context)),
            const Divider(indent: 16, endIndent: 16),
            DrawerItem(icon: Icons.settings_outlined,       label: 'Settings',                     onTap: () => Navigator.pop(context)),
            const Spacer(),
            const Divider(indent: 16, endIndent: 16),
            DrawerItem(icon: Icons.logout,                  label: 'Logout', isRed: true,           onTap: () => Navigator.pop(context)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive, isRed;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isRed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isRed ? AppColors.secondary : isActive ? AppColors.primary : AppColors.black;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const ContactScreen(),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: isActive ? AppColors.purpleLight : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? const Border(left: BorderSide(color: AppColors.primary, width: 3)) : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: color,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}