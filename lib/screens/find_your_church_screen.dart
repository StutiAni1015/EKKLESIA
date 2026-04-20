import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';
import '../service/location_service.dart';
import 'bible_books_index_screen.dart';
import 'church_search_results_screen.dart';

class FindYourChurchScreen extends StatefulWidget {
  const FindYourChurchScreen({super.key});

  @override
  State<FindYourChurchScreen> createState() =>
      _FindYourChurchScreenState();
}

class _FindYourChurchScreenState extends State<FindYourChurchScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int _navIndex = 3;
  int? _joiningIndex;

  List<Map<String, dynamic>> _churches = [];
  bool _loading = true;
  String? _error;

  static const ivory = Color(0xFFFDFBF7);
  static const sage = Color(0xFFB6C9BB);

  @override
  void initState() {
    super.initState();
    _loadChurches();
  }

  Future<void> _loadChurches() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await ApiService.getChurches(query: _query);
      if (!mounted) return;
      setState(() {
        _churches = results.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _churches;
    final q = _query.toLowerCase();
    return _churches.where((c) =>
      (c['name'] as String? ?? '').toLowerCase().contains(q) ||
      (c['city'] as String? ?? '').toLowerCase().contains(q) ||
      (c['denomination'] as String? ?? '').toLowerCase().contains(q)
    ).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Returns a formatted distance string if both user and church have coordinates.
  String? _distanceLabel(Map<String, dynamic> church) {
    final userLat = userLatNotifier.value;
    final userLng = userLngNotifier.value;
    final cLat = (church['lat'] as num?)?.toDouble();
    final cLng = (church['lng'] as num?)?.toDouble();
    if (userLat == null || cLat == null) return null;
    final miles = LocationService.distanceMiles(userLat, userLng!, cLat, cLng!);
    return LocationService.formatDistance(miles);
  }

  Future<void> _join(int index) async {
    setState(() => _joiningIndex = index);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _joiningIndex = null);
    _showJoinedSheet(_filtered[index]['name'] as String? ?? 'this church');
  }

  void _showJoinedSheet(String churchName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark =
            Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sage.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.church, color: sage, size: 36),
              ),
              const SizedBox(height: 14),
              Text(
                'Join Request Sent!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your request to join $churchName has been sent to the pastor for approval.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Got It',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final navBg = isDark ? const Color(0xFF0F172A) : ivory;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          // Sticky blurred header
          Container(
            color: isDark
                ? AppColors.backgroundDark.withOpacity(0.9)
                : const Color(0xFFF8F6F6).withOpacity(0.9),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Find Your Church',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              children: [
                const SizedBox(height: 20),

                // Hero heading
                Text(
                  'Which is your church?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Connect with your local spiritual family',
                  style:
                      TextStyle(fontSize: 14, color: subColor),
                ),
                const SizedBox(height: 20),

                // Search bar
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
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
                      const SizedBox(width: 14),
                      Icon(Icons.search,
                          color: _query.isNotEmpty
                              ? AppColors.primary
                              : subColor,
                          size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) =>
                              setState(() => _query = v),
                          onSubmitted: (_) => _loadChurches(),
                          style: TextStyle(
                              fontSize: 14, color: textColor),
                          decoration: InputDecoration(
                            hintText:
                                'Search by name, city, or denomination',
                            hintStyle: TextStyle(
                                fontSize: 13, color: subColor),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(Icons.clear,
                                color: subColor, size: 18),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section header
                Row(
                  children: [
                    Text(
                      _query.isEmpty
                          ? 'Nearby & Recommended'
                          : '${_filtered.length} result${_filtered.length != 1 ? 's' : ''}',
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
                            builder: (_) =>
                                const ChurchSearchResultsScreen()),
                      ),
                      child: Text(
                        'See Map',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Church cards
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Icon(Icons.wifi_off_outlined, size: 48, color: subColor),
                        const SizedBox(height: 12),
                        Text('Could not load churches', style: TextStyle(color: subColor, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextButton(onPressed: _loadChurches, child: const Text('Retry')),
                      ],
                    ),
                  )
                else if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Icon(Icons.church_outlined,
                            size: 48, color: subColor),
                        const SizedBox(height: 12),
                        Text(
                          _query.isEmpty
                              ? 'No churches yet. Be the first to create one!'
                              : 'No churches found for "$_query"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: subColor, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                else
                  ...List.generate(
                    _filtered.length,
                    (i) {
                      final c = _filtered[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ChurchCard(
                          name: c['name'] as String? ?? '',
                          address: [c['address'], c['city'], c['country']]
                              .where((s) => s != null && (s as String).isNotEmpty)
                              .join(', '),
                          denomination: c['denomination'] as String? ?? '',
                          memberCount: '${(c['members'] as List?)?.length ?? 0} members',
                          distance: _distanceLabel(c),
                          isJoining: _joiningIndex == i,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          onJoin: () => _join(i),
                          onViewProfile: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ChurchSearchResultsScreen()),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE5E7EB),
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 68,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    active: _navIndex == 0,
                    onTap: () => setState(() => _navIndex = 0)),
                _NavItem(
                    icon: Icons.volunteer_activism_outlined,
                    activeIcon: Icons.volunteer_activism,
                    label: 'Prayers',
                    active: _navIndex == 1,
                    onTap: () => setState(() => _navIndex = 1)),
                // Elevated Bible FAB
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const BibleBooksIndexScreen()),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                                color: navBg, width: 3),
                          ),
                          child: const Icon(Icons.auto_stories,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Bible',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _NavItem(
                    icon: Icons.groups_outlined,
                    activeIcon: Icons.groups,
                    label: 'Church',
                    active: _navIndex == 3,
                    onTap: () => setState(() => _navIndex = 3)),
                _NavItem(
                    icon: Icons.account_circle_outlined,
                    activeIcon: Icons.account_circle,
                    label: 'Profile',
                    active: _navIndex == 4,
                    onTap: () => setState(() => _navIndex = 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Church card ───────────────────────────────────────────────────────────────

class _ChurchCard extends StatelessWidget {
  final String name;
  final String address;
  final String denomination;
  final String memberCount;
  final String? distance; // null = location unknown
  final bool isJoining;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final VoidCallback onJoin;
  final VoidCallback onViewProfile;

  const _ChurchCard({
    required this.name,
    required this.address,
    required this.denomination,
    required this.memberCount,
    this.distance,
    required this.isJoining,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.onJoin,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient banner
          Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD7ECE4), Color(0xFFB6C9BB)],
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.church, size: 56,
                      color: Color(0x594A7C59)),
                ),
                if (distance != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.near_me,
                              size: 11, color: Color(0xFF374151)),
                          const SizedBox(width: 4),
                          Text(
                            distance!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 13, color: subColor),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  address.isNotEmpty ? address : 'Location not set',
                                  style: TextStyle(
                                      fontSize: 12, color: subColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (denomination.isNotEmpty)
                  Text(
                    denomination,
                    style: TextStyle(
                      fontSize: 12,
                      color: subColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.people_outline,
                        size: 12, color: subColor),
                    const SizedBox(width: 4),
                    Text(memberCount,
                        style: TextStyle(
                            fontSize: 11, color: subColor)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: isJoining ? null : onJoin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.5),
                            elevation: 3,
                            shadowColor:
                                AppColors.primary.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10)),
                          ),
                          child: isJoining
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2),
                                )
                              : const Text(
                                  'Join',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: onViewProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF4EAE0),
                            foregroundColor: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF374151),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'View Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
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

// ── Nav item ──────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(active ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
