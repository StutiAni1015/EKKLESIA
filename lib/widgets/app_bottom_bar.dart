import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../screens/dashboard_screen.dart';
import '../screens/my_church_daily_screen.dart';
import '../screens/prayer_heartbeat_screen.dart';
import '../screens/spiritual_focus_mode_screen.dart';

// The active tab index for each main screen.
const kTabHome = 0;
const kTabGroups = 1;
const kTabPray = 3;
const kTabProfile = 4;

class AppBottomBar extends StatelessWidget {
  final int activeIndex;

  const AppBottomBar({super.key, required this.activeIndex});

  static const _navBg = Color(0xFFFCF9F7);

  void _onTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    switch (index) {
      case kTabHome:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
        break;
      case kTabGroups:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyChurchDailyScreen()),
          (route) => false,
        );
        break;
      case kTabPray:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PrayerHeartbeatScreen()),
          (route) => false,
        );
        break;
      case kTabProfile:
        // Profile screen placeholder
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark
        ? const Color(0xFF0F172A).withOpacity(0.95)
        : Colors.white.withOpacity(0.95);

    final items = <_NavItem?>[
      const _NavItem(Icons.home, 'Home'),
      const _NavItem(Icons.group, 'Groups'),
      null, // center FAB
      const _NavItem(Icons.volunteer_activism, 'Pray'),
      const _NavItem(Icons.person, 'Profile'),
    ];

    return BottomAppBar(
      color: navBg,
      elevation: 0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++)
              if (items[i] == null)
                const SizedBox(width: 56)
              else
                GestureDetector(
                  onTap: () => _onTap(context, i),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[i]!.icon,
                          size: 26,
                          color: activeIndex == i
                              ? AppColors.primary
                              : const Color(0xFFCBD5E1),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i]!.label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: activeIndex == i
                                ? AppColors.primary
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

FloatingActionButton buildCenterFab(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  const _navBg = Color(0xFFFCF9F7);

  return FloatingActionButton(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SpiritualFocusModeScreen()),
    ),
    backgroundColor: AppColors.primary,
    elevation: 0,
    child: const Icon(Icons.auto_stories, color: Colors.white, size: 28),
  );
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
