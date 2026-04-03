import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PastorNotificationEngagementScreen extends StatefulWidget {
  final String title;
  final String audience;
  final double readRate;
  final int readCount;
  final int totalCount;
  final String sentDate;

  const PastorNotificationEngagementScreen({
    super.key,
    required this.title,
    required this.audience,
    required this.readRate,
    required this.readCount,
    required this.totalCount,
    required this.sentDate,
  });

  @override
  State<PastorNotificationEngagementScreen> createState() =>
      _PastorNotificationEngagementScreenState();
}

class _PastorNotificationEngagementScreenState
    extends State<PastorNotificationEngagementScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _progress = Tween<double>(begin: 0, end: widget.readRate).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    final delivered = widget.totalCount;
    final read = widget.readCount;
    final tapped = (widget.readCount * 0.43).round();
    final unread = widget.totalCount - widget.readCount;

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Engagement Report',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          widget.sentDate,
                          style:
                              TextStyle(fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.share_outlined, color: subColor, size: 20),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification preview card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.campaign,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(Icons.group_outlined,
                                        size: 12, color: subColor),
                                    const SizedBox(width: 4),
                                    Text(widget.audience,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Sent',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF22C55E),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Radial gauge + read rate
                    Center(
                      child: AnimatedBuilder(
                        animation: _progress,
                        builder: (_, __) => Column(
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CustomPaint(
                                painter: _GaugePainter(
                                  progress: _progress.value,
                                  isDark: isDark,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${(_progress.value * 100).round()}%',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w800,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        'Read Rate',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$read of $delivered recipients opened this notification',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, color: subColor),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats row
                    Row(
                      children: [
                        _StatCard(
                          label: 'Delivered',
                          value: '$delivered',
                          icon: Icons.send_outlined,
                          color: const Color(0xFF3B82F6),
                          isDark: isDark,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Opened',
                          value: '$read',
                          icon: Icons.visibility_outlined,
                          color: const Color(0xFF22C55E),
                          isDark: isDark,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Tapped',
                          value: '$tapped',
                          icon: Icons.touch_app_outlined,
                          color: AppColors.primary,
                          isDark: isDark,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Unread',
                          value: '$unread',
                          icon: Icons.mark_email_unread_outlined,
                          color: const Color(0xFFF59E0B),
                          isDark: isDark,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Breakdown section
                    Text(
                      'Engagement Breakdown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Column(
                        children: [
                          _BarRow(
                            label: 'Opened',
                            value: read,
                            total: delivered,
                            color: const Color(0xFF22C55E),
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 14),
                          _BarRow(
                            label: 'Tapped CTA',
                            value: tapped,
                            total: delivered,
                            color: AppColors.primary,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 14),
                          _BarRow(
                            label: 'Dismissed',
                            value: (unread * 0.3).round(),
                            total: delivered,
                            color: const Color(0xFFEF4444),
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 14),
                          _BarRow(
                            label: 'Unread',
                            value: unread,
                            total: delivered,
                            color: const Color(0xFFF59E0B),
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Timing section
                    Text(
                      'Read Timing',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Column(
                        children: [
                          _TimingRow(
                            label: 'Within 1 hour',
                            pct: 0.52,
                            color: AppColors.primary,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 12),
                          _TimingRow(
                            label: '1–6 hours',
                            pct: 0.28,
                            color: const Color(0xFF3B82F6),
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 12),
                          _TimingRow(
                            label: '6–24 hours',
                            pct: 0.14,
                            color: const Color(0xFFF59E0B),
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 12),
                          _TimingRow(
                            label: 'After 24 hours',
                            pct: 0.06,
                            color: subColor,
                            isDark: isDark,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Resend nudge
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              const Color(0xFFF59E0B).withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.replay,
                              color: const Color(0xFFF59E0B), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$unread members haven\'t read this yet',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Send a follow-up reminder to unread recipients',
                                  style: TextStyle(
                                      fontSize: 12, color: subColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification resent!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _GaugePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    const strokeW = 14.0;
    const startAngle = -math.pi * 0.8;
    const sweepFull = math.pi * 1.6;

    // Track
    final trackPaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155)
          : const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepFull, false, trackPaint);

    // Progress
    Color color;
    if (progress >= 0.8) {
      color = const Color(0xFF22C55E);
    } else if (progress >= 0.6) {
      color = const Color(0xFFF59E0B);
    } else {
      color = const Color(0xFFEF4444);
    }
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepFull * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.progress != progress;
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;
  final Color cardBg;
  final Color textColor;
  final Color subColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    TextStyle(fontSize: 10, color: subColor),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _BarRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? value / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const Spacer(),
            Text(
              '$value (${(pct * 100).round()}%)',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _TimingRow extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _TimingRow({
    required this.label,
    required this.pct,
    required this.color,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: subColor)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${(pct * 100).round()}%',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color),
        ),
      ],
    );
  }
}
