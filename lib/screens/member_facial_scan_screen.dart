import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/app_colors.dart';
import 'member_verification_successful_screen.dart';
import 'church_member_verification_screen.dart';
import 'otp_verification_screen.dart';
import '../core/user_session.dart';

class MemberFacialScanScreen extends StatefulWidget {
  /// When provided, called after a successful scan instead of the default
  /// navigation to MemberVerificationSuccessfulScreen. Use this to plug the
  /// scan into a signup / onboarding flow.
  final VoidCallback? onSuccess;

  const MemberFacialScanScreen({super.key, this.onSuccess});

  @override
  State<MemberFacialScanScreen> createState() =>
      _MemberFacialScanScreenState();
}

class _MemberFacialScanScreenState extends State<MemberFacialScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _scanning = false;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final success = math.Random().nextDouble() > 0.25;
        if (!mounted) return;
        if (success) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                title: 'Identity Verification',
                verificationTarget: 'registered contact',
                onVerified: () {
                  faceVerifiedNotifier.value = true;
                  if (widget.onSuccess != null) {
                    widget.onSuccess!();
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const MemberVerificationSuccessfulScreen()),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          _showRetrySheet();
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    // TODO: re-enable camera permission check when testing on a real device.
    // Permission.camera.request() is skipped on simulator since it has no camera.
    setState(() => _scanning = true);
    _ctrl.forward(from: 0);
  }

  void _showPermissionDeniedDialog({required bool permanent}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Camera Access Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          permanent
              ? 'Camera permission was permanently denied. Please enable it in Settings to use facial verification.'
              : 'Camera access is needed to scan your face for identity verification.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: sage,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (permanent) openAppSettings();
            },
            child: Text(permanent ? 'Open Settings' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _showRetrySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark =
            Theme.of(context).brightness == Brightness.dark;
        final sheetBg =
            isDark ? const Color(0xFF1E293B) : Colors.white;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.no_photography_outlined,
                    color: Color(0xFFEF4444), size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Scan Unsuccessful',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t verify your face clearly. Please ensure good lighting and look directly at the camera.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF6B7280),
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() => _scanning = false);
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sage,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const ChurchMemberVerificationScreen()),
                  );
                },
                child: Text(
                  'Update ID Details',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Facial Verification',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: sage.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Step 2 of 2',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(sage),
              minHeight: 3,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    Text(
                      'Position Your Face',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Centre your face within the oval guide below',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: subColor, height: 1.5),
                    ),
                    const SizedBox(height: 32),

                    // Camera oval with scan ring
                    AnimatedBuilder(
                      animation: _ctrl,
                      builder: (_, __) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow ring
                            Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: sage.withOpacity(0.06),
                              ),
                            ),
                            // Progress ring
                            SizedBox(
                              width: 240,
                              height: 240,
                              child: CustomPaint(
                                painter: _ScanRingPainter(
                                  progress: _ctrl.value,
                                  isDark: isDark,
                                ),
                              ),
                            ),
                            // Camera view oval
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [
                                          const Color(0xFF1E293B),
                                          const Color(0xFF0F172A),
                                        ]
                                      : [
                                          const Color(0xFFDCEBF5),
                                          const Color(0xFFE8F0E9),
                                        ],
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Face guide dashes
                                  CustomPaint(
                                    size: const Size(200, 200),
                                    painter:
                                        _FaceGuidePainter(isDark: isDark),
                                  ),
                                  Icon(
                                    Icons.face_retouching_natural,
                                    size: 72,
                                    color: sage.withOpacity(0.5),
                                  ),
                                  if (_scanning)
                                    Positioned(
                                      bottom: 16,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4),
                                        decoration: BoxDecoration(
                                          color: sage,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${(_ctrl.value * 100).round()}% Scanned',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Step badges
                    AnimatedBuilder(
                      animation: _ctrl,
                      builder: (_, __) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StepBadge(
                            label: 'Centre Face',
                            isDone: true,
                            isActive: !_scanning,
                            color: sage,
                          ),
                          _StepConnector(done: _ctrl.value > 0.33),
                          _StepBadge(
                            label: 'Hold Steady',
                            isDone: _ctrl.value > 0.5,
                            isActive: _scanning &&
                                _ctrl.value >= 0.33 &&
                                _ctrl.value < 0.66,
                            color: sage,
                          ),
                          _StepConnector(done: _ctrl.value > 0.66),
                          _StepBadge(
                            label: 'Complete',
                            isDone: _ctrl.value >= 1.0,
                            isActive: _scanning && _ctrl.value >= 0.66,
                            color: sage,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Privacy info box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: babyBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: babyBlue.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shield_outlined,
                              color: babyBlue, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your facial data is processed on-device and encrypted. It is used only to match your government ID and is not stored after verification.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: subColor,
                                  height: 1.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _scanning ? null : _startScan,
                        icon: Icon(
                          _scanning
                              ? Icons.hourglass_top
                              : Icons.camera_front_outlined,
                          size: 20,
                        ),
                        label: Text(
                          _scanning ? 'Scanning…' : 'Start Facial Scan',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _scanning ? sage.withOpacity(0.5) : sage,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              sage.withOpacity(0.5),
                          elevation: 6,
                          shadowColor: sage.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.maybePop(context),
                      child: Text(
                        'Cancel & Go Back',
                        style: TextStyle(
                            color: subColor,
                            fontWeight: FontWeight.w500),
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

// ── Painters ──────────────────────────────────────────────────────────────────

class _ScanRingPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _ScanRingPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const sage = Color(0xFFB6C9BB);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeW = 5.0;

    // Track
    final trackPaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155)
          : const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Arc
    final arcPaint = Paint()
      ..color = sage
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_ScanRingPainter old) => old.progress != progress;
}

class _FaceGuidePainter extends CustomPainter {
  final bool isDark;
  _FaceGuidePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const sage = Color(0xFFB6C9BB);
    final paint = Paint()
      ..color = sage.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: size.width * 0.7, height: size.height * 0.85));
    const dashLen = 6.0;
    const gapLen = 5.0;
    final metrics = path.computeMetrics().first;
    double dist = 0;
    while (dist < metrics.length) {
      final end = (dist + dashLen).clamp(0, metrics.length);
      canvas.drawPath(metrics.extractPath(dist, end.toDouble()), paint);
      dist += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_FaceGuidePainter old) => false;
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _StepBadge extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isActive;
  final Color color;

  const _StepBadge({
    required this.label,
    required this.isDone,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? color
                : isActive
                    ? color.withOpacity(0.2)
                    : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
            border: isActive && !isDone
                ? Border.all(color: color, width: 2)
                : null,
          ),
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            size: isDone ? 16 : 8,
            color: isDone
                ? Colors.white
                : isActive
                    ? color
                    : (isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF9CA3AF)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDone || isActive
                ? color
                : (isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF9CA3AF)),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool done;
  const _StepConnector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 32,
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: done
            ? const Color(0xFFB6C9BB)
            : (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0)),
      ),
    );
  }
}
