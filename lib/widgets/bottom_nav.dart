import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StrahBottomNav extends StatelessWidget {
  final int currentIndex;
  const StrahBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, current: currentIndex, route: '/'),
              _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Funds', index: 1, current: currentIndex, route: '/funds'),
              _NavItem(icon: Icons.people_rounded, label: 'Workers', index: 2, current: currentIndex, route: '/workers'),
              _NavItem(icon: Icons.location_on_rounded, label: 'Track', index: 3, current: currentIndex, route: '/tracking'),
              _NavItem(icon: Icons.more_horiz_rounded, label: 'More', index: 4, current: currentIndex, route: '/plan'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = index == current;
    return GestureDetector(
      onTap: () {
        if (!active) Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.primarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? AppTheme.primary : AppTheme.textGray, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppTheme.primary : AppTheme.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
