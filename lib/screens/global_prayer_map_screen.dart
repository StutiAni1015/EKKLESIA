import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../widgets/app_bottom_bar.dart';
import 'submit_global_prayer_screen.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
const _orange     = Color(0xFF9E4300);
const _orangeCore = Color(0xFFFF9A5C);

const _recentRequests = [
  _RecentRequest(
    name: 'Elena M.',
    location: 'Rome, Italy',
    time: '2 min ago',
    text: 'Praying for peace and healing for my community.',
    category: 'Healing',
    initials: 'EM',
    avatarColor: Color(0xFFDCAE96),
  ),
  _RecentRequest(
    name: 'Samuel K.',
    location: 'Lagos, Nigeria',
    time: '5 min ago',
    text: 'Join us in the Lagos Morning Prayer Room starting now.',
    category: 'Community',
    initials: 'SK',
    avatarColor: Color(0xFFB2C2A3),
    isRoom: true,
  ),
  _RecentRequest(
    name: 'Ji-woo P.',
    location: 'Seoul, S. Korea',
    time: '11 min ago',
    text: 'Seeking God\'s guidance for our nation during this time.',
    category: 'Guidance',
    initials: 'JP',
    avatarColor: Color(0xFFB9D1EA),
  ),
];

class _RecentRequest {
  final String name;
  final String location;
  final String time;
  final String text;
  final String category;
  final String initials;
  final Color avatarColor;
  final bool isRoom;

  const _RecentRequest({
    required this.name,
    required this.location,
    required this.time,
    required this.text,
    required this.category,
    required this.initials,
    required this.avatarColor,
    this.isRoom = false,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class GlobalPrayerMapScreen extends StatefulWidget {
  const GlobalPrayerMapScreen({super.key});

  @override
  State<GlobalPrayerMapScreen> createState() => _GlobalPrayerMapScreenState();
}

class _GlobalPrayerMapScreenState extends State<GlobalPrayerMapScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const AppBottomBar(activeIndex: kTabCommunity),
      floatingActionButton: buildCenterFab(context, activeIndex: kTabCommunity),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    bottom: BorderSide(color: _orange.withAlpha(40)),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.public, color: AppColors.primary, size: 26),
                    const SizedBox(width: 10),
                    Text(
                      'Global Prayer Network',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    _NotifBadge(),
                  ],
                ),
              ),
            ),

            // ── Map ──
            SliverToBoxAdapter(
              child: _MapView(pulse: _pulse),
            ),

            // ── Live stats overlay ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _LivePanel(isDark: isDark, textColor: textColor),
              ),
            ),

            // ── Global stats ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LIVE ACTIVITY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.volunteer_activism,
                            iconColor: AppColors.primary,
                            value: '12,402',
                            label: 'Prayers',
                            bg: cardBg,
                            border: borderColor,
                            textColor: textColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.meeting_room_outlined,
                            iconColor: AppColors.sage,
                            value: '45',
                            label: 'Rooms',
                            bg: cardBg,
                            border: borderColor,
                            textColor: textColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.groups_outlined,
                            iconColor: AppColors.babyBlue,
                            value: '8.2k',
                            label: 'Members',
                            bg: cardBg,
                            border: borderColor,
                            textColor: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Submit CTA ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubmitGlobalPrayerScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withAlpha(200),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: Colors.white, size: 24),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Light a Prayer on the Map',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Share your heart with the world.',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Recent Requests ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Row(
                  children: [
                    Icon(Icons.forum_outlined, color: AppColors.dustyRose, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Prayer Requests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, 12, 16, i == _recentRequests.length - 1 ? 110 : 0),
                  child: _RequestCard(
                    req: _recentRequests[i],
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                  ),
                ),
                childCount: _recentRequests.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Country centroids (equirectangular lat/lng) ───────────────────────────────
// Privacy: only the country level is ever shown on the map.
const _centroids = <String, (double lat, double lng)>{
  'AF': (33.9, 67.7),   'AL': (41.1, 20.2),   'DZ': (28.0, 3.0),
  'AO': (-11.2, 17.9),  'AR': (-38.4, -63.6), 'AM': (40.1, 45.0),
  'AU': (-25.3, 133.8), 'AT': (47.5, 14.6),   'AZ': (40.1, 47.6),
  'BD': (23.7, 90.4),   'BE': (50.5, 4.5),    'BO': (-17.0, -65.0),
  'BA': (44.2, 17.9),   'BW': (-22.3, 24.7),  'BR': (-14.2, -51.9),
  'BF': (12.4, -1.6),   'BI': (-3.4, 29.9),   'KH': (12.6, 104.9),
  'CM': (3.8, 11.5),    'CA': (56.1, -106.3), 'CL': (-35.7, -71.5),
  'CN': (35.9, 104.2),  'CO': (4.6, -74.1),   'CG': (-0.2, 15.8),
  'CD': (-4.0, 21.8),   'HR': (45.1, 15.2),   'CU': (21.5, -79.0),
  'CY': (35.1, 33.4),   'CZ': (50.1, 15.5),   'DK': (56.3, 9.5),
  'EC': (-1.8, -78.2),  'EG': (26.8, 30.8),   'SV': (13.8, -88.9),
  'ET': (9.1, 40.5),    'FI': (64.0, 26.0),   'FR': (46.2, 2.2),
  'GA': (-0.8, 11.6),   'DE': (51.2, 10.5),   'GH': (7.9, -1.0),
  'GR': (39.1, 21.8),   'GT': (15.8, -90.2),  'GN': (11.0, -10.9),
  'HN': (15.2, -86.2),  'HU': (47.2, 19.5),   'IN': (20.6, 78.9),
  'ID': (-0.8, 113.9),  'IR': (32.4, 53.7),   'IQ': (33.2, 43.7),
  'IE': (53.4, -8.2),   'IL': (31.0, 34.9),   'IT': (41.9, 12.6),
  'CI': (7.5, -5.5),    'JP': (36.2, 138.3),  'JO': (31.2, 36.5),
  'KZ': (48.0, 68.0),   'KE': (0.0, 37.9),    'KP': (40.3, 127.5),
  'KR': (36.6, 127.9),  'KW': (29.3, 47.5),   'KG': (41.2, 74.8),
  'LB': (33.9, 35.9),   'LY': (26.3, 17.2),   'MY': (4.2, 108.0),
  'ML': (17.6, -2.0),   'MX': (23.6, -102.5), 'MA': (31.8, -7.1),
  'MZ': (-18.7, 35.5),  'MM': (21.9, 95.9),   'NA': (-22.0, 17.1),
  'NP': (28.4, 84.1),   'NL': (52.1, 5.3),    'NZ': (-40.9, 174.9),
  'NE': (17.6, 8.1),    'NG': (9.1, 8.7),     'NO': (60.5, 8.5),
  'OM': (21.5, 55.9),   'PK': (30.4, 69.3),   'PA': (8.5, -80.8),
  'PG': (-6.3, 143.9),  'PY': (-23.4, -58.4), 'PE': (-9.2, -75.0),
  'PH': (12.9, 121.8),  'PL': (51.9, 19.1),   'PT': (39.4, -8.2),
  'QA': (25.4, 51.2),   'RO': (45.9, 24.9),   'RU': (61.5, 105.3),
  'RW': (-1.9, 29.9),   'SA': (23.9, 45.1),   'SN': (14.5, -14.5),
  'RS': (44.0, 21.0),   'SL': (8.5, -11.8),   'SO': (5.2, 46.2),
  'ZA': (-30.6, 22.9),  'SS': (6.9, 31.3),    'ES': (40.5, -3.7),
  'LK': (7.9, 80.7),    'SD': (12.9, 30.2),   'SE': (60.1, 18.6),
  'CH': (47.0, 8.2),    'SY': (34.8, 38.9),   'TW': (23.7, 121.0),
  'TJ': (38.9, 71.3),   'TZ': (-6.4, 34.9),   'TH': (15.9, 100.9),
  'TG': (8.6, 0.8),     'TN': (33.9, 9.5),    'TR': (38.9, 35.2),
  'TM': (38.9, 59.6),   'UG': (1.4, 32.3),    'UA': (49.0, 31.4),
  'AE': (24.0, 54.0),   'GB': (55.4, -3.4),   'US': (37.1, -95.7),
  'UY': (-32.5, -55.8), 'UZ': (41.4, 64.6),   'VE': (6.4, -66.6),
  'VN': (14.1, 108.3),  'YE': (15.6, 48.5),   'ZM': (-13.1, 27.8),
  'ZW': (-19.0, 29.2),
};

// ── Map View ─────────────────────────────────────────────────────────────────
class _MapView extends StatelessWidget {
  final AnimationController pulse;

  const _MapView({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = w * 0.5625; // 16:9 — matches the uploaded world map PNG

      return ValueListenableBuilder<String>(
        valueListenable: userCountryIsoNotifier,
        builder: (context, myIso, _) {
          // Privacy: only the current user's own country glows.
          // We never reveal where other people are praying from.
          final Map<String, int> countryCounts = {
            if (myIso.isNotEmpty && _centroids.containsKey(myIso)) myIso: 1,
          };

          return SizedBox(
            width: w,
            height: h,
            child: Stack(
              children: [
                // World map image
                Positioned.fill(
                  child: Image.asset('assets/images/world_map.png',
                      fit: BoxFit.fill),
                ),

                // Country glows — painted on top of map image
                if (countryCounts.isNotEmpty)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: pulse,
                      builder: (_, __) => CustomPaint(
                        painter: _CountryGlowPainter(
                          countryCounts: countryCounts,
                          pulseValue: pulse.value,
                          mapWidth: w,
                          mapHeight: h,
                        ),
                      ),
                    ),
                  ),

                // Bottom fade
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: h * 0.12,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // Privacy badge — bottom right
                Positioned(
                  bottom: h * 0.16, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(160),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withAlpha(30)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.white70, size: 10),
                        SizedBox(width: 4),
                        Text(
                          'Country only — location private',
                          style: TextStyle(color: Colors.white70, fontSize: 9,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

                // Prayer count — bottom left
                Positioned(
                  bottom: h * 0.14, left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(160),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _orange.withAlpha(80)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7, height: 7,
                          decoration: BoxDecoration(
                            color: _orange, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: _orange, blurRadius: 6)],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${12402 + globalPrayerLightsNotifier.value.length} prayers active',
                          style: const TextStyle(color: Colors.white, fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

// ── Country glow painter ──────────────────────────────────────────────────────
class _CountryGlowPainter extends CustomPainter {
  final Map<String, int> countryCounts; // iso → prayer count
  final double pulseValue;
  final double mapWidth;
  final double mapHeight;

  const _CountryGlowPainter({
    required this.countryCounts,
    required this.pulseValue,
    required this.mapWidth,
    required this.mapHeight,
  });

  // Equirectangular projection
  Offset _project(double lat, double lng) => Offset(
    ((lng + 180) / 360) * mapWidth,
    ((90 - lat) / 180) * mapHeight,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in countryCounts.entries) {
      final iso   = entry.key;
      final count = entry.value;
      final centroid = _centroids[iso];
      if (centroid == null) continue;

      final (lat, lng) = centroid;
      final center = _project(lat, lng);

      // Pulse: breathe between 0.85 and 1.0 in scale
      final breath = 0.85 + 0.15 * pulseValue;
      final intensity = (0.5 + 0.5 * (count / (count + 3))).clamp(0.0, 1.0);

      // ── Outer bloom ───────────────────────────────────────────────────────
      canvas.drawCircle(
        center,
        65 * breath,
        Paint()
          ..color = _orange.withAlpha((28 * intensity).round())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
      );

      // ── Mid glow ──────────────────────────────────────────────────────────
      canvas.drawCircle(
        center,
        38 * breath,
        Paint()
          ..color = _orange.withAlpha((75 * intensity).round())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );

      // ── Inner core ───────────────────────────────────────────────────────
      canvas.drawCircle(
        center,
        10 * breath,
        Paint()
          ..color = _orangeCore.withAlpha((180 * intensity).round())
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // ── Crisp centre dot ─────────────────────────────────────────────────
      canvas.drawCircle(
        center,
        3.0,
        Paint()..color = Colors.white.withAlpha(200),
      );
    }
  }

  @override
  bool shouldRepaint(_CountryGlowPainter old) =>
      old.pulseValue != pulseValue || old.countryCounts != countryCounts;
}

// ── Live Panel ────────────────────────────────────────────────────────────────
class _LivePanel extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const _LivePanel({required this.isDark, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<GlobalPrayerLight>>(
      valueListenable: globalPrayerLightsNotifier,
      builder: (context, lights, _) {
        final total = 12402 + lights.length;
        final panelBg = isDark
            ? Colors.black.withAlpha(200)
            : const Color(0xFF060D1A).withAlpha(220);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: panelBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _orange.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GLOBAL PRAYER NETWORK',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white.withAlpha(130),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$total Prayers Active',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _MiniStat(value: '${lights.length}', label: 'Your Lights'),
                  const SizedBox(width: 8),
                  _MiniStat(value: '45', label: 'Rooms'),
                  const SizedBox(width: 8),
                  _MiniStat(value: '8.2k', label: 'Members'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(14),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: Colors.white.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color bg;
  final Color border;
  final Color textColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.bg,
    required this.border,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Request Card ─────────────────────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final _RecentRequest req;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _RequestCard({
    required this.req,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: req.avatarColor.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: req.avatarColor.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: req.avatarColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              req.initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      req.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${req.time}',
                      style: TextStyle(fontSize: 11, color: subColor),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  req.location,
                  style:
                      TextStyle(fontSize: 11, color: AppColors.primary),
                ),
                const SizedBox(height: 6),
                Text(
                  '"${req.text}"',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: textColor.withAlpha(210),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: req.avatarColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        req.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (req.isRoom) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(Icons.play_circle,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'Enter Room',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _NotifBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications_outlined,
              color: AppColors.primary, size: 22),
        ),
        Positioned(
          top: 8,
          right: 8,
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
    );
  }
}
