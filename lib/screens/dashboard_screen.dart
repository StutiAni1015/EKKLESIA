import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../widgets/app_bottom_bar.dart';
import 'plan_checklist_sheet.dart';
import 'prayer_community_feed_screen.dart';
import 'daily_bread_check_in_screen.dart';
import 'discover_plans_screen.dart';
import 'saved_sermons_screen.dart';
import 'my_spiritual_journal_screen.dart';
import 'member_notification_alert_screen.dart';
import 'church_events_list_screen.dart';
import 'church_search_results_screen.dart';
import 'church_committee_hub_screen.dart';
import 'book_library_screen.dart';
import 'location_currency_screen.dart';
// import 'global_prayer_map_screen.dart'; // temporarily disabled
import '../widgets/tap_scale.dart';
import '../service/api_service.dart';

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
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    // Ensure isPastor and church info are loaded even if the login-time fetch
    // failed (e.g. token was set but profile fetch threw silently).
    ApiService.fetchAndApplyProfile().catchError((_) {});
  }

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
          // Avatar (emoji or initials)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _nude, width: 2),
            ),
            child: ValueListenableBuilder<String?>(
              valueListenable: userProfileEmojiNotifier,
              builder: (context, emoji, _) {
                if (emoji != null) {
                  return CircleAvatar(
                    radius: 22,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : _nudeBg,
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 22)),
                  );
                }
                return ValueListenableBuilder<String>(
                  valueListenable: userNameNotifier,
                  builder: (context, name, _) {
                    final initials = name.trim().isEmpty
                        ? 'U'
                        : name
                            .trim()
                            .split(' ')
                            .where((w) => w.isNotEmpty)
                            .take(2)
                            .map((w) => w[0].toUpperCase())
                            .join();
                    return CircleAvatar(
                      radius: 22,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : _dustyRose,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
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
          Stack(
            children: [
              _IconBtn(
                icon: Icons.notifications_outlined,
                isDark: isDark,
                onTap: () {
                  setState(() => _unreadCount = 0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MemberNotificationAlertScreen(),
                    ),
                  );
                },
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          // Timer button
          _IconBtn(
            icon: Icons.timer_outlined,
            isDark: isDark,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Prayer timer coming soon!'),
                behavior: SnackBarBehavior.floating,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Daily Bread ───────────────────────────────────────────────
  Widget _buildDailyBread(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: TapScale(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const DailyBreadCheckInScreen()),
        ),
        borderRadius: BorderRadius.circular(16),
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
    return ValueListenableBuilder<bool>(
      valueListenable: todayPlanCompletedNotifier,
      builder: (context, todayDone, _) =>
          ValueListenableBuilder<BiblePlan?>(
        valueListenable: selectedPlanNotifier,
        builder: (context, plan, _) {
        // No plan selected yet — show a CTA
        if (plan == null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: TapScale(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DiscoverPlansScreen())),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? _sage.withAlpha(25) : _sageBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? _sage.withAlpha(40) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.menu_book_outlined,
                          color: _sageBar, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start a Bible Plan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              )),
                          const SizedBox(height: 4),
                          Text('Choose a reading plan and track your journey.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              )),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: _sageBar),
                  ],
                ),
              ),
            ),
          );
        }
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
                    Row(
                      children: [
                        Text(
                          'My Spiritual Journey',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (todayDone) ...[
                          const SizedBox(width: 6),
                          const Text('🎉', style: TextStyle(fontSize: 18)),
                        ],
                      ],
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
                  todayDone
                      ? '🎉 Today\'s reading complete! You\'re on a streak.'
                      : plan.daysCompleted == 0
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
                if (plan.todayReadings.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  TapScale(
                    onTap: todayDone
                        ? null
                        : () => _showReadingChecklist(context, plan, isDark),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: todayDone
                            ? _sageBar.withAlpha(25)
                            : isDark
                                ? _sage.withAlpha(38)
                                : Colors.white.withAlpha(153),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: todayDone
                              ? _sageBar.withAlpha(180)
                              : _sage.withAlpha(102),
                          width: todayDone ? 1.5 : 1,
                        ),
                      ),
                      child: todayDone
                          ? Row(
                              children: [
                                const Text('🎉',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'DAY COMPLETED',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: _sageBar,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Great work! See you tomorrow.',
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
                                const Icon(Icons.check_circle,
                                    size: 18, color: _sageBar),
                              ],
                            )
                          : Row(
                              children: [
                                const Icon(Icons.checklist_rounded,
                                    color: _sageBar, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'TODAY\'S READING CHECKLIST',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${plan.todayReadings.length} passage${plan.todayReadings.length == 1 ? '' : 's'} · ${plan.todayReadings.first}…',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? const Color(0xFFCBD5E1)
                                              : const Color(0xFF334155),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 12, color: _sageBar),
                              ],
                            ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TapScale(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DiscoverPlansScreen()),
                  ),
                  borderRadius: BorderRadius.circular(12),
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
    ));
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
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verse shared! 🙌'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
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
      // Global Prayer Map — temporarily disabled
      // _QuickAction(Icons.public, 'Global Prayer', _blueBg, _babyBlue,
      //     () => Navigator.push(context,
      //         MaterialPageRoute(builder: (_) => const GlobalPrayerMapScreen()))),
      _QuickAction(Icons.headset, 'Saved Sermons', _nudeBg, _nude,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SavedSermonsScreen()))),
      _QuickAction(Icons.edit_note, 'Journal', _sageBg, _sage,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MySpiritualJournalScreen()))),
      _QuickAction(Icons.search, 'Find a Church', _blueBg, _babyBlue,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChurchSearchResultsScreen()))),
      _QuickAction(Icons.how_to_vote, 'Committee Hub', _sageBg, _sage,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChurchCommitteeHubScreen()))),
      _QuickAction(Icons.auto_stories, 'Book Library', _nudeBg, _nude,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const BookLibraryScreen()))),
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
                .map((a) => TapScale(
                      onTap: a.onTap,
                      borderRadius: BorderRadius.circular(16),
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
    return ValueListenableBuilder<String>(
      valueListenable: userCountryNotifier,
      builder: (context, country, _) {
        final locationData = _locationEventsFor(country);
        final events = locationData.events;
        final locationLabel = locationData.label;
        final flagEmoji = locationData.flag;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
            // Location chip
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LocationCurrencyScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(flagEmoji,
                              style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 5),
                          Text(
                            locationLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit_location_alt_outlined,
                            size: 13,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: events.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 14),
                itemBuilder: (_, i) => TapScale(
                  borderRadius: BorderRadius.circular(20),
                  child: _EventCard(
                    event: events[i],
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static _LocationEvents _locationEventsFor(String country) {
    switch (country) {
      case 'Nigeria':
        return _LocationEvents(
          label: 'Lagos, Nigeria',
          flag: '🇳🇬',
          events: [
            _Event(
              date: 'SUN, APR 6 • 8:00 AM',
              title: 'Morning Glory Service',
              churchName: 'Redeemed Christian Church',
              city: 'Ikeja, Lagos',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF7B2D2D),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'WED, APR 9 • 6:30 PM',
              title: 'Midweek Prayer & Praise',
              churchName: 'Daystar Christian Centre',
              city: 'Victoria Island, Lagos',
              dateColor: _sage,
              gradientColors: [
                const Color(0xFF3D5A4E),
                const Color(0xFFB8C4B5)
              ],
              icon: Icons.volunteer_activism,
            ),
            _Event(
              date: 'SAT, APR 12 • 5:00 PM',
              title: 'Youth Gospel Concert',
              churchName: 'RCCG Throne Room',
              city: 'Lekki, Lagos',
              dateColor: _babyBlue,
              gradientColors: [
                const Color(0xFF2B4C6F),
                const Color(0xFFA4B1BA)
              ],
              icon: Icons.music_note,
            ),
          ],
        );
      case 'United Kingdom':
        return _LocationEvents(
          label: 'London, UK',
          flag: '🇬🇧',
          events: [
            _Event(
              date: 'SUN, APR 6 • 10:30 AM',
              title: 'Sunday Celebration',
              churchName: 'Hillsong London',
              city: 'Waterloo, London',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF4A3060),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'FRI, APR 11 • 7:00 PM',
              title: 'Alpha Night Course',
              churchName: 'Holy Trinity Brompton',
              city: 'Knightsbridge, London',
              dateColor: _sage,
              gradientColors: [
                const Color(0xFF1A3A5C),
                const Color(0xFFB8C4B5)
              ],
              icon: Icons.menu_book,
            ),
          ],
        );
      case 'Ghana':
        return _LocationEvents(
          label: 'Accra, Ghana',
          flag: '🇬🇭',
          events: [
            _Event(
              date: 'SUN, APR 6 • 9:00 AM',
              title: 'Dominion Sunday',
              churchName: 'Lighthouse Chapel Int\'l',
              city: 'Dansoman, Accra',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF6B4A10),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'SAT, APR 12 • 4:00 PM',
              title: 'Marriage Conference',
              churchName: 'Action Chapel Int\'l',
              city: 'Airport Res., Accra',
              dateColor: _sage,
              gradientColors: [
                const Color(0xFF1F4A2F),
                const Color(0xFFB8C4B5)
              ],
              icon: Icons.favorite,
            ),
          ],
        );
      case 'India':
        return _LocationEvents(
          label: 'Mumbai, India',
          flag: '🇮🇳',
          events: [
            _Event(
              date: 'SUN, APR 6 • 8:30 AM',
              title: 'Sunday Holy Mass',
              churchName: 'Mount Mary Basilica',
              city: 'Bandra, Mumbai',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF5C2A2A),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'SAT, APR 12 • 10:00 AM',
              title: 'Youth Fellowship',
              churchName: 'CSI Christ Church',
              city: 'Fort, Mumbai',
              dateColor: _babyBlue,
              gradientColors: [
                const Color(0xFF1E3A5F),
                const Color(0xFFA4B1BA)
              ],
              icon: Icons.people,
            ),
          ],
        );
      case 'Philippines':
        return _LocationEvents(
          label: 'Manila, Philippines',
          flag: '🇵🇭',
          events: [
            _Event(
              date: 'SUN, APR 6 • 9:00 AM',
              title: 'Victory Sunday Service',
              churchName: 'Victory Manila',
              city: 'BGC, Taguig',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF3D1C5C),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'FRI, APR 11 • 7:00 PM',
              title: 'Healing & Prayer Night',
              churchName: 'Jesus Is Lord Church',
              city: 'Pasig City',
              dateColor: _sage,
              gradientColors: [
                const Color(0xFF2D4F3A),
                const Color(0xFFB8C4B5)
              ],
              icon: Icons.volunteer_activism,
            ),
          ],
        );
      case 'Australia':
        return _LocationEvents(
          label: 'Sydney, Australia',
          flag: '🇦🇺',
          events: [
            _Event(
              date: 'SUN, APR 6 • 10:00 AM',
              title: 'Colour Women\'s Conference',
              churchName: 'Hillsong Church',
              city: 'Seven Hills, Sydney',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF4A2C6A),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'WED, APR 9 • 7:00 PM',
              title: 'Bible Study Night',
              churchName: 'C3 Church Sydney',
              city: 'Oxford Falls, Sydney',
              dateColor: _babyBlue,
              gradientColors: [
                const Color(0xFF1B3D5A),
                const Color(0xFFA4B1BA)
              ],
              icon: Icons.menu_book,
            ),
          ],
        );
      case 'Brazil':
        return _LocationEvents(
          label: 'São Paulo, Brazil',
          flag: '🇧🇷',
          events: [
            _Event(
              date: 'DOM, APR 6 • 9:30 AM',
              title: 'Culto de Domingo',
              churchName: 'Igreja Renascer em Cristo',
              city: 'Centro, São Paulo',
              dateColor: _sage,
              gradientColors: [
                const Color(0xFF1F4D2F),
                const Color(0xFFB8C4B5)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'SÁB, APR 12 • 6:00 PM',
              title: 'Noite de Louvor',
              churchName: 'Assembleia de Deus',
              city: 'Paulista, São Paulo',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF6B2D3A),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.music_note,
            ),
          ],
        );
      default: // United States + fallback
        return _LocationEvents(
          label: country == 'United States'
              ? 'New York, USA'
              : 'Nearby Churches',
          flag: country == 'United States' ? '🇺🇸' : '🌍',
          events: [
            _Event(
              date: 'SUN, APR 6 • 10:00 AM',
              title: 'Global Worship Night',
              churchName: 'Grace Community Church',
              city: 'Manhattan, New York',
              dateColor: _dustyRose,
              gradientColors: [
                const Color(0xFF6B4E3D),
                const Color(0xFFD7A49A)
              ],
              icon: Icons.church,
            ),
            _Event(
              date: 'WED, APR 9 • 7:00 PM',
              title: 'Youth Leadership Seminar',
              churchName: 'Brooklyn Tabernacle',
              city: 'Brooklyn, New York',
              dateColor: _sage,
              gradientColors: [
                const Color(0xFF3D5A4E),
                const Color(0xFFB8C4B5)
              ],
              icon: Icons.people,
            ),
            _Event(
              date: 'SAT, APR 12 • 3:00 PM',
              title: 'Community Outreach Day',
              churchName: 'Hillsong NYC',
              city: 'Midtown, New York',
              dateColor: _babyBlue,
              gradientColors: [
                const Color(0xFF1E3A5F),
                const Color(0xFFA4B1BA)
              ],
              icon: Icons.volunteer_activism,
            ),
          ],
        );
    }
  }

  void _showReadingChecklist(
      BuildContext context, BiblePlan? plan, bool isDark) {
    if (plan == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlanChecklistSheet(
        planTitle: plan.title,
        gradientStart: const Color(0xFF4A7C59),
        gradientEnd: const Color(0xFF2C5364),
        readings: plan.todayReadings,
        onComplete: () {
          selectedPlanNotifier.value = plan.copyWith(
            daysCompleted: plan.daysCompleted + 1,
          );
          todayPlanCompletedNotifier.value = true;
        },
      ),
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
    return TapScale(
      onTap: onTap,
      scale: 0.90,
      borderRadius: BorderRadius.circular(20),
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

class _LocationEvents {
  final String label;
  final String flag;
  final List<_Event> events;
  const _LocationEvents({
    required this.label,
    required this.flag,
    required this.events,
  });
}

class _Event {
  final String date;
  final String title;
  final String churchName;
  final String city;
  final Color dateColor;
  final List<Color> gradientColors;
  final IconData icon;
  const _Event({
    required this.date,
    required this.title,
    required this.churchName,
    required this.city,
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
                const SizedBox(height: 4),
                Text(
                  event.churchName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 13, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        event.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
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

