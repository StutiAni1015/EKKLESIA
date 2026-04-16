import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../service/api_service.dart';
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

  List<Map<String, dynamic>> _churches = [];
  bool _loading = true;
  String? _error;

  static const _filters = [
    'All Results',
    'Denomination',
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_activeFilter == 'Denomination') {
      final q = _searchCtrl.text.trim().toLowerCase();
      return _churches.where((c) =>
        (c['denomination'] as String? ?? '').toLowerCase().contains(q)
      ).toList();
    }
    return _churches;
  }

  Future<void> _search() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await ApiService.getChurches(
          query: _searchCtrl.text.trim());
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

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.initialQuery);
    _search();
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
                        onSubmitted: (_) => _search(),
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wifi_off_outlined,
                                  size: 48, color: subColor),
                              const SizedBox(height: 12),
                              Text('Could not load churches',
                                  style: TextStyle(
                                      fontSize: 15, color: subColor)),
                              const SizedBox(height: 8),
                              TextButton(
                                  onPressed: _search,
                                  child: const Text('Retry')),
                            ],
                          ),
                        )
                      : _filtered.isEmpty
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
                                  MediaQuery.of(context).padding.bottom +
                                      80),
                              itemCount: _filtered.length + 1,
                              itemBuilder: (context, i) {
                                if (i == 0) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 14),
                                    child: Text(
                                      "Found ${_filtered.length} church${_filtered.length != 1 ? 'es' : ''}"
                                      "${_searchCtrl.text.isNotEmpty ? " matching '${_searchCtrl.text}'" : ''}",
                                      style: TextStyle(
                                          fontSize: 13, color: subColor),
                                    ),
                                  );
                                }
                                final c = _filtered[i - 1];
                                final location = [
                                  c['city'],
                                  c['country']
                                ]
                                    .where((s) =>
                                        s != null &&
                                        (s as String).isNotEmpty)
                                    .join(', ');
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: _ChurchCard(
                                    name: c['name'] as String? ?? '',
                                    location: location,
                                    denomination:
                                        c['denomination'] as String? ?? '',
                                    members:
                                        (c['members'] as List?)?.length ??
                                            0,
                                    cardBg: cardBg,
                                    textColor: textColor,
                                    subColor: subColor,
                                    borderColor: borderColor,
                                    onViewProfile: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChurchProfileViewScreen(
                                          churchName:
                                              c['name'] as String? ?? '',
                                          denomination:
                                              c['denomination']
                                                      as String? ??
                                                  '',
                                          location: location,
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
  final String name;
  final String location;
  final String denomination;
  final int members;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final Color borderColor;
  final VoidCallback onViewProfile;

  const _ChurchCard({
    required this.name,
    required this.location,
    required this.denomination,
    required this.members,
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
                  colors: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
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
                      denomination.isNotEmpty ? denomination : 'Church',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    name,
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
                          location.isNotEmpty ? location : 'Location not set',
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

