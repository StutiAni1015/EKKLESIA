import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'sermon_player_screen.dart';

const _sage = Color(0xFFB2B8A3);
const _nude = Color(0xFFE4C9B6);
const _dustyRose = Color(0xFFD7A49A);
const _babyBlue = Color(0xFFA4B1BA);

class FollowingFeedScreen extends StatefulWidget {
  const FollowingFeedScreen({super.key});

  @override
  State<FollowingFeedScreen> createState() => _FollowingFeedScreenState();
}

class _FollowingFeedScreenState extends State<FollowingFeedScreen> {
  bool _myChurch = false; // Following tab is active by default
  bool _amened = false;
  int _amenCount = 42;
  bool _verseAmened = false;
  int _verseAmenCount = 128;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.backgroundDark : const Color(0xFFE1DAD3);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE4C9B6);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;

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
                      : const Color(0xFFE1DAD3).withOpacity(0.9),
                  child: Column(
                    children: [
                      // Title row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 32),
                            Expanded(
                              child: Text(
                                'Community',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Icon(Icons.notifications,
                                    color: textColor, size: 26),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Search bar
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(99),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: TextField(
                            style:
                                TextStyle(fontSize: 14, color: textColor),
                            decoration: InputDecoration(
                              hintText:
                                  'Search churches or communities...',
                              hintStyle: TextStyle(
                                  color: subColor, fontSize: 13),
                              prefixIcon:
                                  Icon(Icons.search, color: subColor),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),

                      // Tabs
                      Row(
                        children: [
                          _Tab(
                            label: 'My Church',
                            active: _myChurch,
                            onTap: () {
                              setState(() => _myChurch = true);
                              Navigator.maybePop(context);
                            },
                          ),
                          _Tab(
                            label: 'Following',
                            active: !_myChurch,
                            onTap: () =>
                                setState(() => _myChurch = false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 90,
                    ),
                    children: [
                      // Live Now banner
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    child: const Icon(Icons.church,
                                        color: Colors.white, size: 24),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'LIVE',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'HAPPENING NOW',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Sunday Service Live',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Grace Community Church',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  'Join',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Latest Sermons
                      _SectionHeader(
                        title: 'LATEST SERMONS',
                        actionLabel: 'See All',
                        textColor: textColor,
                        onAction: () {},
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemCount: 2,
                          itemBuilder: (ctx, i) {
                            final titles = [
                              'The Power of Stillness',
                              'Walking in Faith'
                            ];
                            final subs = [
                              "St. Paul's Ministry • 2 days ago",
                              'City Hope Church • 4 days ago'
                            ];
                            final durations = ['42:15', '38:40'];
                            final gradients = [
                              [
                                const Color(0xFF4A3728),
                                const Color(0xFF8B6654)
                              ],
                              [
                                const Color(0xFF3D5A4E),
                                const Color(0xFF8BA888)
                              ],
                            ];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SermonPlayerScreen(
                                    title: titles[i],
                                    pastor: subs[i],
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: 240,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      child: Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end:
                                                      Alignment.bottomRight,
                                                  colors: gradients[i]
                                                      .map((c) => c as Color)
                                                      .toList(),
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.play_circle_outline,
                                                  size: 40,
                                                  color: Colors.white
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        4),
                                              ),
                                              child: Text(
                                                durations[i],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      titles[i],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      subs[i],
                                      style: TextStyle(
                                          fontSize: 11, color: subColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Worship Music
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _sage.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: _sage.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'NEW WORSHIP MUSIC',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: textColor,
                                    ),
                                  ),
                                  Icon(Icons.library_music,
                                      color: _sage, size: 22),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _MusicTrack(
                                title: 'Oceans (Where Feet May Fail)',
                                artist: 'Hillsong United • New Single',
                                bgColor: _nude,
                                textColor: textColor,
                                subColor: subColor,
                                cardBg: cardBg,
                              ),
                              const SizedBox(height: 10),
                              _MusicTrack(
                                title: 'Morning Praise (Live)',
                                artist: 'Bethel Music • Album',
                                bgColor: _babyBlue,
                                textColor: textColor,
                                subColor: subColor,
                                cardBg: cardBg,
                                playing: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Posters & Events
                      _SectionHeader(
                        title: 'POSTERS & EVENTS',
                        actionLabel: '',
                        textColor: textColor,
                        onAction: () {},
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _PosterCard(
                                label: 'Youth Rally',
                                date: 'Aug 15 • 7:00 PM',
                                gradientColors: const [
                                  Color(0xFF6B4E3D),
                                  Color(0xFFD7A49A),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PosterCard(
                                label: 'Couples Retreat',
                                date: 'Sep 2-4 • Mountain Resort',
                                gradientColors: const [
                                  Color(0xFF3D5A4E),
                                  Color(0xFFB8C4B5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Latest Updates header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Text(
                          'LATEST UPDATES',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Official News card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _dustyRose.withOpacity(0.08),
                              border: Border.all(
                                color: _dustyRose.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: _dustyRose,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'NEWS • ST. JUDE CATHEDRAL',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(Icons.campaign,
                                          color: Colors.white,
                                          size: 16),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Weekly Food Drive',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Join us this Saturday as we partner with local communities for our monthly outreach program.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: subColor,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: const [
                                          Text(
                                            'Join Event',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Icon(Icons.chevron_right,
                                              color: AppColors.primary,
                                              size: 16),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Testimony post (David Chen)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 12),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              _nude.withOpacity(0.5),
                                          child: Text(
                                            'DC',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'David Chen',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '2 hours ago • ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: subColor),
                                                ),
                                                const Text(
                                                  'Testimony',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: _dustyRose,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'God is so good! After months of searching, I finally found a job that aligns perfectly with my skills and values. Thank you all for the prayers during the fast.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.6,
                                        color: textColor.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Image placeholder
                              Container(
                                height: 180,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF4A6741),
                                      Color(0xFF8BA888),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.celebration,
                                    size: 48,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _amened = !_amened;
                                        _amenCount +=
                                            _amened ? 1 : -1;
                                      }),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _amened
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 20,
                                            color: _amened
                                                ? AppColors.primary
                                                : subColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Amen ($_amenCount)',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: _amened
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: _amened
                                                  ? AppColors.primary
                                                  : subColor,
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
                                          '8',
                                          style: TextStyle(
                                              fontSize: 14, color: subColor),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(Icons.share_outlined,
                                        size: 22, color: subColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Verse of the day card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _babyBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _babyBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: _dustyRose,
                                          child: const Text(
                                            'SM',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Sarah Miller • Grace Temple',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: subColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '"For I know the plans I have for you," declares the Lord, "plans to prosper you and not to harm you, plans to give you hope and a future."',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Jeremiah 29:11',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  border: Border(
                                    top: BorderSide(
                                        color: _babyBlue.withOpacity(0.3)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _verseAmened = !_verseAmened;
                                        _verseAmenCount +=
                                            _verseAmened ? 1 : -1;
                                      }),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _verseAmened
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 18,
                                            color: _verseAmened
                                                ? AppColors.primary
                                                : subColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$_verseAmenCount',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: subColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Row(
                                      children: [
                                        Icon(Icons.chat_bubble_outline,
                                            size: 18, color: subColor),
                                        const SizedBox(width: 4),
                                        Text('14',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: subColor)),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Text(
                                      'SHARE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom nav
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _BottomNav(
                isDark: isDark,
                bottomPadding: MediaQuery.of(context).padding.bottom,
                onHome: () => Navigator.maybePop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Supporting widgets ──────────────────────────────────────────

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active
                  ? AppColors.primary
                  : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final Color textColor;
  final VoidCallback onAction;

  const _SectionHeader({
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
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ),
          if (actionLabel.isNotEmpty)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MusicTrack extends StatelessWidget {
  final String title;
  final String artist;
  final Color bgColor;
  final Color textColor;
  final Color subColor;
  final Color cardBg;
  final bool playing;

  const _MusicTrack({
    required this.title,
    required this.artist,
    required this.bgColor,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    this.playing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Icon(
                Icons.music_note,
                color: Colors.white.withOpacity(0.8),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  artist,
                  style: TextStyle(fontSize: 11, color: subColor),
                ),
              ],
            ),
          ),
          Icon(
            playing ? Icons.play_arrow : Icons.play_arrow_outlined,
            color: AppColors.primary,
            size: 26,
          ),
        ],
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  final String label;
  final String date;
  final List<Color> gradientColors;

  const _PosterCard({
    required this.label,
    required this.date,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.event,
                  size: 48,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withOpacity(0.8),
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
        ? const Color(0xFF334155)
        : const Color(0xFFE4C9B6);

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
              onTap: () {}),
          // Center elevated FAB
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
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
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          _NavItem(
              icon: Icons.volunteer_activism_outlined,
              label: 'Prayer',
              active: false,
              onTap: () {}),
          _NavItem(
              icon: Icons.person,
              label: 'Profile',
              active: false,
              onTap: () {}),
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
    final color =
        active ? AppColors.primary : const Color(0xFF94A3B8);
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
