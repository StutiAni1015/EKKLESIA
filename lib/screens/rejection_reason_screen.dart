import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Call this as a bottom sheet:
///   showRejectionReasonSheet(context, memberName: 'Jonathan Edwards')
Future<void> showRejectionReasonSheet(
  BuildContext context, {
  required String memberName,
  VoidCallback? onConfirmed,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) => _RejectionReasonSheet(
      memberName: memberName,
      onConfirmed: onConfirmed,
    ),
  );
}

class _RejectionReasonSheet extends StatefulWidget {
  final String memberName;
  final VoidCallback? onConfirmed;

  const _RejectionReasonSheet({
    required this.memberName,
    this.onConfirmed,
  });

  @override
  State<_RejectionReasonSheet> createState() =>
      _RejectionReasonSheetState();
}

class _RejectionReasonSheetState extends State<_RejectionReasonSheet> {
  int _selectedChip = 0;
  final _controller = TextEditingController();
  bool _confirming = false;
  bool _confirmed = false;

  static const _reasons = [
    'Incomplete Profile',
    'ID Mismatch',
    'Unclear Facial Scan',
    'Incorrect Church Details',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    setState(() => _confirming = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _confirming = false;
      _confirmed = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      Navigator.of(context).pop();
      widget.onConfirmed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg =
        isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final chipIdleBg =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final chipIdleBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final chipIdleText =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 32,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Reason for Rejection',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select a common reason or provide custom feedback for ${widget.memberName}.',
                      style: TextStyle(
                          fontSize: 13, color: subColor, height: 1.5),
                    ),
                    const SizedBox(height: 20),

                    // Reason chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_reasons.length, (i) {
                        final active = i == _selectedChip;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedChip = i),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                      .withOpacity(0.1)
                                  : chipIdleBg,
                              borderRadius:
                                  BorderRadius.circular(99),
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                        .withOpacity(0.35)
                                    : chipIdleBorder,
                                width: active ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (active)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 6),
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                Text(
                                  _reasons[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: active
                                        ? AppColors.primary
                                        : chipIdleText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Custom message
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Custom Message / Additional Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Optional',
                          style: TextStyle(
                              fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'Provide more context for the member about why their application was not accepted...',
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
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20,
                  MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: sheetBg,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: subColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm Rejection
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (_confirming || _confirmed)
                          ? null
                          : _confirm,
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 300),
                        height: 54,
                        decoration: BoxDecoration(
                          color: _confirmed
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFF97316),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF97316)
                                  .withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: _confirming
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _confirmed
                                        ? Icons.check
                                        : Icons.block,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _confirmed
                                        ? 'Rejected'
                                        : 'Confirm Rejection',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Standalone preview screen (for navigation / testing) ─────────────────────

class RejectionReasonPreviewScreen extends StatelessWidget {
  const RejectionReasonPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
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
                    child: Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('Review Application',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                  const Spacer(),
                  Icon(Icons.more_vert, color: subColor, size: 22),
                ],
              ),
            ),

            // Member card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1),
                                AppColors.primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'JE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jonathan Edwards',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const SizedBox(height: 4),
                            Text(
                                'Applied 2 days ago · Grace Community Church',
                                style: TextStyle(
                                    fontSize: 12, color: subColor)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _InfoCard(
                          label: 'ID Verification',
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF374151),
                                  Color(0xFF1F2937)
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.badge_outlined,
                                  color: Colors.white54, size: 40),
                            ),
                          ),
                          isDark: isDark,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 12),
                        _InfoCard(
                          label: 'Personal Info',
                          child: Column(
                            children: [
                              _InfoRow(
                                  label: 'Email',
                                  value: 'j.edwards@email.com',
                                  subColor: subColor,
                                  textColor: textColor),
                              Divider(
                                  height: 1,
                                  color: AppColors.primary
                                      .withOpacity(0.06)),
                              _InfoRow(
                                  label: 'Phone',
                                  value: '+1 555-0123',
                                  subColor: subColor,
                                  textColor: textColor),
                            ],
                          ),
                          isDark: isDark,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => showRejectionReasonSheet(
                        context,
                        memberName: 'Jonathan Edwards',
                        onConfirmed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Application rejected and member notified.'),
                              backgroundColor: Color(0xFFF97316),
                            ),
                          );
                          Navigator.maybePop(context);
                        },
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                            color: Color(0xFFEF4444), width: 1.5),
                        foregroundColor: const Color(0xFFEF4444),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Reject',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Approve Member',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isDark;
  final Color cardBg;
  final Color textColor;
  final Color subColor;

  const _InfoCard({
    required this.label,
    required this.child,
    required this.isDark,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: subColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color subColor;
  final Color textColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.subColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: subColor)),
          Flexible(
            child: Text(value,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
