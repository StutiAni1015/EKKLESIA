import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';
import 'join_a_church_screen.dart';
import 'following_feed_screen.dart';
import 'bible_books_index_screen.dart';
import 'prayer_community_feed_screen.dart';
import 'prayer_heartbeat_screen.dart';
import 'church_events_list_screen.dart';
import 'member_notification_alert_screen.dart';
import 'member_facial_scan_screen.dart';
import 'worship_hub_screen.dart';
import 'church_plan_screen.dart';
import 'add_prayer_request_screen.dart';

// Dusty rose is the accent for this community screen
const _rose = Color(0xFFD7A49A);
const _roseLight = Color(0xFFF2E7E4);
const _nude = Color(0xFFE4C9B6);
const _nudeBg = Color(0xFFF8EEE7);

class MyChurchDailyScreen extends StatefulWidget {
  const MyChurchDailyScreen({super.key});

  @override
  State<MyChurchDailyScreen> createState() => _MyChurchDailyScreenState();
}

class _MyChurchDailyScreenState extends State<MyChurchDailyScreen> {
  bool _myChurchSelected = true;

  // Prayer request pray state
  final _praying = <int>{};
  final _prayCounts = [0, 0];

  // Testimony amen state
  final _amened = <int>{};
  final _amenCounts = [0, 0];

  void _showComposeSheet(BuildContext context, bool isDark, Color textColor,
      Color subColor, Color cardBg, Color borderColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Create a Post',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Share with your church community',
              style: TextStyle(fontSize: 13, color: subColor),
            ),
            const SizedBox(height: 20),
            _ComposeOption(
              icon: Icons.volunteer_activism_outlined,
              color: AppColors.primary,
              title: 'Prayer Request',
              subtitle: 'Ask the community to pray with you',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddPrayerRequestScreen()),
                );
              },
            ),
            const SizedBox(height: 10),
            _ComposeOption(
              icon: Icons.menu_book_outlined,
              color: const Color(0xFF8B5CF6),
              title: 'Bible Verse',
              subtitle: 'Share an encouraging scripture',
              onTap: () {
                Navigator.pop(context);
                _showBibleVerseSheet(context, isDark, textColor, subColor,
                    cardBg, borderColor);
              },
            ),
            const SizedBox(height: 10),
            _ComposeOption(
              icon: Icons.event_outlined,
              color: const Color(0xFF0EA5E9),
              title: 'Event',
              subtitle: 'Announce a church event or gathering',
              onTap: () {
                Navigator.pop(context);
                _showEventSheet(context, isDark, textColor, subColor, cardBg,
                    borderColor);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBibleVerseSheet(BuildContext context, bool isDark, Color textColor,
      Color subColor, Color cardBg, Color borderColor) {
    final verseCtrl = TextEditingController();
    final refCtrl = TextEditingController();
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Share a Bible Verse',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 16),
              TextField(
                controller: refCtrl,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Reference (e.g. John 3:16)',
                  hintStyle: TextStyle(color: subColor, fontSize: 13),
                  prefixIcon:
                      Icon(Icons.bookmark_outline, color: subColor, size: 18),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color(0xFF8B5CF6), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: verseCtrl,
                maxLines: 4,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Type or paste the verse text…',
                  hintStyle: TextStyle(color: subColor, fontSize: 13),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color(0xFF8B5CF6), width: 1.5)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final verse = verseCtrl.text.trim();
                    final ref = refCtrl.text.trim();
                    if (verse.isEmpty) return;
                    final name = userNameNotifier.value.trim().isEmpty
                        ? 'Member'
                        : userNameNotifier.value.trim();
                    final initials = name
                        .split(' ')
                        .where((w) => w.isNotEmpty)
                        .take(2)
                        .map((w) => w[0].toUpperCase())
                        .join();
                    communityFeedNotifier.value = [
                      CommunityFeedItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: FeedItemType.bibleVerse,
                        authorName: name,
                        authorInitials: initials,
                        authorColor: const Color(0xFF8B5CF6),
                        postedAt: DateTime.now(),
                        content: verse,
                        reference: ref.isEmpty ? null : ref,
                      ),
                      ...communityFeedNotifier.value,
                    ];
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Bible verse shared with community!'),
                      backgroundColor: Color(0xFF8B5CF6),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: const Text('Share Verse',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventSheet(BuildContext context, bool isDark, Color textColor,
      Color subColor, Color cardBg, Color borderColor) {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    InputDecoration _dec(String hint, IconData icon) => InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: subColor, fontSize: 13),
          prefixIcon: Icon(icon, color: subColor, size: 18),
          filled: true,
          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF0EA5E9), width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Announce an Event',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 16),
              TextField(
                  controller: titleCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration: _dec('Event title *', Icons.title)),
              const SizedBox(height: 10),
              TextField(
                  controller: dateCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration:
                      _dec('Date (e.g. Sun, May 4)', Icons.calendar_today)),
              const SizedBox(height: 10),
              TextField(
                  controller: timeCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration:
                      _dec('Time (e.g. 10:00 AM)', Icons.access_time)),
              const SizedBox(height: 10),
              TextField(
                  controller: locationCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration:
                      _dec('Location', Icons.location_on_outlined)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;
                    final name = userNameNotifier.value.trim().isEmpty
                        ? 'Member'
                        : userNameNotifier.value.trim();
                    final initials = name
                        .split(' ')
                        .where((w) => w.isNotEmpty)
                        .take(2)
                        .map((w) => w[0].toUpperCase())
                        .join();
                    communityFeedNotifier.value = [
                      CommunityFeedItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: FeedItemType.event,
                        authorName: name,
                        authorInitials: initials,
                        authorColor: const Color(0xFF0EA5E9),
                        postedAt: DateTime.now(),
                        content: locationCtrl.text.trim(),
                        eventTitle: title,
                        eventDate: dateCtrl.text.trim(),
                        eventTime: timeCtrl.text.trim(),
                        eventLocation: locationCtrl.text.trim(),
                      ),
                      ...communityFeedNotifier.value,
                    ];
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Event announced to community!'),
                      backgroundColor: Color(0xFF0EA5E9),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: const Text('Post Event',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final segBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Sticky header
                Container(
                  color: isDark
                      ? AppColors.backgroundDark.withOpacity(0.9)
                      : const Color(0xFFF8F6F6).withOpacity(0.9),
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Community',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: textColor,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showComposeSheet(context, isDark, textColor, subColor, cardBg, borderColor),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add,
                                      color: AppColors.primary, size: 22),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const MemberNotificationAlertScreen()),
                                ),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.notifications,
                                      color: textColor, size: 22),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Segment toggle
                      Container(
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: segBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _SegTab(
                              label: 'My Church',
                              active: _myChurchSelected,
                              onTap: () => setState(
                                  () => _myChurchSelected = true),
                            ),
                            _SegTab(
                              label: 'Following',
                              active: !_myChurchSelected,
                              onTap: () {
                                setState(() => _myChurchSelected = false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const FollowingFeedScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).padding.bottom + 90,
                    ),
                    children: [
                      // Verify Identity banner
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const MemberFacialScanScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFEBF0F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB6C9BB)
                                        .withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.face_retouching_natural,
                                    color: Color(0xFFB6C9BB),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Verify Your Membership',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      Text(
                                        'Complete facial scan to confirm identity',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Color(0xFFCBD5E1), size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ── Live banner + Worship Hub ──────────────────────
                      _LiveAndWorshipBanner(isDark: isDark, subColor: subColor),

                      // ── Church Plan banner ────────────────────────────────
                      _ChurchPlanBanner(isDark: isDark, subColor: subColor),

                      // Daily Blessing
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 16, 16, 0),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_rose, _nude],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _rose.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Decorative quote icon
                              Positioned(
                                top: -8,
                                right: -4,
                                child: Icon(
                                  Icons.format_quote,
                                  size: 72,
                                  color: Colors.white.withOpacity(0.12),
                                ),
                              ),

                              Column(
                                children: [
                                  const Text(
                                    'DAILY BLESSING',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    '"The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you; the Lord turn his face toward you and give you peace."',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '— Numbers 6:24-26',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Prayer Requests
                      const SizedBox(height: 28),
                      _SectionTitle(
                        title: 'Prayer Requests',
                        actionLabel: 'View More',
                        textColor: textColor,
                        onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const PrayerCommunityFeedScreen()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemCount: 2,
                          itemBuilder: (ctx, i) {
                            final names = [
                              'Sarah Miller',
                              'James Wilson'
                            ];
                            final initials = ['SM', 'JW'];
                            final texts = [
                              '"Please pray for my mother\'s upcoming surgery this Monday..."',
                              '"Seeking wisdom for a big career decision I need to make by Friday..."',
                            ];
                            final isPraying = _praying.contains(i);
                            return Container(
                              width: 272,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isPraying
                                    ? _rose.withOpacity(0.08)
                                    : cardBg,
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                  color: isPraying
                                      ? _rose.withOpacity(0.25)
                                      : borderColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor:
                                            _rose.withOpacity(0.15),
                                        child: Text(
                                          initials[i],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _rose,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        names[i],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Text(
                                      texts[i],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        height: 1.5,
                                        color: textColor.withOpacity(0.75),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_prayCounts[i]} Praying',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          color: subColor,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          if (isPraying) {
                                            _praying.remove(i);
                                            _prayCounts[i]--;
                                          } else {
                                            _praying.add(i);
                                            _prayCounts[i]++;
                                          }
                                        }),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5),
                                          decoration: BoxDecoration(
                                            color: isPraying
                                                ? _rose
                                                : cardBg,
                                            borderRadius:
                                                BorderRadius.circular(99),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.06),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 13,
                                                color: isPraying
                                                    ? Colors.white
                                                    : _rose,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "I'm Praying",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: isPraying
                                                      ? Colors.white
                                                      : _rose,
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
                          },
                        ),
                      ),

                      // Upcoming Events
                      const SizedBox(height: 28),
                      _SectionTitle(
                        title: 'Upcoming Events',
                        actionLabel: 'View All',
                        textColor: textColor,
                        onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const ChurchEventsListScreen()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ChurchEventsListScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_outlined,
                                    size: 40, color: subColor.withOpacity(0.35)),
                                const SizedBox(height: 10),
                                Text(
                                  'No Upcoming Events',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: textColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Events created by your church will appear here.',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 12, color: subColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // New Sermon
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Sermon',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF4A3728),
                                            Color(0xFF8B6654),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black
                                                .withOpacity(0.5),
                                          ],
                                          stops: const [0.4, 1.0],
                                        ),
                                      ),
                                    ),
                                    // Play button
                                    Center(
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: _rose,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: _rose
                                                  .withOpacity(0.4),
                                              blurRadius: 16,
                                              offset: const Offset(
                                                  0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    // Bottom labels
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              'Series: The Kingdom Within',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Living with Purpose & Peace',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Church-wide Bible Plan
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _rose.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _rose.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Church-wide Plan',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: _rose,
                                        ),
                                      ),
                                      Text(
                                        'Gospel of John in 21 Days',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Day 14',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _rose,
                                        ),
                                      ),
                                      Text(
                                        'OF 21',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Community Progress',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    '68% Read today',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: 0.68,
                                  minHeight: 8,
                                  backgroundColor:
                                      isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFE2E8F0),
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                          _rose),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Member avatars
                              Row(
                                children: [
                                  ...List.generate(
                                    4,
                                    (i) => Transform.translate(
                                      offset: Offset(-i * 8.0, 0),
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                [
                                              _rose,
                                              _nude,
                                              const Color(
                                                  0xFFB8C4B5),
                                              const Color(
                                                  0xFFA4B1BA),
                                            ][i].withOpacity(0.6),
                                            child: Text(
                                              ['SM', 'JW', 'LB', 'MP'][i],
                                              style: const TextStyle(
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (i != 2)
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                decoration:
                                                    BoxDecoration(
                                                  color: Colors.green,
                                                  shape:
                                                      BoxShape.circle,
                                                  border: Border.all(
                                                    color: isDark
                                                        ? AppColors
                                                            .backgroundDark
                                                        : Colors.white,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  size: 7,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: borderColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+12',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: subColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // New Testimonies
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Text(
                          'New Testimonies',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Testimony 1 (with image)
                      _TestimonyCard(
                        name: 'Sarah Miller',
                        initials: 'SM',
                        timeAgo: '2 hours ago',
                        text:
                            'God provided exactly when I needed it most! After three months of job searching, I finally received an offer today. Thank you for all your prayers, community!',
                        hasImage: true,
                        amened: _amened.contains(0),
                        amenCount: _amenCounts[0],
                        onAmen: () => setState(() {
                          if (_amened.contains(0)) {
                            _amened.remove(0);
                            _amenCounts[0]--;
                          } else {
                            _amened.add(0);
                            _amenCounts[0]++;
                          }
                        }),
                        isDark: isDark,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        cardBg: cardBg,
                      ),

                      // Music card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C2E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -8,
                                top: -8,
                                child: Icon(
                                  Icons.music_note,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'New Music',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Lyrics coming soon!'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'LYRICS TAB',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: _rose,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 14,
                                              color: _rose,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: _rose.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.play_circle_filled,
                                          size: 40,
                                          color: _rose,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Holy Presence (Live)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'New Covenant Worship',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Testimony 2 (no image)
                      _TestimonyCard(
                        name: 'James Wilson',
                        initials: 'JW',
                        timeAgo: '5 hours ago',
                        text:
                            'Blessed by the Sunday service message on forgiveness. Truly felt a weight lifted off my shoulders today.',
                        hasImage: false,
                        amened: _amened.contains(1),
                        amenCount: _amenCounts[1],
                        onAmen: () => setState(() {
                          if (_amened.contains(1)) {
                            _amened.remove(1);
                            _amenCounts[1]--;
                          } else {
                            _amened.add(1);
                            _amenCounts[1]++;
                          }
                        }),
                        isDark: isDark,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        cardBg: cardBg,
                      ),
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

// ─── Supporting Widgets ──────────────────────────────────────────

class _SegTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF334155)
                    : Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active ? _rose : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String actionLabel;
  final Color textColor;
  final VoidCallback onAction;

  const _SectionTitle({
    required this.title,
    required this.actionLabel,
    required this.textColor,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
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
            onTap: onAction,
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _rose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestimonyCard extends StatelessWidget {
  final String name;
  final String initials;
  final String timeAgo;
  final String text;
  final bool hasImage;
  final bool amened;
  final int amenCount;
  final VoidCallback onAmen;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final Color borderColor;
  final Color cardBg;

  const _TestimonyCard({
    required this.name,
    required this.initials,
    required this.timeAgo,
    required this.text,
    required this.hasImage,
    required this.amened,
    required this.amenCount,
    required this.onAmen,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.borderColor,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _rose.withOpacity(0.15),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _rose,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textColor.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),

            if (hasImage)
              Container(
                height: 160,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A6741), Color(0xFF8BA888)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.celebration,
                    size: 48,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onAmen,
                    child: Row(
                      children: [
                        Icon(
                          amened
                              ? Icons.volunteer_activism
                              : Icons.volunteer_activism_outlined,
                          size: 20,
                          color: amened ? _rose : subColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Amen ($amenCount)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: amened
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: amened ? _rose : subColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 20, color: subColor),
                      const SizedBox(width: 6),
                      Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: subColor,
                        ),
                      ),
                    ],
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

class _BottomNav extends StatelessWidget {
  final bool isDark;
  final double bottomPadding;
  final VoidCallback onHome;
  final VoidCallback onJoinChurch;

  const _BottomNav({
    required this.isDark,
    required this.bottomPadding,
    required this.onHome,
    required this.onJoinChurch,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.black.withOpacity(0.95)
        : Colors.white.withOpacity(0.95);
    final borderColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding + 8),
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
              onTap: onHome),
          _NavItem(
              icon: Icons.group,
              label: 'Community',
              active: true,
              onTap: onHome),
          // Center elevated FAB
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BibleBooksIndexScreen(),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _rose,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _rose.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.menu_book, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 2),
                Text(
                  'BIBLE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          _NavItem(
              icon: Icons.volunteer_activism_outlined,
              label: 'Prayer',
              active: false,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PrayerHeartbeatScreen()),
              )),
          _NavItem(
              icon: Icons.person,
              label: 'Profile',
              active: false,
              onTap: onHome),
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
    final color = active ? _rose : const Color(0xFF94A3B8);
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
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


// ── Live banner + Worship Hub shortcut ───────────────────────────────────────

class _LiveAndWorshipBanner extends StatefulWidget {
  final bool isDark;
  final Color subColor;
  const _LiveAndWorshipBanner({required this.isDark, required this.subColor});
  @override
  State<_LiveAndWorshipBanner> createState() => _LiveAndWorshipBannerState();
}

class _LiveAndWorshipBannerState extends State<_LiveAndWorshipBanner> {
  bool _isLive = false;
  String _streamUrl = "";
  String _liveTitle = "";
  bool _showWorshipHub = false;
  String _memberRole = "member";
  bool _isGoingLive = false;

  static const _worshipRoles = {"worship_leader", "media_team", "choir", "secretary"};

  @override
  void initState() {
    super.initState();
    _checkLiveAndRole();
  }

  Future<void> _checkLiveAndRole() async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    try {
      final status = await ApiService.getLiveStatus(churchId);
      if (mounted) setState(() {
        _isLive    = status["isLive"] as bool? ?? false;
        _streamUrl = status["streamUrl"] as String? ?? "";
        _liveTitle = status["liveTitle"] as String? ?? "";
      });
    } catch (_) {}
    // Determine worship role
    try {
      if (churchId.isNotEmpty) {
        final members = await ApiService.getChurchMembers(churchId);
        final me = members.cast<Map<String, dynamic>>().firstWhere(
          (m) => m["_id"] == authUserIdNotifier.value,
          orElse: () => {},
        );
        final role = me["role"] as String? ?? "member";
        userMemberRoleNotifier.value = role;
        if (mounted) setState(() {
          _memberRole    = role;
          _showWorshipHub = _worshipRoles.contains(role) || isPastorNotifier.value;
        });
      }
    } catch (_) {}
  }

  Future<void> _showGoLiveDialog() async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    final urlCtrl = TextEditingController();
    final titleCtrl = TextEditingController(text: 'Sunday Service');
    final isDark = widget.isDark;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.live_tv, color: Color(0xFFEF4444), size: 22),
            SizedBox(width: 8),
            Text('Go Live', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paste your YouTube Live or streaming URL below. Members will be able to watch inside the app.',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                hintText: 'Service title',
                prefixIcon: const Icon(Icons.title, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: urlCtrl,
              decoration: InputDecoration(
                hintText: 'https://youtube.com/watch?v=...',
                prefixIcon: const Icon(Icons.link, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Go Live'),
          ),
        ],
      ),
    );
    if (result != true) return;
    final url = urlCtrl.text.trim();
    final title = titleCtrl.text.trim();
    if (url.isEmpty) return;
    setState(() => _isGoingLive = true);
    try {
      await ApiService.goLive(churchId, url, title);
      if (mounted) setState(() {
        _isLive = true;
        _streamUrl = url;
        _liveTitle = title;
      });
    } catch (_) {} finally {
      if (mounted) setState(() => _isGoingLive = false);
    }
  }

  Future<void> _endLive() async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End Live Stream?'),
        content: const Text('Members will no longer be able to join the live service.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End Live', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.endLive(churchId);
      if (mounted) setState(() { _isLive = false; _streamUrl = ''; _liveTitle = ''; });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = widget.isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = widget.isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = widget.isDark ? Colors.white : const Color(0xFF1E293B);
    final churchId = myChurchIdNotifier.value;
    final churchName = myChurchNotifier.value?.name ?? "";
    final isPastor = isPastorNotifier.value;

    if (!_isLive && !_showWorshipHub && !isPastor) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          // LIVE banner
          if (_isLive && _streamUrl.isNotEmpty)
            GestureDetector(
              onTap: () async {
                final uri = Uri.tryParse(_streamUrl);
                if (uri != null) {
                  // Open stream in-app so members never leave Ekklesia
                  final launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
                  if (!launched && mounted) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text("LIVE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_liveTitle.isEmpty ? "Live Service" : _liveTitle,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text("Your church is live now — tap to join", style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_circle_outline, color: Colors.white, size: 22),
                  ],
                ),
              ),
            ),

          // Worship Hub shortcut
          if (_showWorshipHub && churchId != null)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorshipHubScreen(
                    churchId: churchId,
                    churchName: churchName,
                    memberRole: _memberRole,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC4899).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.queue_music_outlined, color: Color(0xFFEC4899), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Worship Hub",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                          Text("Lyrics, slides & media files", style: TextStyle(fontSize: 11, color: widget.subColor)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 18),
                  ],
                ),
              ),
            ),

          // Go Live button (pastor only, when not live)
          if (isPastor && !_isLive) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _isGoingLive ? null : _showGoLiveDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: _isGoingLive
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Color(0xFFEF4444)))
                          : const Icon(Icons.live_tv, color: Color(0xFFEF4444), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Live Stream",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textColor)),
                          Text("Share a YouTube or streaming link with your church",
                              style: TextStyle(
                                  fontSize: 11, color: widget.subColor)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: Color(0xFFEF4444), size: 18),
                  ],
                ),
              ),
            ),
          ],

          // End Live button (pastor only, when live)
          if (isPastor && _isLive)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GestureDetector(
                onTap: _endLive,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'End Live Stream',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Church Plan quick-access banner ──────────────────────────────────────────

class _ChurchPlanBanner extends StatefulWidget {
  final bool isDark;
  final Color subColor;
  const _ChurchPlanBanner({required this.isDark, required this.subColor});

  @override
  State<_ChurchPlanBanner> createState() => _ChurchPlanBannerState();
}

class _ChurchPlanBannerState extends State<_ChurchPlanBanner> {
  Map<String, dynamic>? _plan;
  List<int> _completedDays = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    try {
      final result = await ApiService.getChurchPlan(churchId);
      if (mounted) {
        setState(() {
          _plan = result['plan'] as Map<String, dynamic>?;
          final raw = result['completedDays'] as List<dynamic>? ?? [];
          _completedDays = raw.map((e) => (e as num).toInt()).toList();
          _loaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _plan == null) return const SizedBox.shrink();

    final isDark = widget.isDark;
    final total = (_plan!['days'] as List<dynamic>).length;
    final completed = _completedDays.length;
    final pct = total > 0 ? completed / total : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GestureDetector(
        onTap: () {
          final churchId = myChurchIdNotifier.value;
          final churchName = myChurchNotifier.value?.name ?? 'My Church';
          if (churchId == null) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChurchPlanScreen(
                churchId: churchId,
                churchName: churchName,
              ),
            ),
          ).then((_) => _fetch()); // refresh after returning
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_book,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Church Reading Plan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          _plan!['title'] as String? ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 11, color: widget.subColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$completed/$total',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right,
                      color: widget.subColor, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 5,
                  backgroundColor: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$completed of $total days completed',
                style: TextStyle(fontSize: 10, color: widget.subColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Compose option tile ───────────────────────────────────────────────────────

class _ComposeOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ComposeOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E293B))),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
