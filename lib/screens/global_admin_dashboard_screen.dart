import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'global_admin_church_review_screen.dart';

class GlobalAdminDashboardScreen extends StatefulWidget {
  const GlobalAdminDashboardScreen({super.key});

  @override
  State<GlobalAdminDashboardScreen> createState() =>
      _GlobalAdminDashboardScreenState();
}

class _GlobalAdminDashboardScreenState
    extends State<GlobalAdminDashboardScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int _filterIndex = 0;
  final Set<int> _actedChurches = {};
  final Set<int> _actedReports = {};

  static const sage = Color(0xFFB0C4B1);
  static const babyBlue = Color(0xFFA8D1E7);
  static const dustyRose = Color(0xFFD4A5A5);
  static const ivory = Color(0xFFFDFCF0);
  static const nude = Color(0xFFF5E6E0);

  static const _filters = [
    'All Entities',
    'Pending Approval',
    'Urgent Reports',
    'Verifications',
  ];

  static const _churchApps = [
    _ChurchApp(
      name: 'Grace Chapel',
      location: 'Austin, Texas',
      submittedAgo: '2h ago',
      icon: Icons.church,
      denomination: 'Baptist',
    ),
    _ChurchApp(
      name: 'Victory Church',
      location: 'London, UK',
      submittedAgo: '5h ago',
      icon: Icons.church_outlined,
      denomination: 'Pentecostal',
    ),
    _ChurchApp(
      name: 'River of Life',
      location: 'Sydney, AU',
      submittedAgo: '1d ago',
      icon: Icons.water,
      denomination: 'Non-denominational',
    ),
  ];

  static const _pastors = [
    _PastorVerif(
      name: 'Rev. Sarah Jenkins',
      credential: 'Master of Divinity',
      scanStatus: 'Scan Complete',
      statusColor: Color(0xFF22C55E),
      initials: 'SJ',
      gradientColors: [Color(0xFFB0C4B1), Color(0xFF7FA885)],
    ),
    _PastorVerif(
      name: 'Pastor David Chen',
      credential: 'Theology Cert',
      scanStatus: 'Scan In-Progress',
      statusColor: Color(0xFFF59E0B),
      initials: 'DC',
      gradientColors: [Color(0xFFA8D1E7), Color(0xFF60A5C8)],
    ),
    _PastorVerif(
      name: 'Dr. Elena Rodriguez',
      credential: 'PhD Theology',
      scanStatus: 'Scan Complete',
      statusColor: Color(0xFF22C55E),
      initials: 'ER',
      gradientColors: [Color(0xFFD4A5A5), Color(0xFFC07B7B)],
    ),
  ];

  static const _reports = [
    _Report(
      type: 'Flagged Content',
      severity: 'high',
      time: '14m ago',
      description:
          'Inappropriate language detected in "Sunday Morning" discussion thread at Victory Church.',
      action: 'Take Action',
    ),
    _Report(
      type: 'User Report',
      severity: 'medium',
      time: '45m ago',
      description:
          'Multiple users reported an unverified fundraising link shared in the public lounge.',
      action: 'Investigate',
    ),
    _Report(
      type: 'Access Breach',
      severity: 'high',
      time: '1h ago',
      description:
          'Unusual login attempt from a restricted region on \'Admin-Level-3\' account.',
      action: 'Lock Account',
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
    final bg =
        isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor =
        isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              color:
                  isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.admin_panel_settings,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Global Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined,
                            color: textColor),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: bg, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [sage, Color(0xFF7FA885)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'SA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 16, 16,
                    MediaQuery.of(context).padding.bottom + 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search ──────────────────────────────────────
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
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
                          const SizedBox(width: 14),
                          Icon(
                            Icons.search,
                            color: _query.isNotEmpty
                                ? AppColors.primary
                                : subColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (v) =>
                                  setState(() => _query = v),
                              style: TextStyle(
                                  fontSize: 14, color: textColor),
                              decoration: InputDecoration(
                                hintText:
                                    'Search churches, pastors, or reports…',
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
                                padding:
                                    const EdgeInsets.only(right: 12),
                                child: Icon(Icons.clear,
                                    size: 16, color: subColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Filter chips ─────────────────────────────────
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final active = i == _filterIndex;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _filterIndex = i),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary
                                    : cardBg,
                                borderRadius:
                                    BorderRadius.circular(99),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primary
                                      : borderColor,
                                ),
                              ),
                              child: Text(
                                _filters[i],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? Colors.white
                                      : subColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Stats cards ──────────────────────────────────
                    Row(
                      children: [
                        _StatCard(
                          label: 'Total Churches',
                          value: '1,240',
                          trend: '+5.2% this month',
                          icon: Icons.church,
                          color: sage,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Total Members',
                          value: '85,291',
                          trend: '+8.4% this month',
                          icon: Icons.groups,
                          color: babyBlue,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Growth',
                          value: '+12.8%',
                          trend: 'Outperforming goal',
                          icon: Icons.insights,
                          color: dustyRose,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ── Pending Church Applications ──────────────────
                    Row(
                      children: [
                        Text(
                          'Pending Church Applications',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Full applications list coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_churchApps.length, (i) {
                      final app = _churchApps[i];
                      final acted = _actedChurches.contains(i);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  GlobalAdminChurchReviewScreen(
                                churchName: app.name,
                                location: app.location,
                                denomination: app.denomination,
                                submittedAgo: app.submittedAgo,
                              ),
                            ),
                          ),
                          child: AnimatedOpacity(
                            opacity: acted ? 0.45 : 1.0,
                            duration:
                                const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius:
                                    BorderRadius.circular(14),
                                border:
                                    Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF0F172A)
                                          : ivory,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF334155)
                                            : nude,
                                      ),
                                    ),
                                    child: Icon(app.icon,
                                        color: AppColors.primary,
                                        size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${app.location} • Submitted ${app.submittedAgo}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: subColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (acted)
                                    Icon(Icons.check_circle,
                                        color:
                                            const Color(0xFF22C55E),
                                        size: 22)
                                  else
                                    Row(
                                      children: [
                                        _IconAction(
                                          icon:
                                              Icons.check_circle_outline,
                                          color:
                                              const Color(0xFF22C55E),
                                          bgColor: const Color(
                                                  0xFF22C55E)
                                              .withOpacity(0.08),
                                          onTap: () => setState(() =>
                                              _actedChurches.add(i)),
                                        ),
                                        const SizedBox(width: 6),
                                        _IconAction(
                                          icon: Icons.cancel_outlined,
                                          color:
                                              const Color(0xFFEF4444),
                                          bgColor: const Color(
                                                  0xFFEF4444)
                                              .withOpacity(0.08),
                                          onTap: () => setState(() =>
                                              _actedChurches.add(i)),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    // ── Pastor Verifications ─────────────────────────
                    Row(
                      children: [
                        Text(
                          'Pastor Verifications',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '12 PENDING',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children:
                            List.generate(_pastors.length, (i) {
                          final p = _pastors[i];
                          final isLast = i == _pastors.length - 1;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Stack(
                                      children: [
                                        Container(
                                          width: 46,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: p.gradientColors,
                                              begin: Alignment.topLeft,
                                              end:
                                                  Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              p.initials,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 13,
                                            height: 13,
                                            decoration: BoxDecoration(
                                              color: p.statusColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: cardBg,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${p.credential} • ${p.scanStatus}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: subColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review module coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 7),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Review',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                Divider(
                                    height: 1,
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFF1F5F9)),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Urgent Community Reports ─────────────────────
                    Row(
                      children: [
                        Icon(Icons.campaign,
                            color: const Color(0xFFEF4444), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Urgent Community Reports',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_reports.length, (i) {
                      final r = _reports[i];
                      final acted = _actedReports.contains(i);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AnimatedOpacity(
                          opacity: acted ? 0.4 : 1.0,
                          duration:
                              const Duration(milliseconds: 300),
                          child: _ReportCard(
                            report: r,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                            onAction: acted
                                ? null
                                : () => setState(
                                    () => _actedReports.add(i)),
                            onDismiss: acted
                                ? null
                                : () => setState(
                                    () => _actedReports.add(i)),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    // Footer
                    Center(
                      child: Text(
                        '© 2024 Ekklesia Global Admin System',
                        style: TextStyle(
                            fontSize: 11,
                            color: subColor.withOpacity(0.5)),
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: subColor,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.trending_up,
                    size: 12, color: const Color(0xFF22C55E)),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    trend,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF22C55E),
                      fontWeight: FontWeight.w600,
                    ),
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

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _IconAction({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final _Report report;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  const _ReportCard({
    required this.report,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isHigh = report.severity == 'high';
    final accentColor = isHigh
        ? const Color(0xFFEF4444)
        : const Color(0xFFF59E0B);
    final bgColor = isHigh
        ? const Color(0xFFEF4444).withOpacity(isDark ? 0.08 : 0.05)
        : const Color(0xFFF59E0B).withOpacity(isDark ? 0.08 : 0.05);
    final labelColor = isHigh
        ? const Color(0xFFDC2626)
        : const Color(0xFFD97706);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                report.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: labelColor,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                report.time,
                style: TextStyle(fontSize: 11, color: subColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.description,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF374151),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.action,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Dismiss',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: subColor,
                    ),
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

// ── Data models ───────────────────────────────────────────────────────────────

class _ChurchApp {
  final String name;
  final String location;
  final String submittedAgo;
  final IconData icon;
  final String denomination;

  const _ChurchApp({
    required this.name,
    required this.location,
    required this.submittedAgo,
    required this.icon,
    required this.denomination,
  });
}

class _PastorVerif {
  final String name;
  final String credential;
  final String scanStatus;
  final Color statusColor;
  final String initials;
  final List<Color> gradientColors;

  const _PastorVerif({
    required this.name,
    required this.credential,
    required this.scanStatus,
    required this.statusColor,
    required this.initials,
    required this.gradientColors,
  });
}

class _Report {
  final String type;
  final String severity;
  final String time;
  final String description;
  final String action;

  const _Report({
    required this.type,
    required this.severity,
    required this.time,
    required this.description,
    required this.action,
  });
}
