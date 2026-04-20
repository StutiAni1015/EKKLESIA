import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../widgets/app_bottom_bar.dart';
import 'plan_checklist_sheet.dart';

class DiscoverPlansScreen extends StatefulWidget {
  const DiscoverPlansScreen({super.key});

  @override
  State<DiscoverPlansScreen> createState() => _DiscoverPlansScreenState();
}

class _DiscoverPlansScreenState extends State<DiscoverPlansScreen> {
  int _selectedCategory = 0;
  final _searchCtrl = TextEditingController();

  static const _categories = [
    'Bible Reading',
    'Prayer',
    'Fasting',
    'Missions',
  ];

  static const _bibleReadingPlans = [
    _Plan(
      title: '🙏 Prayer & Strength',
      description:
          'A 21-day journey through the Psalms and New Testament letters to build a powerful, consistent prayer life. Each day pairs a Psalm for worship with a passage from Philippians, Ephesians, Romans, or 1 Peter for spiritual strength.',
      duration: '21 Days',
      badge: 'New',
      gradientStart: Color(0xFF3B5998),
      gradientEnd: Color(0xFF8B5CF6),
      todayReadings: [
        'Psalms 1–3',
        'Philippians 1',
        'Memory Verse: Philippians 4:6–7',
      ],
    ),
    _Plan(
      title: '📖 Wisdom of God',
      description:
          'A 31-day deep dive into Proverbs and James. One chapter of Proverbs per day (matching the date of the month) plus James and Ecclesiastes for the wisdom that comes from above — pure, peaceable, and full of mercy.',
      duration: '31 Days',
      badge: 'Popular',
      gradientStart: Color(0xFF6B7FD4),
      gradientEnd: Color(0xFF9B8BBF),
      todayReadings: [
        'Proverbs 1',
        'James 1:1–18',
        'Memory Verse: Proverbs 1:7',
      ],
    ),
    _Plan(
      title: '✝️ Life of Jesus',
      description:
          'Walk with Jesus for 30 days through all four Gospels. Matthew reveals the King, Mark shows the Servant, Luke focuses on the Son of Man, and John reveals the Son of God. See the full portrait of Christ day by day.',
      duration: '30 Days',
      badge: 'Featured',
      gradientStart: Color(0xFFB45309),
      gradientEnd: Color(0xFFD97706),
      todayReadings: [
        'Matthew 1–2',
        'Luke 1:1–38',
        'Memory Verse: John 1:14',
      ],
    ),
    _Plan(
      title: '🔥 Discipline & Growth',
      description:
          'A 40-day challenge for serious disciples. Walk through Exodus, Romans, Joshua, Hebrews, and Galatians — the story of redemption, law, freedom, and faith. Designed for those ready to be stretched and transformed.',
      duration: '40 Days',
      badge: null,
      gradientStart: Color(0xFF7C3AED),
      gradientEnd: Color(0xFFEC4899),
      todayReadings: [
        'Exodus 1–2',
        'Romans 1',
        'Memory Verse: Romans 1:16–17',
      ],
    ),
    _Plan(
      title: '📚 Full Bible Journey',
      description:
          'A structured 90-day overview of the entire Bible. Old Testament narratives, Psalms and Proverbs for daily wisdom, and New Testament letters for doctrine and life. Perfect for a summer, a quarter, or a personal reset.',
      duration: '90 Days',
      badge: 'Complete',
      gradientStart: Color(0xFF065F46),
      gradientEnd: Color(0xFF059669),
      todayReadings: [
        'Genesis 1–3',
        'Psalm 1',
        'Matthew 1',
        'Memory Verse: Genesis 1:1',
      ],
    ),
    _Plan(
      title: 'The Psalms: Songs of Life',
      description:
          'Discover deep emotional connection with God through the ancient hymns of Israel.',
      duration: '14 Days',
      badge: null,
      gradientStart: Color(0xFF4A6741),
      gradientEnd: Color(0xFF8BA888),
      todayReadings: [
        'Psalm 1',
        'Psalm 2',
        'Memory Verse: Psalm 1:1–2',
      ],
    ),
  ];

  static const _missionPlans = [
    _Plan(
      title: 'Global Missions Prayer Guide',
      description:
          'Join our church in praying for unreached people groups across every continent.',
      duration: 'Ongoing',
      badge: null,
      gradientStart: Color(0xFFEC5B13),
      gradientEnd: Color(0xFFD4966B),
      durationIcon: Icons.public,
      todayReadings: [
        'Acts 1:1–11',
        'Matthew 28:16–20',
        'Prayer Focus: North Africa',
      ],
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final chipBg = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: const AppBottomBar(activeIndex: kTabHome),
      floatingActionButton: buildCenterFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: bg.withOpacity(0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Discover Your Path',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                            color: textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list,
                            color: AppColors.primary),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filter plans coming soon!'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    controller: _searchCtrl,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Search for plans, topics...',
                      hintStyle: TextStyle(color: subColor, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: subColor),
                      filled: true,
                      fillColor: AppColors.primary.withOpacity(0.05),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),

                // Category chips
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final selected = _selectedCategory == i;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : chipBg,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : borderColor,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color:
                                          AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            _categories[i],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : subColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                        16, 8, 16, MediaQuery.of(context).padding.bottom + 96),
                    children: [
                      // Bible Reading section
                      _SectionHeader(
                        title: 'Bible Reading',
                        textColor: textColor,
                        onViewAll: () {},
                      ),
                      const SizedBox(height: 12),
                      ..._bibleReadingPlans.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _PlanCard(
                              plan: p,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                            ),
                          )),
                      const SizedBox(height: 12),

                      // Global Missions section
                      _SectionHeader(
                        title: 'Global Missions',
                        textColor: textColor,
                        onViewAll: () {},
                      ),
                      const SizedBox(height: 12),
                      ..._missionPlans.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _PlanCard(
                              plan: p,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  final VoidCallback onViewAll;

  const _SectionHeader({
    required this.title,
    required this.textColor,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final Color cardBg;
  final Color borderColor;
  final Color subColor;
  final Color textColor;

  const _PlanCard({
    required this.plan,
    required this.cardBg,
    required this.borderColor,
    required this.subColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [plan.gradientStart, plan.gradientEnd],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white.withOpacity(0.3),
                  size: 48,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        plan.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (plan.badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          plan.badge!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  plan.description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: subColor,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                    color: AppColors.primary.withOpacity(0.06), height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          plan.durationIcon ?? Icons.schedule,
                          color: subColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          plan.duration,
                          style: TextStyle(fontSize: 12, color: subColor),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        int days = 365;
                        final match =
                            RegExp(r'(\d+)').firstMatch(plan.duration);
                        if (match != null) {
                          days = int.tryParse(match.group(1)!) ?? 365;
                        }
                        selectedPlanNotifier.value = BiblePlan(
                          title: plan.title,
                          totalDays: days,
                          daysCompleted: 0,
                          todayReadings: plan.todayReadings,
                        );
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => PlanChecklistSheet(
                            planTitle: plan.title,
                            gradientStart: plan.gradientStart,
                            gradientEnd: plan.gradientEnd,
                            readings: plan.todayReadings,
                            onComplete: () => Navigator.maybePop(context),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Add to Journey',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final bool isDark;
  final double bottomPadding;
  final VoidCallback onHome;

  const _BottomNav({
    required this.isDark,
    required this.bottomPadding,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.black.withOpacity(0.95)
        : Colors.white.withOpacity(0.95);
    final borderColor = isDark
        ? AppColors.primary.withOpacity(0.1)
        : const Color(0xFFE2E8F0);

    return Container(
      padding: EdgeInsets.fromLTRB(24, 8, 24, bottomPadding + 8),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
              icon: Icons.home,
              label: 'Home',
              active: true,
              onTap: onHome),
          _NavItem(
              icon: Icons.group,
              label: 'Groups',
              active: false,
              onTap: () => Navigator.maybePop(context)),
          const SizedBox(width: 56),
          _NavItem(
              icon: Icons.volunteer_activism,
              label: 'Pray',
              active: false,
              onTap: () => Navigator.maybePop(context)),
          _NavItem(
              icon: Icons.person,
              label: 'Profile',
              active: false,
              onTap: () => Navigator.maybePop(context)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : const Color(0xFF94A3B8);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Plan {
  final String title;
  final String description;
  final String duration;
  final String? badge;
  final Color gradientStart;
  final Color gradientEnd;
  final IconData? durationIcon;
  final List<String> todayReadings;

  const _Plan({
    required this.title,
    required this.description,
    required this.duration,
    required this.badge,
    required this.gradientStart,
    required this.gradientEnd,
    this.durationIcon,
    this.todayReadings = const [],
  });
}
