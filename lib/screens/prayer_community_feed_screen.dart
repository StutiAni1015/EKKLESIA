import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'add_prayer_request_screen.dart';

class PrayerCommunityFeedScreen extends StatefulWidget {
  const PrayerCommunityFeedScreen({super.key});

  @override
  State<PrayerCommunityFeedScreen> createState() =>
      _PrayerCommunityFeedScreenState();
}

class _PrayerCommunityFeedScreenState extends State<PrayerCommunityFeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _requests = [
    _PrayerItem(
      name: 'Sarah Jenkins',
      timeAgo: '2 hours ago',
      body:
          "Please pray for my mother's upcoming surgery this Tuesday. We are trusting in God's healing hands and asking for peace for our family during this time.",
      prayCount: 42,
      prayLabel: 'people prayed',
      isPraise: false,
      initials: 'SJ',
      color: Color(0xFFDCAE96),
    ),
    _PrayerItem(
      name: 'David Chen',
      timeAgo: '5 hours ago',
      body:
          'Requesting strength and guidance during a difficult transition at work. Trusting that when one door closes, the Lord opens another.',
      prayCount: 15,
      prayLabel: 'people prayed',
      isPraise: false,
      initials: 'DC',
      color: Color(0xFFB9D1EA),
    ),
    _PrayerItem(
      name: 'Maria Rodriguez',
      timeAgo: 'Yesterday',
      body:
          "Praising God for my son's recovery from the flu! Thank you all for your prayers last week. God is good!",
      prayCount: 89,
      prayLabel: 'people joined in praise',
      isPraise: true,
      initials: 'MR',
      color: Color(0xFFB2C2A3),
    ),
  ];

  final Set<int> _prayed = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        decoration: BoxDecoration(
                          color: bg.withOpacity(0.95),
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
                                'Prayer Requests',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                  color: textColor,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.search, color: textColor),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      // Tab bar
                      Container(
                        decoration: BoxDecoration(
                          color: bg.withOpacity(0.9),
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primary.withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: subColor,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 2,
                          tabs: const [
                            Tab(text: 'Community'),
                            Tab(text: 'My Requests'),
                            Tab(text: 'Answered'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Community tab
                  ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                        16, 16, 16, MediaQuery.of(context).padding.bottom + 96),
                    itemCount: _requests.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final item = _requests[i];
                      final hasPrayed = _prayed.contains(i);
                      return _PrayerCard(
                        item: item,
                        hasPrayed: hasPrayed,
                        cardBg: cardBg,
                        textColor: textColor,
                        subColor: subColor,
                        onPray: () {
                          setState(() {
                            if (hasPrayed) {
                              _prayed.remove(i);
                              _requests[i] = item.copyWith(
                                  prayCount: item.prayCount - 1);
                            } else {
                              _prayed.add(i);
                              _requests[i] = item.copyWith(
                                  prayCount: item.prayCount + 1);
                            }
                          });
                        },
                      );
                    },
                  ),

                  // My Requests tab
                  Center(
                    child: Text(
                      'Your prayer requests appear here.',
                      style: TextStyle(color: subColor),
                    ),
                  ),

                  // Answered tab
                  Center(
                    child: Text(
                      'Answered prayers appear here.',
                      style: TextStyle(color: subColor),
                    ),
                  ),
                ],
              ),
            ),

            // FAB
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 80,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddPrayerRequestScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                child: const Icon(Icons.add, size: 28),
              ),
            ),

            // Bottom nav
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _BottomNav(
                isDark: isDark,
                padding: MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final _PrayerItem item;
  final bool hasPrayed;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final VoidCallback onPray;

  const _PrayerCard({
    required this.item,
    required this.hasPrayed,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.onPray,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
                child: Center(
                  child: Text(
                    item.initials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    item.timeAgo,
                    style: TextStyle(fontSize: 12, color: subColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Prayer body
          Text(
            item.body,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: textColor.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 14),

          // Footer row
          Divider(color: AppColors.primary.withOpacity(0.08), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.volunteer_activism,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${item.prayCount} ${item.prayLabel}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onPray,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: item.isPraise
                        ? (hasPrayed
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.12))
                        : (hasPrayed
                            ? AppColors.primary
                            : AppColors.primary),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: hasPrayed || !item.isPraise
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.isPraise
                            ? Icons.celebration
                            : Icons.back_hand_outlined,
                        color: item.isPraise && !hasPrayed
                            ? AppColors.primary
                            : Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.isPraise ? 'Amen' : 'Pray',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: item.isPraise && !hasPrayed
                              ? AppColors.primary
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final bool isDark;
  final double padding;

  const _BottomNav({required this.isDark, required this.padding});

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.black.withOpacity(0.95)
        : Colors.white.withOpacity(0.95);
    final borderColor = isDark
        ? AppColors.primary.withOpacity(0.1)
        : const Color(0xFFE2E8F0);

    return Container(
      padding: EdgeInsets.fromLTRB(24, 8, 24, padding + 8),
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
            active: false,
            onTap: () => Navigator.maybePop(context),
          ),
          _NavItem(
            icon: Icons.group,
            label: 'Groups',
            active: false,
            onTap: () {},
          ),
          // FAB placeholder space
          const SizedBox(width: 56),
          _NavItem(
            icon: Icons.volunteer_activism,
            label: 'Pray',
            active: true,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            active: false,
            onTap: () {},
          ),
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

class _PrayerItem {
  final String name;
  final String timeAgo;
  final String body;
  final int prayCount;
  final String prayLabel;
  final bool isPraise;
  final String initials;
  final Color color;

  const _PrayerItem({
    required this.name,
    required this.timeAgo,
    required this.body,
    required this.prayCount,
    required this.prayLabel,
    required this.isPraise,
    required this.initials,
    required this.color,
  });

  _PrayerItem copyWith({int? prayCount}) => _PrayerItem(
        name: name,
        timeAgo: timeAgo,
        body: body,
        prayCount: prayCount ?? this.prayCount,
        prayLabel: prayLabel,
        isPraise: isPraise,
        initials: initials,
        color: color,
      );
}
