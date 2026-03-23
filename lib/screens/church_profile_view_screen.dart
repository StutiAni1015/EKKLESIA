import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'church_events_list_screen.dart';
import 'find_your_church_screen.dart';
import 'church_member_list_screen.dart';

class ChurchProfileViewScreen extends StatefulWidget {
  final String churchName;
  final String denomination;
  final String location;
  final bool isMember;

  const ChurchProfileViewScreen({
    super.key,
    this.churchName = 'Grace Community Church',
    this.denomination = 'Non-denominational',
    this.location = '123 Serene Way, Ivory City',
    this.isMember = false,
  });

  @override
  State<ChurchProfileViewScreen> createState() =>
      _ChurchProfileViewScreenState();
}

class _ChurchProfileViewScreenState
    extends State<ChurchProfileViewScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool _following = false;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);
  static const ivory = Color(0xFFFDFBF7);
  static const nude = Color(0xFFF4EAE0);

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _following = widget.isMember;
  }

  @override
  void dispose() {
    _tabs.dispose();
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
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // ── Cover banner ──────────────────────────────────
                  Stack(
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              sage.withOpacity(0.7),
                              babyBlue.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.church,
                            size: 56,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                      // Back button
                      Positioned(
                        top: 12,
                        left: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      // Share
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.share_outlined,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Church identity ───────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      children: [
                        // Logo + name row
                        Transform.translate(
                          offset: const Offset(0, -24),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [
                                            const Color(0xFF334155),
                                            const Color(0xFF1E293B)
                                          ]
                                        : [ivory, nude],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(Icons.church,
                                    color: AppColors.primary,
                                    size: 34),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => setState(
                                            () => _following =
                                                !_following),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 250),
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 16,
                                              vertical: 9),
                                          decoration: BoxDecoration(
                                            color: _following
                                                ? sage
                                                : AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                          ),
                                          child: Text(
                                            _following
                                                ? 'Member ✓'
                                                : 'Join Church',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                                  FontWeight.w700,
                                              fontSize: 13,
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
                        Transform.translate(
                          offset: const Offset(0, -16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.churchName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.verified,
                                      color: AppColors.primary,
                                      size: 18),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 13, color: subColor),
                                  const SizedBox(width: 3),
                                  Text(widget.location,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: subColor)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.denomination,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Stats row ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        _StatPill(
                            label: '1,718',
                            sublabel: 'Members',
                            color: sage,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subColor: subColor,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const ChurchMemberListScreen()),
                            )),
                        const SizedBox(width: 10),
                        _StatPill(
                            label: '12',
                            sublabel: 'Events',
                            color: babyBlue,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subColor: subColor),
                        const SizedBox(width: 10),
                        _StatPill(
                            label: '15 yrs',
                            sublabel: 'Est.',
                            color: dustyRose,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subColor: subColor),
                      ],
                    ),
                  ),

                  // ── Tab bar ───────────────────────────────────────
                  Container(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : Colors.white,
                    child: TabBar(
                      controller: _tabs,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: subColor,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 2.5,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13),
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Events'),
                        Tab(text: 'Leaders'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabs,
            children: [
              // ── About tab ───────────────────────────────────────
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _InfoCard(
                    title: 'About Us',
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    child: Text(
                      '"${widget.churchName}" is a vibrant faith community committed to worship, discipleship, and outreach. We welcome all people regardless of background, and believe in the power of community to transform lives.',
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: subColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Service Times',
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    child: Column(
                      children: [
                        _ServiceRow(
                            day: 'Sunday',
                            time: '9:00 AM & 11:00 AM',
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor),
                        _ServiceRow(
                            day: 'Wednesday',
                            time: '7:00 PM (Mid-week)',
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor),
                        _ServiceRow(
                            day: 'Friday',
                            time: '6:30 PM (Youth)',
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor,
                            isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Ministries',
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Youth Ministry',
                        'Prayer Team',
                        'Worship',
                        'Children\'s Church',
                        'Evangelism',
                        'Hospitality',
                      ]
                          .map((m) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: sage.withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          sage.withOpacity(0.3)),
                                ),
                                child: Text(m,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF374151),
                                    )),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Contact',
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    child: Column(
                      children: [
                        _ContactRow(
                          icon: Icons.language,
                          value: 'gracecommunity.church',
                          color: AppColors.primary,
                          subColor: subColor,
                        ),
                        _ContactRow(
                          icon: Icons.email_outlined,
                          value: 'hello@gracecommunity.church',
                          color: AppColors.primary,
                          subColor: subColor,
                        ),
                        _ContactRow(
                          icon: Icons.phone_outlined,
                          value: '+1 (512) 555-0180',
                          color: AppColors.primary,
                          subColor: subColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Events tab ───────────────────────────────────────
              Builder(
                builder: (_) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChurchEventsListScreen(
                              churchName: widget.churchName,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary
                                    .withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.event_outlined,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'View All Church Events',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.chevron_right,
                                  color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ChurchEventsListScreen(
                        churchName: widget.churchName,
                        embedded: true,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Leaders tab ──────────────────────────────────────
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _LeaderCard(
                    name: 'Pastor Samuel Adebayo',
                    role: 'Senior Pastor',
                    initials: 'SA',
                    gradientColors: const [sage, Color(0xFF7FA885)],
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    isVerified: true,
                  ),
                  const SizedBox(height: 10),
                  _LeaderCard(
                    name: 'Deacon Grace Osei',
                    role: 'Worship Director',
                    initials: 'GO',
                    gradientColors: const [babyBlue, Color(0xFF60A5C8)],
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    isVerified: false,
                  ),
                  const SizedBox(height: 10),
                  _LeaderCard(
                    name: 'Elder Mary Nwosu',
                    role: 'Youth Ministry Lead',
                    initials: 'MN',
                    gradientColors: const [
                      dustyRose,
                      Color(0xFFC07B7B)
                    ],
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    subColor: subColor,
                    isVerified: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final VoidCallback? onTap;

  const _StatPill({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textColor)),
              Text(sublabel,
                  style: TextStyle(
                      fontSize: 10, color: subColor)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _InfoCard({
    required this.title,
    required this.child,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String day;
  final String time;
  final Color subColor;
  final Color textColor;
  final Color borderColor;
  final bool isLast;

  const _ServiceRow({
    required this.day,
    required this.time,
    required this.subColor,
    required this.textColor,
    required this.borderColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: Text(day,
                    style: TextStyle(
                        fontSize: 12, color: subColor)),
              ),
              Text(time,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor)),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: borderColor),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final Color subColor;

  const _ContactRow({
    required this.icon,
    required this.value,
    required this.color,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(value,
              style:
                  TextStyle(fontSize: 13, color: subColor)),
        ],
      ),
    );
  }
}

class _LeaderCard extends StatelessWidget {
  final String name;
  final String role;
  final String initials;
  final List<Color> gradientColors;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final bool isVerified;

  const _LeaderCard({
    required this.name,
    required this.role,
    required this.initials,
    required this.gradientColors,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textColor)),
                    if (isVerified) ...[
                      const SizedBox(width: 5),
                      Icon(Icons.verified,
                          color: AppColors.primary, size: 14),
                    ],
                  ],
                ),
                Text(role,
                    style:
                        TextStyle(fontSize: 12, color: subColor)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: subColor, size: 18),
        ],
      ),
    );
  }
}
