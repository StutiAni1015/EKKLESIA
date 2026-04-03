import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'treasury_lock_screen.dart';
import '../core/user_session.dart';
import 'create_poll_screen.dart';
import 'poll_results_screen.dart';
import 'update_treasury_account_screen.dart';
import 'bible_books_index_screen.dart';

class ChurchCommitteeHubScreen extends StatefulWidget {
  const ChurchCommitteeHubScreen({super.key});

  @override
  State<ChurchCommitteeHubScreen> createState() =>
      _ChurchCommitteeHubScreenState();
}

class _ChurchCommitteeHubScreenState
    extends State<ChurchCommitteeHubScreen> {
  int _navIndex = 0;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);
  static const ivory = Color(0xFFFDFBF7);

  static const _polls = [
    _PollPreview(
      question: 'What time should Sunday service start?',
      votes: 311,
      closesIn: '5 days',
      isActive: true,
    ),
    _PollPreview(
      question: 'Should we add a Friday evening prayer service?',
      votes: 198,
      closesIn: 'Closed',
      isActive: false,
    ),
    _PollPreview(
      question: 'Theme for the Annual Retreat 2024?',
      votes: 87,
      closesIn: '12 days',
      isActive: true,
    ),
  ];

  static const _minutes = [
    _Minute(
      title: 'Committee Meeting — March 2024',
      date: 'Mar 10, 2024',
      attendees: 8,
    ),
    _Minute(
      title: 'Emergency Session — Budget Review',
      date: 'Feb 28, 2024',
      attendees: 5,
    ),
    _Minute(
      title: 'Committee Meeting — February 2024',
      date: 'Feb 12, 2024',
      attendees: 9,
    ),
  ];

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
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final navBg = isDark ? const Color(0xFF0F172A) : ivory;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                    child: Icon(Icons.groups_2_outlined,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Committee Hub',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Grace Community Church',
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
                            color: textColor),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Committee notifications coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
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
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Treasury summary — locked unless a valid session exists
                    ValueListenableBuilder<TreasuryAccessSession?>(
                      valueListenable: treasuryAccessNotifier,
                      builder: (context, session, _) {
                        final unlocked =
                            session != null && !session.isExpired;
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TreasuryLockScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1E293B),
                                  Color(0xFF0F172A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: unlocked
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.account_balance_wallet,
                                              color: AppColors.primary,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Treasury Overview',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right,
                                              color: AppColors.primary,
                                              size: 16),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        '\$42,850.12',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Row(
                                        children: [
                                          Icon(Icons.trending_up,
                                              size: 13,
                                              color: Color(0xFF22C55E)),
                                          SizedBox(width: 4),
                                          Text(
                                            '+\$3,240 this month',
                                            style: TextStyle(
                                              color: Color(0xFF22C55E),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _TxChip(
                                            label: 'Income',
                                            value: '\$8,340',
                                            color: const Color(0xFF22C55E),
                                          ),
                                          const SizedBox(width: 8),
                                          _TxChip(
                                            label: 'Expenses',
                                            value: '\$1,582',
                                            color: const Color(0xFFEF4444),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.lock_rounded,
                                              color: Color(0xFFEF4444),
                                              size: 18),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Treasury — Locked',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Text(
                                            'Enter Code',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right,
                                              color: AppColors.primary,
                                              size: 16),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.white.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        child: const Column(
                                          children: [
                                            Text('••••••••',
                                                style: TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 8,
                                                )),
                                            SizedBox(height: 6),
                                            Text(
                                              'Requires access code from pastor\nor treasurer to view',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 11,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Quick actions
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _QuickAction(
                          icon: Icons.how_to_vote_outlined,
                          label: 'New Poll',
                          color: sage,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const CreatePollScreen()),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _QuickAction(
                          icon: Icons.add_task,
                          label: 'Log Transaction',
                          color: AppColors.primary,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const UpdateTreasuryAccountScreen()),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _QuickAction(
                          icon: Icons.announcement_outlined,
                          label: 'Announce',
                          color: babyBlue,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Announce feature coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                        ),
                        const SizedBox(width: 10),
                        _QuickAction(
                          icon: Icons.edit_document,
                          label: 'Minutes',
                          color: dustyRose,
                          isDark: isDark,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meeting minutes coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Active polls
                    Row(
                      children: [
                        Icon(Icons.poll_outlined,
                            color: sage, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Community Polls',
                          style: TextStyle(
                            fontSize: 15,
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
                                    const CreatePollScreen()),
                          ),
                          child: Text(
                            '+ New',
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
                    ..._polls.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const PollResultsScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: p.isActive
                                    ? sage.withOpacity(0.3)
                                    : borderColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: (p.isActive
                                            ? sage
                                            : subColor)
                                        .withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.how_to_vote,
                                      color: p.isActive
                                          ? sage
                                          : subColor,
                                      size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.question,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            '${p.votes} votes',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: subColor),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 3,
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: subColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            p.closesIn == 'Closed'
                                                ? 'Closed'
                                                : 'Closes in ${p.closesIn}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: p.isActive
                                                  ? const Color(
                                                      0xFF22C55E)
                                                  : subColor,
                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right,
                                    color: subColor, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Meeting minutes
                    Row(
                      children: [
                        Icon(Icons.description_outlined,
                            color: dustyRose, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Meeting Minutes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._minutes.map(
                      (m) => Padding(
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
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      dustyRose.withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.article_outlined,
                                    color: dustyRose, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today_outlined,
                                            size: 11,
                                            color: subColor),
                                        const SizedBox(width: 4),
                                        Text(m.date,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: subColor)),
                                        const SizedBox(width: 8),
                                        Icon(Icons.people_outline,
                                            size: 11,
                                            color: subColor),
                                        const SizedBox(width: 3),
                                        Text(
                                            '${m.attendees} present',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: subColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.download_outlined,
                                  color: subColor, size: 18),
                            ],
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
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(
            top: BorderSide(color: borderColor),
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
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Hub',
                    active: _navIndex == 0,
                    onTap: () => setState(() => _navIndex = 0)),
                _NavItem(
                    icon: Icons.account_balance_wallet_outlined,
                    activeIcon: Icons.account_balance_wallet,
                    label: 'Treasury',
                    active: _navIndex == 1,
                    onTap: () {
                      setState(() => _navIndex = 1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const TreasuryLockScreen()),
                      );
                    }),
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
                                color: AppColors.primary
                                    .withOpacity(0.35),
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
                    icon: Icons.poll_outlined,
                    activeIcon: Icons.poll,
                    label: 'Polls',
                    active: _navIndex == 3,
                    onTap: () {
                      setState(() => _navIndex = 3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const CreatePollScreen()),
                      );
                    }),
                _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TxChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TxChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13)),
        Text(label,
            style: const TextStyle(
                color: Colors.white54, fontSize: 10)),
      ],
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
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class _PollPreview {
  final String question;
  final int votes;
  final String closesIn;
  final bool isActive;

  const _PollPreview({
    required this.question,
    required this.votes,
    required this.closesIn,
    required this.isActive,
  });
}

class _Minute {
  final String title;
  final String date;
  final int attendees;

  const _Minute(
      {required this.title,
      required this.date,
      required this.attendees});
}
