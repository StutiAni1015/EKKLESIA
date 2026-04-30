import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
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

  void _showComposeOptions(BuildContext context, bool isDark, Color textColor,
      Color subColor, Color cardBg) {
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
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
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Create a Post',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 4),
            Text('Share with your church community',
                style: TextStyle(fontSize: 13, color: subColor)),
            const SizedBox(height: 20),
            _ComposeOptionTile(
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
            _ComposeOptionTile(
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
            _ComposeOptionTile(
              icon: Icons.event_outlined,
              color: const Color(0xFF0EA5E9),
              title: 'Event',
              subtitle: 'Announce a church event or gathering',
              onTap: () {
                Navigator.pop(context);
                _showEventSheet(
                    context, isDark, textColor, subColor, cardBg, borderColor);
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
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
                      borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Share a Bible Verse',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 14),
              TextField(
                controller: refCtrl,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Reference (e.g. John 3:16)',
                  hintStyle: TextStyle(color: subColor, fontSize: 13),
                  prefixIcon: Icon(Icons.bookmark_outline, color: subColor, size: 18),
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
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5)),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 14),
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
                        reference: refCtrl.text.trim().isEmpty
                            ? null
                            : refCtrl.text.trim(),
                      ),
                      ...communityFeedNotifier.value,
                    ];
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Bible verse shared!'),
                      backgroundColor: Color(0xFF8B5CF6),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: const Text('Share Verse',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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

    InputDecoration dec(String hint, IconData icon) => InputDecoration(
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
              borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
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
                      borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Announce an Event',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 14),
              TextField(
                  controller: titleCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration: dec('Event title *', Icons.title)),
              const SizedBox(height: 10),
              TextField(
                  controller: dateCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration:
                      dec('Date (e.g. Sun, May 4)', Icons.calendar_today)),
              const SizedBox(height: 10),
              TextField(
                  controller: timeCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration: dec('Time (e.g. 10:00 AM)', Icons.access_time)),
              const SizedBox(height: 10),
              TextField(
                  controller: locationCtrl,
                  style: TextStyle(fontSize: 14, color: textColor),
                  decoration:
                      dec('Location', Icons.location_on_outlined)),
              const SizedBox(height: 14),
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
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                                'Community',
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
                              icon: Icon(Icons.add_circle_outline, color: AppColors.primary, size: 26),
                              onPressed: () => _showComposeOptions(context, isDark, textColor, subColor, cardBg),
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

                      return ValueListenableBuilder<List<CommunityFeedItem>>(
                        valueListenable: communityFeedNotifier,
                        builder: (context, feed, _) {
                          if (_requests.isEmpty && feed.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.people_outline,
                                        size: 56,
                                        color: AppColors.primary.withOpacity(0.35)),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nothing posted yet',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap + to share a prayer, verse, or event with your community.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: subColor, height: 1.6, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Merge prayers + community feed, sorted by time
                          final prayerItems = _requests
                              .asMap()
                              .entries
                              .map((e) => _MergedItem.prayer(e.key, e.value))
                              .toList();
                          final feedItems =
                              feed.map((f) => _MergedItem.feed(f)).toList();
                          final merged = [...prayerItems, ...feedItems];
                          merged.sort((a, b) => b.postedAt.compareTo(a.postedAt));

                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(16, 16, 16,
                                MediaQuery.of(context).padding.bottom + 96),
                            itemCount: merged.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final m = merged[i];
                              if (m.prayerIndex != null) {
                                final item = _requests[m.prayerIndex!];
                                final hasPrayed = _prayed.contains(m.prayerIndex);
                                return _PrayerCard(
                                  item: item,
                                  hasPrayed: hasPrayed,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  subColor: subColor,
                                  onPray: () {
                                    setState(() {
                                      final idx = m.prayerIndex!;
                                      if (hasPrayed) {
                                        _prayed.remove(idx);
                                        _requests[idx] = item.copyWith(
                                            prayCount: item.prayCount - 1);
                                      } else {
                                        _prayed.add(idx);
                                        _requests[idx] = item.copyWith(
                                            prayCount: item.prayCount + 1);
                                      }
                                    });
                                  },
                                );
                              } else {
                                return _FeedItemCard(
                                  item: m.feedItem!,
                                  cardBg: cardBg,
                                  textColor: textColor,
                                  subColor: subColor,
                                  onPray: () {
                                    final updated = communityFeedNotifier.value.map((f) {
                                      if (f.id == m.feedItem!.id) {
                                        f.prayCount++;
                                      }
                                      return f;
                                    }).toList();
                                    communityFeedNotifier.value = [...updated];
                                  },
                                );
                              }
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

// ── Merged feed item (prayer OR community post) ───────────────────────────────

class _MergedItem {
  final int? prayerIndex;
  final CommunityFeedItem? feedItem;
  final DateTime postedAt;

  _MergedItem.prayer(this.prayerIndex, _PrayerItem item)
      : feedItem = null,
        postedAt = DateTime.now().subtract(
            Duration(minutes: item.timeAgo.contains('h')
                ? int.tryParse(item.timeAgo.replaceAll(RegExp(r'[^0-9]'), '')) != null
                    ? (int.parse(item.timeAgo.replaceAll(RegExp(r'[^0-9]'), '')) * 60)
                    : 0
                : int.tryParse(item.timeAgo.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0));

  _MergedItem.feed(CommunityFeedItem item)
      : prayerIndex = null,
        feedItem = item,
        postedAt = item.postedAt;
}

// ── Community feed item card ──────────────────────────────────────────────────

class _FeedItemCard extends StatelessWidget {
  final CommunityFeedItem item;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final VoidCallback onPray;

  const _FeedItemCard({
    required this.item,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.onPray,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isBibleVerse = item.type == FeedItemType.bibleVerse;
    final isEvent = item.type == FeedItemType.event;
    final accentColor = isBibleVerse
        ? const Color(0xFF8B5CF6)
        : isEvent
            ? const Color(0xFF0EA5E9)
            : AppColors.primary;
    final typeLabel = isBibleVerse
        ? 'Bible Verse'
        : isEvent
            ? 'Event'
            : 'Prayer';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.12)),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.authorColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(item.authorInitials,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: item.authorColor)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.authorName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Text(_timeAgo(item.postedAt),
                        style: TextStyle(fontSize: 11, color: subColor)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(typeLabel,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accentColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (isEvent) ...[
            // Event card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accentColor.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.eventTitle ?? '',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  if (item.eventDate != null && item.eventDate!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12, color: subColor),
                        const SizedBox(width: 4),
                        Text('${item.eventDate}',
                            style: TextStyle(fontSize: 12, color: subColor)),
                        if (item.eventTime != null &&
                            item.eventTime!.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Icon(Icons.schedule, size: 12, color: subColor),
                          const SizedBox(width: 4),
                          Text(item.eventTime!,
                              style: TextStyle(fontSize: 12, color: subColor)),
                        ],
                      ],
                    ),
                  ],
                  if (item.eventLocation != null &&
                      item.eventLocation!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 12, color: subColor),
                        const SizedBox(width: 4),
                        Text(item.eventLocation!,
                            style: TextStyle(fontSize: 12, color: subColor)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Verse or prayer body
            if (isBibleVerse && item.reference != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item.reference!,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: accentColor)),
              ),
            Text(
              isBibleVerse ? '"${item.content}"' : item.content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontStyle:
                    isBibleVerse ? FontStyle.italic : FontStyle.normal,
                color: textColor.withOpacity(0.85),
              ),
            ),
          ],

          if (!isEvent) ...[
            const SizedBox(height: 12),
            Divider(color: accentColor.withOpacity(0.08), height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.volunteer_activism,
                    color: accentColor, size: 16),
                const SizedBox(width: 6),
                Text('${item.prayCount} Praying',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: accentColor)),
                const Spacer(),
                GestureDetector(
                  onTap: onPray,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Pray',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Compose option tile ───────────────────────────────────────────────────────

class _ComposeOptionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ComposeOptionTile({
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
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B))),
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
