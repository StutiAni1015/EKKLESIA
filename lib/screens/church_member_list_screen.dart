import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ChurchMemberListScreen extends StatefulWidget {
  const ChurchMemberListScreen({super.key});

  @override
  State<ChurchMemberListScreen> createState() =>
      _ChurchMemberListScreenState();
}

class _ChurchMemberListScreenState extends State<ChurchMemberListScreen> {
  final _searchCtrl = TextEditingController();
  String _activeFilter = 'All';

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  static const _filters = ['All', 'Verified', 'Pending', 'Inactive'];

  static const _members = [
    _Member(
      name: 'Adaeze Okonkwo',
      role: 'Worship Team',
      joinDate: 'Jan 2022',
      status: 'Verified',
      initials: 'AO',
      gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    ),
    _Member(
      name: 'Benjamin Agyei',
      role: 'Deacon',
      joinDate: 'Mar 2019',
      status: 'Verified',
      initials: 'BA',
      gradientColors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
    ),
    _Member(
      name: 'Chioma Nwosu',
      role: 'Cell Group Leader',
      joinDate: 'Jul 2023',
      status: 'Pending',
      initials: 'CN',
      gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    ),
    _Member(
      name: 'David Mensah',
      role: 'Youth Ministry',
      joinDate: 'Feb 2021',
      status: 'Verified',
      initials: 'DM',
      gradientColors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    ),
    _Member(
      name: 'Esther Boateng',
      role: 'Children Church',
      joinDate: 'Nov 2020',
      status: 'Verified',
      initials: 'EB',
      gradientColors: [Color(0xFFEC5B13), Color(0xFFDC2626)],
    ),
    _Member(
      name: 'Felix Asante',
      role: 'Usher',
      joinDate: 'Jun 2023',
      status: 'Pending',
      initials: 'FA',
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    ),
    _Member(
      name: 'Grace Owusu',
      role: 'Media Team',
      joinDate: 'Apr 2022',
      status: 'Inactive',
      initials: 'GO',
      gradientColors: [Color(0xFF64748B), Color(0xFF475569)],
    ),
    _Member(
      name: 'Henry Darko',
      role: 'Member',
      joinDate: 'Sep 2023',
      status: 'Pending',
      initials: 'HD',
      gradientColors: [Color(0xFFB6C9BB), Color(0xFF8FA89B)],
    ),
    _Member(
      name: 'Irene Amponsah',
      role: 'Prayer Team',
      joinDate: 'Dec 2021',
      status: 'Verified',
      initials: 'IA',
      gradientColors: [Color(0xFFD8A7B1), Color(0xFFBE8A94)],
    ),
    _Member(
      name: 'James Kwarteng',
      role: 'Choir',
      joinDate: 'May 2018',
      status: 'Inactive',
      initials: 'JK',
      gradientColors: [Color(0xFF64748B), Color(0xFF334155)],
    ),
  ];

  List<_Member> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _members.where((m) {
      if (_activeFilter != 'All' && m.status != _activeFilter) return false;
      if (q.isNotEmpty &&
          !m.name.toLowerCase().contains(q) &&
          !m.role.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
  }

  int _countFor(String status) =>
      status == 'All'
          ? _members.length
          : _members.where((m) => m.status == status).length;

  Color _statusColor(String s) => switch (s) {
        'Verified' => const Color(0xFF22C55E),
        'Pending' => const Color(0xFFF59E0B),
        'Inactive' => const Color(0xFF94A3B8),
        _ => const Color(0xFF94A3B8),
      };

  IconData _statusIcon(String s) => switch (s) {
        'Verified' => Icons.verified,
        'Pending' => Icons.schedule,
        'Inactive' => Icons.remove_circle_outline,
        _ => Icons.help_outline,
      };

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Church Members',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${_members.length} total members',
                          style: TextStyle(fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add_outlined,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Invite',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search
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
                          hintText: 'Search by name or role...',
                          hintStyle:
                              TextStyle(color: subColor, fontSize: 14),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          child:
                              Icon(Icons.close, size: 16, color: subColor),
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
              child: Row(
                children: _filters.map((f) {
                  final active = f == _activeFilter;
                  final count = _countFor(f);
                  final color = f == 'All'
                      ? AppColors.primary
                      : _statusColor(f);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => _activeFilter = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? color.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: active
                                  ? color.withOpacity(0.4)
                                  : borderColor,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: active ? color : subColor,
                                ),
                              ),
                              Text(
                                f,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: active ? color : subColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline,
                              size: 48,
                              color: subColor.withOpacity(0.4)),
                          const SizedBox(height: 12),
                          Text('No members found',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: subColor)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          MediaQuery.of(context).padding.bottom + 32),
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final m = results[i];
                        final statusColor = _statusColor(m.status);
                        final statusIcon = _statusIcon(m.status);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: m.gradientColors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      m.initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 7,
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20),
                                            ),
                                            child: Text(
                                              m.role,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Joined ${m.joinDate}',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: subColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Status
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            statusColor.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(statusIcon,
                                              size: 10,
                                              color: statusColor),
                                          const SizedBox(width: 3),
                                          Text(
                                            m.status,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: statusColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Icon(Icons.chevron_right,
                                        size: 16, color: subColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Member {
  final String name;
  final String role;
  final String joinDate;
  final String status;
  final String initials;
  final List<Color> gradientColors;

  const _Member({
    required this.name,
    required this.role,
    required this.joinDate,
    required this.status,
    required this.initials,
    required this.gradientColors,
  });
}
