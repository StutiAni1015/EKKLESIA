import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../widgets/app_bottom_bar.dart';
import 'prayer_community_feed_screen.dart';
import 'my_giving_dashboard_screen.dart';
import 'daily_bread_check_in_screen.dart';
import 'discover_plans_screen.dart';
import 'saved_sermons_screen.dart';
import 'my_spiritual_journal_screen.dart';
import 'member_notification_alert_screen.dart';
import 'church_events_list_screen.dart';
import 'church_search_results_screen.dart';
import 'treasury_details_screen.dart';
import 'church_committee_hub_screen.dart';

// ─── Palette ────────────────────────────────────────────────────
const _bgWarm = Color(0xFFFCF9F7);
const _nude = Color(0xFFE4C9B6);
const _dustyRose = Color(0xFFD7A49A);
const _sage = Color(0xFFB8C4B5);
const _babyBlue = Color(0xFFA4B1BA);
const _sageBg = Color(0xFFF0F2EE);
const _nudeBg = Color(0xFFF8EEE7);
const _roseBg = Color(0xFFF2E7E4);
const _blueBg = Color(0xFFEBF0F3);
const _navBg = Color(0xFFFCF9F7);
const _sageBar = Color(0xFFB8C4B5);
const _sageTrack = Color(0xFFE1E6E0);
const _iconBg = Color(0xFFEBF0F3);

class DashboardScreen extends StatefulWidget {
  final String userName;
  const DashboardScreen({super.key, this.userName = 'Friend'});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : _bgWarm;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              _buildDailyBread(isDark),
              _buildSpiritualJourney(isDark),
              _buildDailyVerseCard(),
              _buildQuickActions(isDark),
              _buildUpcomingEvents(isDark),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomBar(activeIndex: kTabHome),
      floatingActionButton: buildCenterFab(context),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }

  // ─── Header ────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          // Avatar / Logo
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _nude, width: 2),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFCBD5E1),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WELCOME BACK,',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 1),
                ValueListenableBuilder<String>(
                  valueListenable: userNameNotifier,
                  builder: (context, name, _) => Text(
                    name.isEmpty ? 'Friend' : name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Notification button
          _IconBtn(
            icon: Icons.notifications_outlined,
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const MemberNotificationAlertScreen()),
            ),
          ),
          const SizedBox(width: 8),
          // Timer button
          _IconBtn(
            icon: Icons.timer_outlined,
            isDark: isDark,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ─── Daily Bread ───────────────────────────────────────────────
  Widget _buildDailyBread(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const DailyBreadCheckInScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? _nude.withAlpha(25) : _nudeBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _nude,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Bread',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Your morning devotion is ready',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFFCBD5E1), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Spiritual Journey ────────────────────────────────────────
  Widget _buildSpiritualJourney(bool isDark) {
    return ValueListenableBuilder<BiblePlan>(
      valueListenable: selectedPlanNotifier,
      builder: (context, plan, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? _sage.withAlpha(25) : _sageBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Spiritual Journey',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF334155)
                            : Colors.white.withAlpha(153),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        plan.progressLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        plan.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      plan.dayLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: plan.progress,
                    minHeight: 10,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : _sageTrack,
                    valueColor: const AlwaysStoppedAnimation(_sageBar),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  plan.daysCompleted == 0
                      ? '"Every journey begins with the first step."'
                      : '"You\'re doing great! Keep going."',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                if (plan.todayReading.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? _sage.withAlpha(38)
                          : Colors.white.withAlpha(153),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _sage.withAlpha(102),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book,
                            color: _sageBar, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TODAY\'S READING',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                plan.todayReading,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFFCBD5E1)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DiscoverPlansScreen()),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _sage.withAlpha(102),
                        width: 2,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, color: _sage, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ADD NEW PLAN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Color(0xFF64748B),
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
      },
    );
  }

  // ─── Daily Verse Card ─────────────────────────────────────────
  Widget _buildDailyVerseCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient (stands in for image)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A7C59), Color(0xFF2C5364)],
                  ),
                ),
              ),
              // Bottom overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x99000000)],
                    stops: [0.3, 1.0],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Verse badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'DAILY VERSE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '"For I know the plans I have for you," declares the Lord, "plans to prosper you and not to harm you..."',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Jeremiah 29:11',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _babyBlue,
                      ),
                    ),
                  ],
                ),
              ),
              // Share button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Quick Actions ────────────────────────────────────────────
  Widget _buildQuickActions(bool isDark) {
    final actions = [
      _QuickAction(Icons.favorite, 'Prayer Requests', _roseBg, _dustyRose,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PrayerCommunityFeedScreen()))),
      _QuickAction(Icons.featured_play_list, 'My Giving', _blueBg, _babyBlue,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MyGivingDashboardScreen()))),
      _QuickAction(Icons.headset, 'Saved Sermons', _nudeBg, _nude,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SavedSermonsScreen()))),
      _QuickAction(Icons.edit_note, 'Journal', _sageBg, _sage,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MySpiritualJournalScreen()))),
      _QuickAction(Icons.search, 'Find a Church', _blueBg, _babyBlue,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChurchSearchResultsScreen()))),
      _QuickAction(Icons.account_balance, 'Treasury', _nudeBg, _nude,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TreasuryDetailsScreen()))),
      _QuickAction(Icons.how_to_vote, 'Committee Hub', _sageBg, _sage,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChurchCommitteeHubScreen()))),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: actions
                .map((a) => GestureDetector(
                      onTap: a.onTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? a.bg.withAlpha(38) : a.bg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(a.icon, color: a.iconColor, size: 30),
                            const SizedBox(height: 10),
                            Text(
                              a.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── Upcoming Events ─────────────────────────────────────────
  Widget _buildUpcomingEvents(bool isDark) {
    final events = [
      _Event(
        date: 'AUG 24 • 6:00 PM',
        title: 'Global Worship Night',
        location: 'Main Sanctuary',
        dateColor: _dustyRose,
        gradientColors: [const Color(0xFF6B4E3D), const Color(0xFFD7A49A)],
        icon: Icons.church,
      ),
      _Event(
        date: 'SEPT 02 • 10:00 AM',
        title: 'Youth Leadership Seminar',
        location: 'Community Hall',
        dateColor: _sage,
        gradientColors: [const Color(0xFF3D5A4E), const Color(0xFFB8C4B5)],
        icon: Icons.people,
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'UPCOMING EVENTS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Color(0xFF94A3B8),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChurchEventsListScreen()),
                ),
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (_, i) => _EventCard(
              event: events[i],
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }

}

// ─── Helper widgets ───────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _IconBtn(
      {required this.icon, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? const Color(0xFF1E293B) : _iconBg,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF475569),
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color bg;
  final Color iconColor;
  final VoidCallback? onTap;
  const _QuickAction(this.icon, this.label, this.bg, this.iconColor,
      [this.onTap]);
}

class _Event {
  final String date;
  final String title;
  final String location;
  final Color dateColor;
  final List<Color> gradientColors;
  final IconData icon;
  const _Event({
    required this.date,
    required this.title,
    required this.location,
    required this.dateColor,
    required this.gradientColors,
    required this.icon,
  });
}

class _EventCard extends StatelessWidget {
  final _Event event;
  final bool isDark;

  const _EventCard({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: event.gradientColors,
              ),
            ),
            child: Center(
              child: Icon(event.icon,
                  color: Colors.white.withAlpha(76), size: 52),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.date,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: event.dateColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
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

