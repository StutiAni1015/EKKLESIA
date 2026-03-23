import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class RejectionSuccessConfirmationScreen extends StatefulWidget {
  final String memberName;
  final String rejectionReason;
  final VoidCallback? onReturnToList;
  final VoidCallback? onGoToDashboard;

  const RejectionSuccessConfirmationScreen({
    super.key,
    this.memberName = 'Jonathan Edwards',
    this.rejectionReason = 'Incomplete Profile',
    this.onReturnToList,
    this.onGoToDashboard,
  });

  @override
  State<RejectionSuccessConfirmationScreen> createState() =>
      _RejectionSuccessConfirmationScreenState();
}

class _RejectionSuccessConfirmationScreenState
    extends State<RejectionSuccessConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  static const amber = Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(
        parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
            begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entryCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? AppColors.backgroundDark
        : const Color(0xFFFDFCFB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor =
        isDark ? Colors.white : const Color(0xFF374151);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : amber.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Icon ──────────────────────────────────────
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: amber.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: amber,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Heading ───────────────────────────────────
                      Text(
                        'Application Processed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The applicant has been notified of the decision and provided with the feedback.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: subColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Detail pill ───────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFFFF8EF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: amber.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            _DetailRow(
                              label: 'Applicant',
                              value: widget.memberName,
                              textColor: textColor,
                              subColor: subColor,
                            ),
                            Divider(
                                height: 12,
                                color: amber.withOpacity(0.15)),
                            _DetailRow(
                              label: 'Reason',
                              value: widget.rejectionReason,
                              textColor: textColor,
                              subColor: subColor,
                              valueColor: amber,
                            ),
                            Divider(
                                height: 12,
                                color: amber.withOpacity(0.15)),
                            _DetailRow(
                              label: 'Notification',
                              value: 'Email & In-app sent',
                              textColor: textColor,
                              subColor: subColor,
                              valueColor:
                                  const Color(0xFF22C55E),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Buttons ───────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onReturnToList?.call();
                            Navigator.maybePop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: amber,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: amber.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Return to Member List',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onGoToDashboard?.call();
                            Navigator.of(context)
                                .popUntil((r) => r.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                amber.withOpacity(0.1),
                            foregroundColor: amber,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Go to Dashboard',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color subColor;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.textColor,
    required this.subColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: subColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? textColor,
          ),
        ),
      ],
    );
  }
}

// ── Convenience function ──────────────────────────────────────────────────────

/// Push a full-screen confirmation after a rejection is processed.
Future<void> showRejectionSuccessScreen(
  BuildContext context, {
  required String memberName,
  required String rejectionReason,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RejectionSuccessConfirmationScreen(
        memberName: memberName,
        rejectionReason: rejectionReason,
      ),
    ),
  );
}
