import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'church_member_list_screen.dart';
import 'church_events_list_screen.dart';
import 'treasury_lock_screen.dart';

class ChurchProfileDetailsScreen extends StatefulWidget {
  final String churchName;
  final String denomination;
  final String location;

  const ChurchProfileDetailsScreen({
    super.key,
    this.churchName = 'Grace Community Baptist',
    this.denomination = 'Baptist',
    this.location = 'Springfield, IL',
  });

  @override
  State<ChurchProfileDetailsScreen> createState() =>
      _ChurchProfileDetailsScreenState();
}

class _ChurchProfileDetailsScreenState
    extends State<ChurchProfileDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool _editing = false;
  bool _saving = false;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _nameCtrl = TextEditingController(text: widget.churchName);
    _descCtrl = TextEditingController(
      text:
          'A vibrant, Spirit-led community dedicated to worship, discipleship, and reaching our city with the love of Christ. We believe every person matters to God.',
    );
    _emailCtrl = TextEditingController(text: 'admin@gracecommunity.org');
    _phoneCtrl = TextEditingController(text: '+1 (217) 555-0142');
    _websiteCtrl = TextEditingController(text: 'www.gracecommunity.org');
    _addressCtrl =
        TextEditingController(text: '124 Maple Street, Springfield, IL 62701');
  }

  @override
  void dispose() {
    _tabs.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _websiteCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _saving = false;
      _editing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Church profile updated successfully'),
        backgroundColor: const Color(0xFF22C55E),
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
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Header
                  Container(
                    color:
                        isDark ? const Color(0xFF0F172A) : Colors.white,
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: textColor),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Church Profile',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _editing ? null : () => setState(() => _editing = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: _editing
                                  ? borderColor
                                  : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _editing
                                    ? borderColor
                                    : AppColors.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _editing ? Icons.edit : Icons.edit_outlined,
                                  size: 14,
                                  color: _editing
                                      ? subColor
                                      : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _editing
                                        ? subColor
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: borderColor),

                  // Cover banner + identity
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Banner
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      widget.denomination,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.churchName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 13,
                                          color: Colors.white54),
                                      const SizedBox(width: 3),
                                      Text(
                                        widget.location,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
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

                  // Stats row
                  Container(
                    color: cardBg,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        _StatCell(
                            value: '342',
                            label: 'Members',
                            color: sage),
                        _Divider(),
                        _StatCell(
                            value: '24',
                            label: 'Events / yr',
                            color: babyBlue),
                        _Divider(),
                        _StatCell(
                            value: '1998',
                            label: 'Founded',
                            color: AppColors.primary),
                        _Divider(),
                        _StatCell(
                            value: '4.8',
                            label: 'Rating',
                            color: const Color(0xFFF59E0B)),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: borderColor),

                  // Status strip
                  Container(
                    color: const Color(0xFF22C55E).withOpacity(0.06),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Verified Church · Active',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.verified,
                            size: 16, color: Color(0xFF22C55E)),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: borderColor),

                  // Tab bar
                  Container(
                    color: cardBg,
                    child: TabBar(
                      controller: _tabs,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: subColor,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 2.5,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 12),
                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.w500),
                      tabs: const [
                        Tab(text: 'Details'),
                        Tab(text: 'Members'),
                        Tab(text: 'Events'),
                        Tab(text: 'Finances'),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: borderColor),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabs,
            children: [
              // ─── Details tab ───
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_editing) ...[
                      _SectionTitle(title: 'Edit Church Info', textColor: textColor),
                      const SizedBox(height: 12),
                      _EditField(
                        label: 'Church Name',
                        ctrl: _nameCtrl,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        inputBg: inputBg,
                      ),
                      const SizedBox(height: 12),
                      _EditField(
                        label: 'Description',
                        ctrl: _descCtrl,
                        maxLines: 4,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        inputBg: inputBg,
                      ),
                      const SizedBox(height: 12),
                      _EditField(
                        label: 'Email',
                        ctrl: _emailCtrl,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        inputBg: inputBg,
                      ),
                      const SizedBox(height: 12),
                      _EditField(
                        label: 'Phone',
                        ctrl: _phoneCtrl,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        inputBg: inputBg,
                      ),
                      const SizedBox(height: 12),
                      _EditField(
                        label: 'Website',
                        ctrl: _websiteCtrl,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        inputBg: inputBg,
                      ),
                      const SizedBox(height: 12),
                      _EditField(
                        label: 'Address',
                        ctrl: _addressCtrl,
                        maxLines: 2,
                        textColor: textColor,
                        subColor: subColor,
                        borderColor: borderColor,
                        inputBg: inputBg,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _editing = false),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: subColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14)),
                              ),
                              child: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _SectionTitle(title: 'About', textColor: textColor),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          _descCtrl.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: subColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _SectionTitle(title: 'Service Times', textColor: textColor),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            _ServiceRow(
                              day: 'Sunday',
                              times: '9:00 AM & 11:00 AM',
                              textColor: textColor,
                              subColor: subColor,
                            ),
                            Divider(height: 20, color: borderColor),
                            _ServiceRow(
                              day: 'Wednesday',
                              times: '6:30 PM (Midweek)',
                              textColor: textColor,
                              subColor: subColor,
                            ),
                            Divider(height: 20, color: borderColor),
                            _ServiceRow(
                              day: 'Friday',
                              times: '7:00 PM (Prayer Night)',
                              textColor: textColor,
                              subColor: subColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _SectionTitle(title: 'Contact', textColor: textColor),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            _ContactRow(
                              icon: Icons.email_outlined,
                              value: _emailCtrl.text,
                              color: babyBlue,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                            Divider(height: 20, color: borderColor),
                            _ContactRow(
                              icon: Icons.phone_outlined,
                              value: _phoneCtrl.text,
                              color: sage,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                            Divider(height: 20, color: borderColor),
                            _ContactRow(
                              icon: Icons.language_outlined,
                              value: _websiteCtrl.text,
                              color: AppColors.primary,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                            Divider(height: 20, color: borderColor),
                            _ContactRow(
                              icon: Icons.location_on_outlined,
                              value: _addressCtrl.text,
                              color: dustyRose,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _SectionTitle(title: 'Ministries', textColor: textColor),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Worship & Arts',
                          'Youth Ministry',
                          'Children Church',
                          'Men\'s Fellowship',
                          'Women\'s Ministry',
                          'Cell Groups',
                          'Missions & Outreach',
                          'Prayer Team',
                          'Media & Tech',
                          'Ushering',
                        ].map((m) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        AppColors.primary.withOpacity(0.2)),
                              ),
                              child: Text(
                                m,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            )).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // ─── Members tab ───
              ChurchMemberListScreen(),

              // ─── Events tab ───
              ChurchEventsListScreen(
                churchName: widget.churchName,
                embedded: true,
              ),

              // ─── Finances tab ───
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Balance',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '\$42,850.12',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.trending_up,
                                  size: 14, color: Color(0xFF22C55E)),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TreasuryLockScreen()),
                      ),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'View Treasury Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _SectionTitle(title: 'Quick Stats', textColor: textColor),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _FinStat(
                          label: 'Monthly Income',
                          value: '\$13,040',
                          color: const Color(0xFF22C55E),
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                          borderColor: borderColor,
                        ),
                        const SizedBox(width: 10),
                        _FinStat(
                          label: 'Monthly Expenses',
                          value: '\$9,762',
                          color: const Color(0xFFEF4444),
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                          borderColor: borderColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;
  const _SectionTitle({required this.title, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatCell(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF1E293B);
    final subColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color)),
          Text(label,
              style: TextStyle(fontSize: 9, color: subColor),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF334155)
            : const Color(0xFFE5E7EB);
    return Container(width: 1, height: 28, color: borderColor);
  }
}

class _ServiceRow extends StatelessWidget {
  final String day;
  final String times;
  final Color textColor;
  final Color subColor;
  const _ServiceRow(
      {required this.day,
      required this.times,
      required this.textColor,
      required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor)),
        Text(times, style: TextStyle(fontSize: 12, color: subColor)),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final Color textColor;
  final Color subColor;
  const _ContactRow(
      {required this.icon,
      required this.value,
      required this.color,
      required this.textColor,
      required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value,
              style: TextStyle(fontSize: 13, color: textColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
        Icon(Icons.chevron_right, size: 16, color: subColor),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final int maxLines;
  final Color textColor;
  final Color subColor;
  final Color borderColor;
  final Color inputBg;

  const _EditField({
    required this.label,
    required this.ctrl,
    this.maxLines = 1,
    required this.textColor,
    required this.subColor,
    required this.borderColor,
    required this.inputBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: TextStyle(fontSize: 13, color: textColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _FinStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final Color borderColor;

  const _FinStat({
    required this.label,
    required this.value,
    required this.color,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: TextStyle(fontSize: 11, color: subColor)),
          ],
        ),
      ),
    );
  }
}
