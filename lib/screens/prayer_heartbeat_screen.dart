import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/app_bottom_bar.dart';
import 'add_prayer_request_screen.dart';

class PrayerHeartbeatScreen extends StatefulWidget {
  const PrayerHeartbeatScreen({super.key});

  @override
  State<PrayerHeartbeatScreen> createState() =>
      _PrayerHeartbeatScreenState();
}

class _PrayerHeartbeatScreenState extends State<PrayerHeartbeatScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  late final Animation<double> _ring;

  bool _joined = false;
  int _prayerCount = 47;

  static const dustyRose = Color(0xFFD4A5A5);
  static const babyBlue = Color(0xFFB9CFDF);
  static const sage = Color(0xFFB6C9BB);
  static const ivory = Color(0xFFFDFBF7);
  static const nude = Color(0xFFF4EAE0);

  static const _requests = [
    _PrayerRequest(
      initials: 'AM',
      name: 'Anna Moore',
      time: '2m ago',
      request:
          'Pray for my mother who is going through surgery this Friday. We trust in God\'s healing hand.',
      category: 'Healing',
      categoryColor: dustyRose,
      gradientColors: [Color(0xFFEDD6DC), Color(0xFFD4A5A5)],
      hearts: 12,
      isLive: true,
    ),
    _PrayerRequest(
      initials: 'JO',
      name: 'James Obi',
      time: '8m ago',
      request:
          'Seeking wisdom and direction for a major career decision. Please stand in agreement with me.',
      category: 'Guidance',
      categoryColor: sage,
      gradientColors: [Color(0xFFD3E8D7), Color(0xFFB0C4B1)],
      hearts: 28,
      isLive: false,
    ),
    _PrayerRequest(
      initials: 'FC',
      name: 'Faith Chen',
      time: '15m ago',
      request:
          'My son has been struggling in school. Praying for peace, focus and renewed strength for him.',
      category: 'Family',
      categoryColor: babyBlue,
      gradientColors: [Color(0xFFCFE2EF), Color(0xFFB9CFDF)],
      hearts: 9,
      isLive: false,
    ),
    _PrayerRequest(
      initials: 'KT',
      name: 'Kwame Tetteh',
      time: '31m ago',
      request:
          'Praise report! I\'ve been praying for a breakthrough in my business. God provided! Thank you all.',
      category: 'Praise',
      categoryColor: Color(0xFFFBBF24),
      gradientColors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
      hearts: 54,
      isLive: false,
    ),
    _PrayerRequest(
      initials: 'NL',
      name: 'Nadia Lewis',
      time: '1h ago',
      request:
          'Please pray for restoration in my marriage. We are trusting God to work miracles.',
      category: 'Relationships',
      categoryColor: dustyRose,
      gradientColors: [Color(0xFFEDD6DC), Color(0xFFD4A5A5)],
      hearts: 33,
      isLive: false,
    ),
  ];

  final Set<int> _prayed = {};

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _ring = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor =
        isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);


    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding:
                  const EdgeInsets.fromLTRB(16, 14, 16, 14),
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Prayer Heartbeat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  // Live indicator
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444)
                            .withOpacity(0.1 + _pulse.value * 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFEF4444)
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFEF4444),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                children: [
                  const SizedBox(height: 20),

                  // Pulsing heartbeat hero
                  Center(
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring pulse
                          Container(
                            width: 130 + _ring.value * 20,
                            height: 130 + _ring.value * 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dustyRose.withOpacity(
                                  0.08 * (1 - _ring.value)),
                            ),
                          ),
                          // Middle ring
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dustyRose.withOpacity(0.15),
                            ),
                          ),
                          // Heart icon
                          ScaleTransition(
                            scale: _scale,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    dustyRose,
                                    Color(0xFFC07B7B)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        dustyRose.withOpacity(0.4),
                                    blurRadius:
                                        12 + _pulse.value * 8,
                                    spreadRadius: _pulse.value * 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Join prayer session banner
                  Center(
                    child: Text(
                      _joined
                          ? 'You are praying with the community'
                          : '$_prayerCount members praying right now',
                      style: TextStyle(
                        fontSize: 14,
                        color: subColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Joining avatars row
                  Center(
                    child: SizedBox(
                      height: 36,
                      child: Stack(
                        children: List.generate(5, (i) {
                          final colors = [
                            dustyRose,
                            sage,
                            babyBlue,
                            const Color(0xFFFBBF24),
                            AppColors.primary,
                          ];
                          final labels = ['AM', 'JO', 'FC', 'KT', 'NL'];
                          return Positioned(
                            left: i * 24.0,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors[i],
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.backgroundDark
                                      : const Color(0xFFF8F6F6),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  labels[i],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Join button
                  GestureDetector(
                    onTap: () => setState(() {
                      _joined = !_joined;
                      if (_joined) _prayerCount++;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 52,
                      decoration: BoxDecoration(
                        color: _joined
                            ? const Color(0xFF22C55E)
                            : dustyRose,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: (_joined
                                    ? const Color(0xFF22C55E)
                                    : dustyRose)
                                .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _joined
                                ? Icons.check
                                : Icons.favorite_border,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _joined
                                ? 'Praying with Community'
                                : 'Join Prayer Session',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Prayer requests heading
                  Row(
                    children: [
                      Icon(Icons.volunteer_activism,
                          color: dustyRose, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Community Prayer Requests',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddPrayerRequestScreen()),
                        ),
                        child: Text(
                          '+ Add Yours',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Request cards
                  ...List.generate(_requests.length, (i) {
                    final r = _requests[i];
                    final prayed = _prayed.contains(i);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: r.isLive
                                ? dustyRose.withOpacity(0.4)
                                : (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE5E7EB)),
                            width: r.isLive ? 1.5 : 1,
                          ),
                          boxShadow: r.isLive
                              ? [
                                  BoxShadow(
                                    color:
                                        dustyRose.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: r.gradientColors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      r.initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            r.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: textColor,
                                            ),
                                          ),
                                          if (r.isLive) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                        0xFFEF4444)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(20),
                                              ),
                                              child: const Text(
                                                'Live',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color: Color(
                                                      0xFFEF4444),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(r.time,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: subColor)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color:
                                        r.categoryColor.withOpacity(0.12),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    r.category,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: r.categoryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              r.request,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.55,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(
                                      () => _prayed.add(i)),
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: prayed
                                          ? dustyRose
                                          : dustyRose.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          prayed
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 14,
                                          color: prayed
                                              ? Colors.white
                                              : dustyRose,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          prayed
                                              ? 'Prayed'
                                              : 'Pray',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: prayed
                                                ? Colors.white
                                                : dustyRose,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Response feature coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFFF1F5F9),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Respond',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: subColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.favorite,
                                    size: 14, color: subColor),
                                const SizedBox(width: 4),
                                Text(
                                  '${r.hearts + (prayed ? 1 : 0)}',
                                  style: TextStyle(
                                      fontSize: 12, color: subColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomBar(activeIndex: kTabCommunity),
      floatingActionButton: buildCenterFab(context, activeIndex: kTabCommunity),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _PrayerRequest {
  final String initials;
  final String name;
  final String time;
  final String request;
  final String category;
  final Color categoryColor;
  final List<Color> gradientColors;
  final int hearts;
  final bool isLive;

  const _PrayerRequest({
    required this.initials,
    required this.name,
    required this.time,
    required this.request,
    required this.category,
    required this.categoryColor,
    required this.gradientColors,
    required this.hearts,
    required this.isLive,
  });
}

