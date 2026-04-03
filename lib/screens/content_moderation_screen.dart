import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'bible_books_index_screen.dart';

class ContentModerationScreen extends StatefulWidget {
  const ContentModerationScreen({super.key});

  @override
  State<ContentModerationScreen> createState() =>
      _ContentModerationScreenState();
}

class _ContentModerationScreenState extends State<ContentModerationScreen> {
  int _tabIndex = 0;

  // Moderation item state: null=pending, true=approved, false=removed
  final _states = <int, bool?>{};

  void _act(int id, bool approve) {
    setState(() => _states[id] = approve);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(approve ? 'Content approved.' : 'Content removed.'),
        backgroundColor:
            approve ? const Color(0xFF10B981) : Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _flag(int id) {
    setState(() => _states[id] = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Content flagged for escalation.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final quoteBarBg = isDark
        ? const Color(0xFF0F172A).withOpacity(0.5)
        : const Color(0xFFF8F6F6);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final tabs = ['Testimonies', 'Comments', 'Posts'];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header + tabs
            Container(
              color: bg.withOpacity(0.9),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: textColor),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Content Moderation',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  // Tab bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: tabs.asMap().entries.map((e) {
                      final active = _tabIndex == e.key;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _tabIndex = e.key),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: active
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              e.value,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: active
                                    ? AppColors.primary
                                    : subColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Divider(height: 1, color: AppColors.primary.withOpacity(0.1)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    MediaQuery.of(context).padding.bottom + 90),
                children: [
                  // Heading + filter
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Reported ${tabs[_tabIndex]}  ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  '12 Pending',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content filters coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list,
                                color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Item 1 — Offensive Language (High Risk)
                  _ModerationCard(
                    id: 0,
                    initials: 'JD',
                    initialsColor: AppColors.primary,
                    reporterName: 'Reported by Jane Doe',
                    reason: 'Offensive Language',
                    time: '2h ago',
                    quote:
                        '"I think that your views are absolutely ridiculous and anyone who follows this ministry is blind. You should be ashamed of..."',
                    riskLabel: 'High Risk',
                    riskColor: Colors.red.shade400,
                    riskBg: Colors.red.shade50,
                    quoteBarColor:
                        AppColors.primary.withOpacity(0.3),
                    quoteBarBg: quoteBarBg,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    state: _states[0],
                    onApprove: () => _act(0, true),
                    onRemove: () => _act(0, false),
                    onFlag: () => _flag(0),
                    subColor: subColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 16),

                  // Item 2 — Spam
                  _ModerationCard(
                    id: 1,
                    initials: 'MK',
                    initialsColor: subColor,
                    reporterName: 'Reported by Mark Kasen',
                    reason: 'Potential Spam',
                    time: '5h ago',
                    quote:
                        '"Check out this amazing gift card offer at bit.ly/church-free-gift-2024! Just click and register now to win big rewards!"',
                    quoteBarColor: borderColor,
                    quoteBarBg: quoteBarBg,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    state: _states[1],
                    onApprove: () => _act(1, true),
                    onRemove: () => _act(1, false),
                    onFlag: () => _flag(1),
                    subColor: subColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 16),

                  // Item 3 — Inappropriate Media
                  _ModerationCard(
                    id: 2,
                    initials: 'SA',
                    initialsColor: AppColors.primary,
                    reporterName: 'Reported by Sarah Anderson',
                    reason: 'Inappropriate Media',
                    time: '1d ago',
                    quote:
                        '"Post: Sharing some thoughts on recent events in the community..."',
                    quoteBarColor: borderColor,
                    quoteBarBg: quoteBarBg,
                    hasMediaPlaceholder: true,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    state: _states[2],
                    onApprove: () => _act(2, true),
                    onRemove: () => _act(2, false),
                    onFlag: () => _flag(2),
                    subColor: subColor,
                    textColor: textColor,
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
              ? const Color(0xFF1E293B).withOpacity(0.97)
              : Colors.white.withOpacity(0.97),
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    active: false,
                    color: subColor),
                _NavItem(
                    icon: Icons.group_outlined,
                    label: 'Connect',
                    active: false,
                    color: subColor),
                Transform.translate(
                  offset: const Offset(0, -16),
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
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.menu_book,
                              color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                _NavItem(
                    icon: Icons.admin_panel_settings,
                    label: 'Admin',
                    active: true,
                    color: subColor),
                _NavItem(
                    icon: Icons.more_horiz,
                    label: 'More',
                    active: false,
                    color: subColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Moderation card ─────────────────────────────────────────────

class _ModerationCard extends StatelessWidget {
  final int id;
  final String initials;
  final Color initialsColor;
  final String reporterName;
  final String reason;
  final String time;
  final String quote;
  final String? riskLabel;
  final Color? riskColor;
  final Color? riskBg;
  final Color quoteBarColor;
  final Color quoteBarBg;
  final bool hasMediaPlaceholder;
  final Color cardBg;
  final Color borderColor;
  final bool? state; // null=pending, true=approved, false=removed
  final VoidCallback onApprove;
  final VoidCallback onRemove;
  final VoidCallback onFlag;
  final Color subColor;
  final Color textColor;

  const _ModerationCard({
    required this.id,
    required this.initials,
    required this.initialsColor,
    required this.reporterName,
    required this.reason,
    required this.time,
    required this.quote,
    this.riskLabel,
    this.riskColor,
    this.riskBg,
    required this.quoteBarColor,
    required this.quoteBarBg,
    this.hasMediaPlaceholder = false,
    required this.cardBg,
    required this.borderColor,
    required this.state,
    required this.onApprove,
    required this.onRemove,
    required this.onFlag,
    required this.subColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isActed = state != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActed ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reporter row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: initialsColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: initialsColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reporterName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Reason: $reason · $time',
                        style: TextStyle(
                            fontSize: 11, color: subColor),
                      ),
                    ],
                  ),
                ),
                if (riskLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: riskBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      riskLabel!,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: riskColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Media placeholder
            if (hasMediaPlaceholder) ...[
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueGrey.shade300,
                      Colors.blueGrey.shade500,
                    ],
                  ),
                ),
                child: Icon(Icons.image,
                    color: Colors.white.withOpacity(0.4), size: 40),
              ),
              const SizedBox(height: 8),
            ],

            // Quote block
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: quoteBarBg,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(color: quoteBarColor, width: 4),
                ),
              ),
              child: Text(
                quote,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  color: subColor,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Action buttons
            if (!isActed)
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Approve',
                      icon: Icons.check_circle_outline,
                      color: Colors.white,
                      bg: const Color(0xFF22C55E),
                      onTap: onApprove,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      label: 'Remove',
                      icon: Icons.delete_outline,
                      color: Colors.white,
                      bg: Colors.red.shade500,
                      onTap: onRemove,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      label: 'Flag',
                      icon: Icons.flag_outlined,
                      color: AppColors.primary,
                      bg: AppColors.primary.withOpacity(0.1),
                      onTap: onFlag,
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: state == true
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    state == true ? 'Approved' : 'Removed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: state == true
                          ? const Color(0xFF10B981)
                          : Colors.red.shade400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color color;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: active ? AppColors.primary : color, size: 22),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: active ? AppColors.primary : color,
          ),
        ),
      ],
    );
  }
}
