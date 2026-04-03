import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../screens/dashboard_screen.dart';
import '../screens/my_church_daily_screen.dart';
import '../screens/my_giving_dashboard_screen.dart';
import '../screens/bible_books_index_screen.dart';
import '../screens/user_profile_screen.dart';

// Active tab index constants
const kTabHome = 0;
const kTabCommunity = 1;
const kTabBible = 2; // center FAB
const kTabGivings = 3;
const kTabProfile = 4;

class AppBottomBar extends StatelessWidget {
  final int activeIndex;

  const AppBottomBar({super.key, required this.activeIndex});

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
      case kTabCommunity:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyChurchDailyScreen()),
          (route) => false,
        );
        break;
      case kTabGivings:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyGivingDashboardScreen()),
          (route) => false,
        );
        break;
      case kTabProfile:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const UserProfileScreen()),
          (route) => false,
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
      const _NavItem(Icons.home_rounded, 'Home'),
      const _NavItem(Icons.people_rounded, 'Community'),
      null, // center FAB (Bible)
      const _NavItem(Icons.volunteer_activism_rounded, 'Givings'),
      const _NavItem(Icons.person_rounded, 'Profile'),
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
                            letterSpacing: 0.5,
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
  return FloatingActionButton(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BibleBooksIndexScreen()),
    ),
    backgroundColor: AppColors.primary,
    elevation: 4,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
        SizedBox(height: 2),
        Text(
          'Bible',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
