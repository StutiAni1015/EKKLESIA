import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../screens/add_prayer_request_screen.dart';
import '../screens/bible_books_index_screen.dart';
import '../screens/create_giving_request_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/my_church_daily_screen.dart';
import '../screens/my_giving_dashboard_screen.dart';
import '../screens/user_profile_screen.dart';

// Active tab index constants
const kTabHome      = 0;
const kTabCommunity = 1;
const kTabBible     = 2; // center FAB slot
const kTabGivings   = 3;
const kTabProfile   = 4;

// ── FAB config per tab ────────────────────────────────────────────────────────
class _FabConfig {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _FabConfig({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

_FabConfig _fabConfigFor(BuildContext context, int activeIndex) {
  switch (activeIndex) {
    case kTabCommunity:
      return _FabConfig(
        icon: Icons.add,
        label: 'Prayer',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPrayerRequestScreen()),
        ),
      );
    case kTabGivings:
      return _FabConfig(
        icon: Icons.add,
        label: 'Give',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const CreateGivingRequestScreen()),
        ),
      );
    case kTabProfile:
      return _FabConfig(
        icon: Icons.edit_outlined,
        label: 'Edit',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Edit profile coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );
    default: // kTabHome and all other screens
      return _FabConfig(
        icon: Icons.menu_book_rounded,
        label: 'Bible',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BibleBooksIndexScreen()),
        ),
      );
  }
}

// ── Public FAB builder ────────────────────────────────────────────────────────
/// Pass [activeIndex] matching the screen's tab so the FAB icon/action
/// animates to match the context (Bible · Prayer+ · Give+ · Edit).
FloatingActionButton buildCenterFab(
  BuildContext context, {
  int activeIndex = kTabHome,
}) {
  final cfg = _fabConfigFor(context, activeIndex);
  return FloatingActionButton(
    heroTag: 'center_fab',
    onPressed: cfg.onPressed,
    backgroundColor: AppColors.primary,
    elevation: 4,
    child: _AnimatedFabContent(icon: cfg.icon, label: cfg.label),
  );
}

// ── Animated icon + label inside the FAB ─────────────────────────────────────
class _AnimatedFabContent extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AnimatedFabContent({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: anim,
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: Column(
        key: ValueKey(icon), // triggers animation when icon changes
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
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
}

// ── Bottom bar ────────────────────────────────────────────────────────────────
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
      null, // center FAB slot
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

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
