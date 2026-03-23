import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'sermon_player_screen.dart';

class SavedSermonsScreen extends StatefulWidget {
  const SavedSermonsScreen({super.key});

  @override
  State<SavedSermonsScreen> createState() => _SavedSermonsScreenState();
}

class _SavedSermonsScreenState extends State<SavedSermonsScreen> {
  final _searchCtrl = TextEditingController();

  static const _recentDownloads = [
    _RecentSermon(
      title: 'Finding Peace in Chaos',
      pastor: 'Pastor Sarah Jenkins',
      duration: '42:15',
      gradientStart: Color(0xFF4A6741),
      gradientEnd: Color(0xFF8BA888),
    ),
    _RecentSermon(
      title: 'Grace Abounds Always',
      pastor: 'Dr. Michael Chen',
      duration: '38:00',
      gradientStart: Color(0xFF6B7FD4),
      gradientEnd: Color(0xFF9B8BBF),
    ),
    _RecentSermon(
      title: 'The Quiet Way of Love',
      pastor: 'Rev. Anna Scott',
      duration: '45:20',
      gradientStart: Color(0xFFDCAE96),
      gradientEnd: Color(0xFFB2C2A3),
    ),
  ];

  static const _topics = [
    _Topic('Faith', Icons.auto_awesome, Color(0xFFB2C2A3), Color(0xFF6B8F71)),
    _Topic('Love', Icons.favorite, Color(0xFFDCAE96), Color(0xFFA0522D)),
    _Topic('Marriage', Icons.family_restroom, Color(0xFFF5E6DA), Color(0xFFEC5B13)),
    _Topic('Purpose', Icons.explore, Color(0xFFB9D1EA), Color(0xFF4A7BA0)),
  ];

  static const _allMessages = [
    _SavedSermon(
      title: 'New Beginnings: Walking in Hope',
      pastor: 'Pastor David Williams',
      date: 'Oct 12, 2023',
      duration: '52m',
      gradientStart: Color(0xFFEC5B13),
      gradientEnd: Color(0xFFD4966B),
    ),
    _SavedSermon(
      title: 'The Power of Forgiveness',
      pastor: 'Elder James Thompson',
      date: 'Sep 28, 2023',
      duration: '45m',
      gradientStart: Color(0xFF4A6741),
      gradientEnd: Color(0xFF8BA888),
    ),
    _SavedSermon(
      title: 'Stepping Into Your Destiny',
      pastor: 'Rev. Linda Carter',
      date: 'Aug 15, 2023',
      duration: '39m',
      gradientStart: Color(0xFF6B7FD4),
      gradientEnd: Color(0xFF9B8BBF),
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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  color: isDark
                      ? AppColors.backgroundDark.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Saved Sermons',
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
                        icon: Icon(Icons.more_vert, color: textColor),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                        0, 0, 0, MediaQuery.of(context).padding.bottom + 80),
                    children: [
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _searchCtrl,
                          style: TextStyle(fontSize: 14, color: textColor),
                          decoration: InputDecoration(
                            hintText:
                                'Search series, preachers, or topics...',
                            hintStyle: TextStyle(
                                color: subColor, fontSize: 14),
                            prefixIcon:
                                Icon(Icons.search, color: subColor),
                            filled: true,
                            fillColor: cardBg,
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

                      // Recent Downloads header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Downloads',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'VIEW ALL',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Recent Downloads carousel
                      SizedBox(
                        height: 152,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          itemCount: _recentDownloads.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, i) {
                            final s = _recentDownloads[i];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SermonPlayerScreen(
                                    title: s.title,
                                    pastor: s.pastor,
                                  ),
                                ),
                              ),
                            child: SizedBox(
                              width: 180,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin:
                                                    Alignment.topLeft,
                                                end:
                                                    Alignment.bottomRight,
                                                colors: [
                                                  s.gradientStart,
                                                  s.gradientEnd,
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.play_circle_filled,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                size: 36,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 6,
                                        right: 6,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            s.duration,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    s.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    s.pastor,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                        ),
                      ),

                      // Browse by Topic
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text(
                          'Browse by Topic',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.8,
                          children: _topics.map((t) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                decoration: BoxDecoration(
                                  color: t.bgColor.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: t.bgColor.withOpacity(0.4),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(t.icon,
                                        color: t.iconColor, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      t.label,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // All Saved Messages
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text(
                          'All Saved Messages',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Column(
                          children: _allMessages.map((m) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12),
                              child: _SermonRow(
                                sermon: m,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textColor: textColor,
                                subColor: subColor,
                              ),
                            );
                          }).toList(),
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

class _SermonRow extends StatelessWidget {
  final _SavedSermon sermon;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _SermonRow({
    required this.sermon,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [sermon.gradientStart, sermon.gradientEnd],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white.withOpacity(0.5),
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sermon.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sermon.pastor,
                  style: TextStyle(fontSize: 11, color: subColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: subColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      sermon.date,
                      style: TextStyle(
                        fontSize: 10,
                        color: subColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.schedule, color: subColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      sermon.duration,
                      style: TextStyle(
                        fontSize: 10,
                        color: subColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
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
    final bg =
        isDark ? const Color(0xFF0F172A) : Colors.white.withOpacity(0.9);
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
              icon: Icons.home, label: 'Home', active: false, onTap: onHome),
          _NavItem(
              icon: Icons.group,
              label: 'Groups',
              active: false,
              onTap: () {}),
          const SizedBox(width: 56),
          _NavItem(
              icon: Icons.volunteer_activism,
              label: 'Pray',
              active: false,
              onTap: () {}),
          _NavItem(
              icon: Icons.person, label: 'Profile', active: false, onTap: () {}),
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

class _RecentSermon {
  final String title;
  final String pastor;
  final String duration;
  final Color gradientStart;
  final Color gradientEnd;

  const _RecentSermon({
    required this.title,
    required this.pastor,
    required this.duration,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

class _Topic {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _Topic(this.label, this.icon, this.bgColor, this.iconColor);
}

class _SavedSermon {
  final String title;
  final String pastor;
  final String date;
  final String duration;
  final Color gradientStart;
  final Color gradientEnd;

  const _SavedSermon({
    required this.title,
    required this.pastor,
    required this.date,
    required this.duration,
    required this.gradientStart,
    required this.gradientEnd,
  });
}
