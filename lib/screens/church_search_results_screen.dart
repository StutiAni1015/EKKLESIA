import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'bible_books_index_screen.dart';
import 'church_profile_view_screen.dart';

class ChurchSearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  const ChurchSearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  State<ChurchSearchResultsScreen> createState() =>
      _ChurchSearchResultsScreenState();
}

class _ChurchSearchResultsScreenState
    extends State<ChurchSearchResultsScreen> {
  late final TextEditingController _searchCtrl;
  String _activeFilter = 'All Results';
  int _navIndex = 3;

  static const _filters = [
    'All Results',
    'Denomination',
    'Distance',
    'Service Time',
  ];

  static const _churches = [
    _ChurchResult(
      name: 'Grace Community Baptist',
      location: 'Springfield, IL',
      denomination: 'Baptist',
      distance: '0.8 mi',
      members: 342,
      serviceTime: 'Sun 9AM & 11AM',
      gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      iconColor: Colors.white,
    ),
    _ChurchResult(
      name: 'Amazing Grace Baptist',
      location: 'Chicago, IL',
      denomination: 'Baptist',
      distance: '2.3 mi',
      members: 1240,
      serviceTime: 'Sun 8AM, 10AM & 12PM',
      gradientColors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
      iconColor: Colors.white,
    ),
    _ChurchResult(
      name: 'Grace Covenant Church',
      location: 'Naperville, IL',
      denomination: 'Reformed Baptist',
      distance: '4.1 mi',
      members: 580,
      serviceTime: 'Sun 10:30AM',
      gradientColors: [Color(0xFF22C55E), Color(0xFF16A34A)],
      iconColor: Colors.white,
    ),
    _ChurchResult(
      name: 'Grace Reformed Baptist',
      location: 'Peoria, IL',
      denomination: 'Independent Baptist',
      distance: '7.6 mi',
      members: 215,
      serviceTime: 'Sun 9AM & 6PM',
      gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      iconColor: Colors.white,
    ),
    _ChurchResult(
      name: 'First Baptist Grace',
      location: 'Bloomington, IL',
      denomination: 'Southern Baptist',
      distance: '12.4 mi',
      members: 890,
      serviceTime: 'Sun 9:30AM & 11AM',
      gradientColors: [Color(0xFFEC5B13), Color(0xFFDC2626)],
      iconColor: Colors.white,
    ),
    _ChurchResult(
      name: 'Grace Fellowship Church',
      location: 'Rockford, IL',
      denomination: 'Non-denominational',
      distance: '18.2 mi',
      members: 430,
      serviceTime: 'Sun 10AM',
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      iconColor: Colors.white,
    ),
  ];

  List<_ChurchResult> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _churches.where((c) {
      if (q.isNotEmpty &&
          !c.name.toLowerCase().contains(q) &&
          !c.location.toLowerCase().contains(q) &&
          !c.denomination.toLowerCase().contains(q)) return false;
      if (_activeFilter == 'Denomination' &&
          !c.denomination.toLowerCase().contains('baptist')) return false;
      if (_activeFilter == 'Distance') {
        final d = double.tryParse(c.distance.split(' ')[0]) ?? 99;
        return d <= 5;
      }
      if (_activeFilter == 'Service Time' &&
          !c.serviceTime.contains('10')) return false;
      return true;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final navBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    final results = _filtered;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Icon(Icons.tune_outlined, color: subColor),
                ],
              ),
            ),

            // Search bar
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: subColor, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        style: TextStyle(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Search churches...',
                          hintStyle: TextStyle(color: subColor, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (_searchCtrl.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.close,
                              size: 16, color: subColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Filter chips
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final active = f == _activeFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _activeFilter = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.church_outlined,
                              size: 48,
                              color: subColor.withOpacity(0.4)),
                          const SizedBox(height: 12),
                          Text('No churches found',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: subColor)),
                          const SizedBox(height: 4),
                          Text('Try a different search or filter',
                              style: TextStyle(
                                  fontSize: 12, color: subColor)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          MediaQuery.of(context).padding.bottom + 80),
                      itemCount: results.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Text(
                              "Found ${results.length} churches matching '${_searchCtrl.text.isEmpty ? 'all' : _searchCtrl.text}'",
                              style: TextStyle(
                                fontSize: 13,
                                color: subColor,
                              ),
                            ),
                          );
                        }
                        final c = results[i - 1];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ChurchCard(
                            church: c,
                            cardBg: cardBg,
                            textColor: textColor,
                            subColor: subColor,
                            borderColor: borderColor,
                            onViewProfile: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChurchProfileViewScreen(
                                  churchName: c.name,
                                  denomination: c.denomination,
                                  location: c.location,
                                  isMember: false,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(top: BorderSide(color: borderColor)),
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
                    label: 'HOME',
                    active: _navIndex == 0,
                    onTap: () => setState(() => _navIndex = 0)),
                _NavItem(
                    icon: Icons.video_library_outlined,
                    activeIcon: Icons.video_library,
                    label: 'SERMONS',
                    active: _navIndex == 1,
                    onTap: () => setState(() => _navIndex = 1)),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BibleBooksIndexScreen()),
                    ),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: navBg, width: 3),
                      ),
                      child: const Icon(Icons.auto_stories,
                          color: Colors.white, size: 26),
                    ),
                  ),
                ),
                _NavItem(
                    icon: Icons.people_outlined,
                    activeIcon: Icons.people,
                    label: 'COMMUNITY',
                    active: _navIndex == 3,
                    onTap: () => setState(() => _navIndex = 3)),
                _NavItem(
                    icon: Icons.more_horiz,
                    activeIcon: Icons.more_horiz,
                    label: 'MORE',
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

class _ChurchCard extends StatelessWidget {
  final _ChurchResult church;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final Color borderColor;
  final VoidCallback onViewProfile;

  const _ChurchCard({
    required this.church,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.borderColor,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: church.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.church, color: Colors.white38, size: 36),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Denomination badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      church.denomination,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    church.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: subColor),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${church.location} · ${church.distance}',
                          style: TextStyle(fontSize: 11, color: subColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onViewProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final color = active ? AppColors.primary : const Color(0xFF94A3B8);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(active ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChurchResult {
  final String name;
  final String location;
  final String denomination;
  final String distance;
  final int members;
  final String serviceTime;
  final List<Color> gradientColors;
  final Color iconColor;

  const _ChurchResult({
    required this.name,
    required this.location,
    required this.denomination,
    required this.distance,
    required this.members,
    required this.serviceTime,
    required this.gradientColors,
    required this.iconColor,
  });
}
