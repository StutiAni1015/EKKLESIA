import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../widgets/app_bottom_bar.dart';
import 'add_prayer_request_screen.dart';
import 'bible_books_index_screen.dart';
import 'find_your_church_screen.dart';

class PrayerCommunityFeedScreen extends StatefulWidget {
  const PrayerCommunityFeedScreen({super.key});

  @override
  State<PrayerCommunityFeedScreen> createState() =>
      _PrayerCommunityFeedScreenState();
}

class _PrayerCommunityFeedScreenState extends State<PrayerCommunityFeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _requests = <_PrayerItem>[];

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
      bottomNavigationBar: const AppBottomBar(activeIndex: kTabCommunity),
      floatingActionButton: buildCenterFab(context, activeIndex: kTabCommunity),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                              icon: Icon(Icons.menu_book, color: AppColors.primary),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BibleBooksIndexScreen()),
                              ),
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
                  ValueListenableBuilder<bool>(
                    valueListenable: hasJoinedChurchNotifier,
                    builder: (context, hasJoined, _) {
                      if (!hasJoined) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.church_outlined,
                                    size: 56,
                                    color: AppColors.primary.withOpacity(0.35)),
                                const SizedBox(height: 16),
                                Text(
                                  'Join a community to see prayer requests',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Connect with a church and pray together with your brothers and sisters.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: subColor, height: 1.6, fontSize: 13),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const FindYourChurchScreen()),
                                  ),
                                  icon: const Icon(Icons.search, size: 18),
                                  label: const Text('Find a Church'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (_requests.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.volunteer_activism_outlined,
                                    size: 56,
                                    color: AppColors.primary.withOpacity(0.35)),
                                const SizedBox(height: 16),
                                Text(
                                  'No prayer requests yet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Be the first to add a prayer request for your community.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: subColor, height: 1.6, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(16, 16, 16,
                            MediaQuery.of(context).padding.bottom + 96),
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
                      );
                    },
                  ),

                  // My Requests tab
                  ValueListenableBuilder<List<UserPrayer>>(
                    valueListenable: myPrayerRequestsNotifier,
                    builder: (context, prayers, _) {
                      final mine = prayers
                          .where((p) => !p.isAnswered)
                          .toList()
                          .reversed
                          .toList();
                      if (mine.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.volunteer_activism_outlined,
                                    size: 48,
                                    color: AppColors.primary.withOpacity(0.4)),
                                const SizedBox(height: 12),
                                Text(
                                  'No prayer requests yet.\nTap + to share yours.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: subColor, height: 1.6),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                            16, 16, 16,
                            MediaQuery.of(context).padding.bottom + 96),
                        itemCount: mine.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final p = mine[i];
                          return _MyPrayerCard(
                            prayer: p,
                            cardBg: cardBg,
                            textColor: textColor,
                            subColor: subColor,
                            onMarkAnswered: () {
                              setState(() => p.isAnswered = true);
                              // Trigger notifier rebuild
                              myPrayerRequestsNotifier.value = [
                                ...myPrayerRequestsNotifier.value
                              ];
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Answered tab
                  ValueListenableBuilder<List<UserPrayer>>(
                    valueListenable: myPrayerRequestsNotifier,
                    builder: (context, prayers, _) {
                      final answered =
                          prayers.where((p) => p.isAnswered).toList().reversed.toList();
                      if (answered.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 48,
                                    color: AppColors.primary.withOpacity(0.4)),
                                const SizedBox(height: 12),
                                Text(
                                  'Answered prayers will appear here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: subColor, height: 1.6),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                            16, 16, 16,
                            MediaQuery.of(context).padding.bottom + 96),
                        itemCount: answered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final p = answered[i];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF22C55E)
                                      .withOpacity(0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF22C55E)
                                        .withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check,
                                      color: Color(0xFF22C55E), size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Answered Prayer',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF22C55E),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p.isAnonymous
                                            ? 'Anonymous request'
                                            : p.body,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: textColor.withOpacity(0.85),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
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

class _MyPrayerCard extends StatelessWidget {
  final UserPrayer prayer;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final VoidCallback onMarkAnswered;

  const _MyPrayerCard({
    required this.prayer,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.onMarkAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
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
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  prayer.isAnonymous ? 'Anonymous' : 'My Request',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _timeAgo(prayer.addedAt),
                style: TextStyle(fontSize: 11, color: subColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            prayer.body,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: textColor.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.primary.withOpacity(0.08), height: 1),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: onMarkAnswered,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFF22C55E).withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Color(0xFF22C55E), size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Mark as Answered',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
