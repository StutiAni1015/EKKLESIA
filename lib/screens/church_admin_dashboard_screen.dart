import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'bible_books_index_screen.dart';
import 'church_payment_methods_screen.dart';

class ChurchAdminDashboardScreen extends StatefulWidget {
  const ChurchAdminDashboardScreen({super.key});

  @override
  State<ChurchAdminDashboardScreen> createState() =>
      _ChurchAdminDashboardScreenState();
}

class _ChurchAdminDashboardScreenState
    extends State<ChurchAdminDashboardScreen> {
  int _navIndex = 0;

  static const _stats = [
    ('Total Members', '12,840', '+2.4%', Icons.trending_up, Color(0xFF10B981)),
    ('Verifications', '42', 'Needs review', Icons.pending, AppColors.primary),
    ('Giving Requests', '15', 'Pending Action', Icons.account_balance_wallet,
        Color(0xFFF59E0B)),
    ('New Prayers', '128', '+12%', Icons.emergency_share, Color(0xFF10B981)),
  ];

  static const _menuItems = [
    (
      'Member Approvals',
      'Review facial scans and ID documents',
      Icons.face_retouching_natural,
      Color(0xFFDBEAFE), // serene blue
      Color(0xFF2563EB),
    ),
    (
      'Giving Requests',
      'Approve or moderate fund requests',
      Icons.volunteer_activism,
      Color(0xFFFFF3E0), // serene peach
      Color(0xFFEA580C),
    ),
    (
      'Content Moderation',
      'Filter testimonies, posts & comments',
      Icons.rate_review,
      Color(0xFFE8F5E9), // serene sage
      Color(0xFF059669),
    ),
    (
      'Event Planning',
      'Organize global services and meetups',
      Color(0xFFF1F5F9),
      Icons.calendar_today,
      Color(0xFF475569),
    ),
  ];

  static const _activityItems = [
    (
      'Sarah Jenkins',
      'Submitted a new facial scan for verification in Lagos Chapter.',
      'Just Now',
      true, // has action buttons
      false, // is prayer
    ),
    (
      'New Prayer Request',
      '"Please pray for the recovery of my family in Florida..."',
      '12m ago',
      false,
      true,
    ),
    (
      'David Chen',
      'Requested \$200 for Emergency Medical Fund. Awaiting moderation.',
      '45m ago',
      false,
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1C1917) : Colors.white;
    final dividerColor =
        isDark ? const Color(0xFF292524) : const Color(0xFFF1F5F9);
    final borderColor =
        isDark ? const Color(0xFF292524) : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
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
                    child: const Icon(Icons.temple_buddhist,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grace Global Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Overseeing the Global Community',
                          style: TextStyle(
                              fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined,
                            color: subColor, size: 24),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notifications coming soon!'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.15),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2),
                    ),
                    child: const Icon(Icons.person,
                        color: AppColors.primary, size: 20),
                  ),
                ],
              ),
            ),

            // Scrollable body
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).padding.bottom + 80),
                children: [
                  // Welcome banner
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF1C1917),
                                  const Color(0xFF292524),
                                ]
                              : [
                                  const Color(0xFFE0F2F1),
                                  const Color(0xFFE8F5E9),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Admin',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Your community is growing. You have 42 pending verifications today.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: subColor,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF334155)
                                      .withOpacity(0.6)
                                  : Colors.white.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'Last login: 2 mins ago',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Stats grid
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: _stats.map((s) {
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                s.$1,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: subColor,
                                ),
                              ),
                              Text(
                                s.$2,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(s.$4, color: s.$5, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    s.$3,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: s.$5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Management Console
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Management Console',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.6,
                          children: [
                            _ConsoleCard(
                              title: 'Member Approvals',
                              subtitle: 'Review facial scans and ID documents',
                              icon: Icons.face_retouching_natural,
                              iconBg: const Color(0xFFDBEAFE),
                              iconColor: const Color(0xFF2563EB),
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Member Approvals coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                            ),
                            _ConsoleCard(
                              title: 'Giving Requests',
                              subtitle: 'Approve or moderate fund requests',
                              icon: Icons.volunteer_activism,
                              iconBg: const Color(0xFFFFF3E0),
                              iconColor: const Color(0xFFEA580C),
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giving Requests coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                            ),
                            _ConsoleCard(
                              title: 'Content Moderation',
                              subtitle:
                                  'Filter testimonies, posts & comments',
                              icon: Icons.rate_review,
                              iconBg: const Color(0xFFE8F5E9),
                              iconColor: const Color(0xFF059669),
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content Moderation coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                            ),
                            _ConsoleCard(
                              title: 'Event Planning',
                              subtitle:
                                  'Organize global services and meetups',
                              icon: Icons.calendar_today,
                              iconBg: const Color(0xFFF1F5F9),
                              iconColor: const Color(0xFF475569),
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event Planning coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                            ),
                            _ConsoleCard(
                              title: 'Payment Accounts',
                              subtitle: 'Manage UPI, cards, PayPal & bank accounts',
                              icon: Icons.account_balance,
                              iconBg: const Color(0xFFDCFCE7),
                              iconColor: const Color(0xFF059669),
                              cardBg: cardBg,
                              borderColor: borderColor,
                              subColor: subColor,
                              textColor: textColor,
                              onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const ChurchPaymentMethodsScreen())),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Recent Activity
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Full activity log coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Activity 1 — facial scan
                              _ActivityTile(
                                avatarWidget: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFD7A49A),
                                        Color(0xFFE4C9B6),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('SJ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                                title: 'Sarah Jenkins',
                                body:
                                    'Submitted a new facial scan for verification in Lagos Chapter.',
                                time: 'JUST NOW',
                                textColor: textColor,
                                subColor: subColor,
                                dividerColor: dividerColor,
                                trailing: Row(
                                  children: [
                                    _ActionChip(
                                        label: 'Review',
                                        isPrimary: true),
                                    const SizedBox(width: 8),
                                    _ActionChip(
                                        label: 'Dismiss',
                                        isPrimary: false),
                                  ],
                                ),
                              ),

                              // Activity 2 — prayer
                              _ActivityTile(
                                avatarWidget: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary
                                        .withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    Icons.volunteer_activism,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                title: 'New Prayer Request',
                                body:
                                    '"Please pray for the recovery of my family in Florida..."',
                                time: '12M AGO',
                                textColor: textColor,
                                subColor: subColor,
                                dividerColor: dividerColor,
                              ),

                              // Activity 3 — giving
                              _ActivityTile(
                                avatarWidget: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFA4B1BA),
                                        Color(0xFFB8C4B5),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('DC',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                                title: 'David Chen',
                                body:
                                    'Requested \$200 for Emergency Medical Fund. Awaiting moderation.',
                                time: '45M AGO',
                                textColor: textColor,
                                subColor: subColor,
                                dividerColor: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1C1917).withOpacity(0.97)
              : Colors.white.withOpacity(0.97),
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AdminNavItem(
                    icon: Icons.dashboard,
                    label: 'Admin',
                    active: _navIndex == 0,
                    onTap: () => setState(() => _navIndex = 0)),
                _AdminNavItem(
                    icon: Icons.groups,
                    label: 'People',
                    active: _navIndex == 1,
                    onTap: () => setState(() => _navIndex = 1)),

                // Elevated Bible FAB
                Transform.translate(
                  offset: const Offset(0, -18),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BibleBooksIndexScreen(),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.backgroundDark
                                  : const Color(0xFFF8F6F6),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.menu_book,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'BIBLE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _AdminNavItem(
                    icon: Icons.campaign_outlined,
                    label: 'Broadcast',
                    active: _navIndex == 3,
                    onTap: () => setState(() => _navIndex = 3)),
                _AdminNavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
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

// ─── Supporting widgets ──────────────────────────────────────────

class _ConsoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color cardBg;
  final Color borderColor;
  final Color subColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ConsoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.cardBg,
    required this.borderColor,
    required this.subColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const Spacer(),
                Icon(Icons.chevron_right,
                    color: subColor.withOpacity(0.4), size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: subColor, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Widget avatarWidget;
  final String title;
  final String body;
  final String time;
  final Color textColor;
  final Color subColor;
  final Color dividerColor;
  final Widget? trailing;

  const _ActivityTile({
    required this.avatarWidget,
    required this.title,
    required this.body,
    required this.time,
    required this.textColor,
    required this.subColor,
    required this.dividerColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatarWidget,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 0.5,
                            color: subColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: subColor,
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(height: 10),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: dividerColor),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final bool isPrimary;
  const _ActionChip({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isPrimary
              ? Colors.white
              : const Color(0xFF475569),
        ),
      ),
    );
  }
}

class _AdminNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _AdminNavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : const Color(0xFF94A3B8);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
