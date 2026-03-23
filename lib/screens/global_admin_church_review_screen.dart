import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class GlobalAdminChurchReviewScreen extends StatefulWidget {
  final String churchName;
  final String location;
  final String denomination;
  final String submittedAgo;

  const GlobalAdminChurchReviewScreen({
    super.key,
    required this.churchName,
    required this.location,
    required this.denomination,
    required this.submittedAgo,
  });

  @override
  State<GlobalAdminChurchReviewScreen> createState() =>
      _GlobalAdminChurchReviewScreenState();
}

class _GlobalAdminChurchReviewScreenState
    extends State<GlobalAdminChurchReviewScreen> {
  final _notesCtrl = TextEditingController();
  bool _docVerified = false;
  bool _pastorVerified = false;
  bool _addressVerified = false;
  bool _acting = false;
  String? _decision; // 'approved' | 'info' | 'rejected'

  static const sage = Color(0xFFB0C4B1);
  static const babyBlue = Color(0xFFA8D1E7);
  static const dustyRose = Color(0xFFD4A5A5);
  static const ivory = Color(0xFFFDFCF0);
  static const nude = Color(0xFFF5E6E0);

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _decide(String decision) async {
    setState(() => _acting = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _acting = false;
      _decision = decision;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final msgs = {
      'approved': '${widget.churchName} has been approved.',
      'info': 'Information request sent to ${widget.churchName}.',
      'rejected': '${widget.churchName} application rejected.',
    };
    final colors = {
      'approved': const Color(0xFF22C55E),
      'info': const Color(0xFFF59E0B),
      'rejected': const Color(0xFFEF4444),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msgs[decision]!),
        backgroundColor: colors[decision],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.maybePop(context);
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
            // ── Header ───────────────────────────────────────────────
            Container(
              color:
                  isDark ? const Color(0xFF0F172A) : Colors.white,
              padding:
                  const EdgeInsets.fromLTRB(4, 8, 16, 8),
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
                          'Church Review',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Submitted ${widget.submittedAgo}',
                          style: TextStyle(
                              fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFF59E0B)
                              .withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.hourglass_empty,
                            size: 12,
                            color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        const Text(
                          'PENDING',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF59E0B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Church identity card ─────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
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
                            ),
                            child: Icon(Icons.church,
                                color: AppColors.primary, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.churchName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
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
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withOpacity(0.1),
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
                    const SizedBox(height: 20),

                    // ── Church details ───────────────────────────────
                    _SectionLabel(
                        label: 'Church Details',
                        icon: Icons.info_outline,
                        textColor: textColor,
                        borderColor: borderColor),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            label: 'Pastor',
                            value: 'Rev. James Okafor',
                            icon: Icons.person_outline,
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor,
                          ),
                          _DetailRow(
                            label: 'Founded',
                            value: '2009 · 15 years operating',
                            icon: Icons.calendar_today_outlined,
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor,
                          ),
                          _DetailRow(
                            label: 'Congregation',
                            value: '~320 regular attendees',
                            icon: Icons.groups_outlined,
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor,
                          ),
                          _DetailRow(
                            label: 'Services',
                            value: 'Sun 9 AM & 11 AM, Wed 7 PM',
                            icon: Icons.schedule,
                            subColor: subColor,
                            textColor: textColor,
                            borderColor: borderColor,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Submitted documents ──────────────────────────
                    _SectionLabel(
                        label: 'Submitted Documents',
                        icon: Icons.folder_outlined,
                        textColor: textColor,
                        borderColor: borderColor),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DocCard(
                            label: 'Registration Cert.',
                            icon: Icons.assignment_outlined,
                            status: 'uploaded',
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DocCard(
                            label: 'Pastor ID',
                            icon: Icons.badge_outlined,
                            status: 'uploaded',
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DocCard(
                            label: 'Address Proof',
                            icon: Icons.home_outlined,
                            status: 'pending',
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Verification checklist ───────────────────────
                    _SectionLabel(
                        label: 'Admin Verification Checklist',
                        icon: Icons.checklist,
                        textColor: textColor,
                        borderColor: borderColor),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _CheckRow(
                            label:
                                'Registration documents verified',
                            value: _docVerified,
                            onChanged: (v) =>
                                setState(() => _docVerified = v),
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          Divider(height: 1, color: borderColor),
                          _CheckRow(
                            label:
                                'Pastor credentials confirmed',
                            value: _pastorVerified,
                            onChanged: (v) =>
                                setState(() => _pastorVerified = v),
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          Divider(height: 1, color: borderColor),
                          _CheckRow(
                            label: 'Physical address verified',
                            value: _addressVerified,
                            onChanged: (v) =>
                                setState(() => _addressVerified = v),
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Church profile preview ───────────────────────
                    _SectionLabel(
                        label: 'Church Profile Preview',
                        icon: Icons.preview_outlined,
                        textColor: textColor,
                        borderColor: borderColor),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cover gradient
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  sage.withOpacity(0.6),
                                  babyBlue.withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.church,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 36),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"${widget.churchName}" — A community built on faith',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: subColor,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _Tag(
                                  label: widget.denomination,
                                  color: AppColors.primary),
                              _Tag(
                                  label: 'Family-Friendly',
                                  color: sage),
                              _Tag(label: 'Youth Groups', color: babyBlue),
                              _Tag(
                                  label: 'Prayer Ministry',
                                  color: dustyRose),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Admin notes ──────────────────────────────────
                    _SectionLabel(
                        label: 'Admin Notes',
                        icon: Icons.edit_note,
                        textColor: textColor,
                        borderColor: borderColor),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _notesCtrl,
                        maxLines: 4,
                        style:
                            TextStyle(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'Add internal notes about this church application…',
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color: subColor.withOpacity(0.7),
                              height: 1.5),
                          contentPadding: const EdgeInsets.all(14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Decision buttons ─────────────────────────────
                    if (_acting)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _decision != null
                              ? null
                              : () => _decide('approved'),
                          icon: const Icon(Icons.check_circle_outline,
                              size: 20),
                          label: const Text(
                            'Approve Church',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                const Color(0xFF22C55E).withOpacity(0.4),
                            elevation: 4,
                            shadowColor:
                                const Color(0xFF22C55E).withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: _decision != null
                              ? null
                              : () => _decide('info'),
                          icon: const Icon(
                              Icons.help_outline, size: 20),
                          label: const Text(
                            'Request More Information',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFFF59E0B)
                                  .withOpacity(0.6),
                            ),
                            foregroundColor:
                                const Color(0xFFF59E0B),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: _decision != null
                              ? null
                              : () => _decide('rejected'),
                          icon: const Icon(
                              Icons.cancel_outlined, size: 20),
                          label: const Text(
                            'Reject Application',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFFEF4444)
                                  .withOpacity(0.5),
                            ),
                            foregroundColor:
                                const Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
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

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color textColor;
  final Color borderColor;

  const _SectionLabel({
    required this.label,
    required this.icon,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(color: borderColor, height: 1),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color subColor;
  final Color textColor;
  final Color borderColor;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
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
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 16, color: subColor),
              const SizedBox(width: 10),
              SizedBox(
                width: 90,
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 12, color: subColor),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: borderColor),
      ],
    );
  }
}

class _DocCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String status; // 'uploaded' | 'pending'
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _DocCard({
    required this.label,
    required this.icon,
    required this.status,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final uploaded = status == 'uploaded';
    final color = uploaded
        ? const Color(0xFF22C55E)
        : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            uploaded ? 'Uploaded' : 'Pending',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color textColor;
  final Color subColor;

  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: textColor),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
