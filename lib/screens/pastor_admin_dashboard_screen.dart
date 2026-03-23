import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'bible_books_index_screen.dart';
import 'review_member_approval_screen.dart';
import 'content_moderation_screen.dart';
import 'pastor_send_notification_screen.dart';

class PastorAdminDashboardScreen extends StatefulWidget {
  const PastorAdminDashboardScreen({super.key});

  @override
  State<PastorAdminDashboardScreen> createState() =>
      _PastorAdminDashboardScreenState();
}

class _PastorAdminDashboardScreenState
    extends State<PastorAdminDashboardScreen> {
  int _navIndex = 4; // Admin active

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final borderThin =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: bg.withOpacity(0.85),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Pastor Administration',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      Icon(Icons.notifications_outlined,
                          color: subColor, size: 24),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: bg, width: 2),
                          ),
                        ),
                      ),
                    ],
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
                  // Profile card
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              AppColors.primary.withOpacity(0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primary, width: 2),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD7A49A),
                                  AppColors.primary,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'SA',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pastor Samuel Adebayo',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Grace Global Church',
                                  style: TextStyle(
                                      fontSize: 13, color: subColor),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(99),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.verified,
                                          color: AppColors.primary,
                                          size: 12),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified Leader',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
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
                  ),

                  // Admin Dashboard grid
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Dashboard',
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
                          childAspectRatio: 1.2,
                          children: [
                            // Member Approvals — with badge
                            Stack(
                              children: [
                                _DashCard(
                                  icon: Icons.person_add_outlined,
                                  iconBg:
                                      const Color(0xFFFFEDD5),
                                  iconColor: AppColors.primary,
                                  label: 'Member Approvals',
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ReviewMemberApprovalScreen(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius:
                                          BorderRadius.circular(99),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.4),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      '12 New',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _DashCard(
                              icon: Icons.church_outlined,
                              iconBg: const Color(0xFFDBEAFE),
                              iconColor: const Color(0xFF2563EB),
                              label: 'Church Profile',
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                              onTap: () {},
                            ),
                            _DashCard(
                              icon: Icons.gavel,
                              iconBg: const Color(0xFFF3E8FF),
                              iconColor: const Color(0xFF9333EA),
                              label: 'Community Moderation',
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ContentModerationScreen(),
                                ),
                              ),
                            ),
                            _DashCard(
                              icon: Icons.campaign_outlined,
                              iconBg: const Color(0xFFDCFCE7),
                              iconColor: const Color(0xFF16A34A),
                              label: 'Broadcast',
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const PastorSendNotificationScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Full-width Ministry Reports
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(16),
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
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE4E6),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.bar_chart,
                                      color: Color(0xFFE11D48),
                                      size: 24),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'Ministry Reports & Stats',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.chevron_right,
                                    color: subColor.withOpacity(0.4),
                                    size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Recent Activity
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
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
                              onPressed: () {},
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
                        Column(
                          children: [
                            _ActivityRow(
                              avatar: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD7A49A),
                                      Color(0xFFE4C9B6),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                    child: Text('SJ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                              ),
                              text: 'Sarah Jenkins applied for membership',
                              time: '2 minutes ago',
                              textColor: textColor,
                              subColor: subColor,
                              cardBg: cardBg,
                              borderColor: borderThin,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ReviewMemberApprovalScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _ActivityRow(
                              avatar: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.shade100,
                                ),
                                child: Icon(Icons.report,
                                    color: Colors.red.shade600, size: 20),
                              ),
                              text:
                                  'Post reported: "Prayer Request..."',
                              time: '45 minutes ago',
                              textColor: textColor,
                              subColor: subColor,
                              cardBg: cardBg,
                              borderColor: borderThin,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ContentModerationScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _ActivityRow(
                              avatar: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFA4B1BA),
                                      Color(0xFFB8C4B5),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                    child: Text('MC',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                              ),
                              text:
                                  'Michael Chen applied for membership',
                              time: '1 hour ago',
                              textColor: textColor,
                              subColor: subColor,
                              cardBg: cardBg,
                              borderColor: borderThin,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ReviewMemberApprovalScreen(),
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
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
                _BottomNavItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    active: _navIndex == 0,
                    onTap: () => setState(() => _navIndex = 0),
                    subColor: subColor),
                _BottomNavItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Feed',
                    active: _navIndex == 1,
                    onTap: () => setState(() => _navIndex = 1),
                    subColor: subColor),
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
                          width: 56,
                          height: 56,
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
                                color:
                                    AppColors.primary.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.menu_book,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 2),
                        Text('BIBLE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            )),
                      ],
                    ),
                  ),
                ),
                _BottomNavItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Events',
                    active: _navIndex == 3,
                    onTap: () => setState(() => _navIndex = 3),
                    subColor: subColor),
                _BottomNavItem(
                    icon: Icons.admin_panel_settings,
                    label: 'Admin',
                    active: _navIndex == 4,
                    onTap: () => setState(() => _navIndex = 4),
                    subColor: subColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Supporting widgets ──────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _DashCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Widget avatar;
  final String text;
  final String time;
  final Color textColor;
  final Color subColor;
  final Color cardBg;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActivityRow({
    required this.avatar,
    required this.text,
    required this.time,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: subColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: subColor.withOpacity(0.4), size: 16),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color subColor;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : subColor;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight:
                  active ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
