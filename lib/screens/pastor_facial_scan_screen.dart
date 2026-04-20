import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';
import '../core/app_colors.dart';
import 'verification_successful_screen.dart';
import 'scan_failure_screen.dart';
import 'otp_verification_screen.dart';
import '../core/user_session.dart';

class PastorFacialScanScreen extends StatefulWidget {
  /// When provided, called after a successful scan instead of the default
  /// navigation. Use this to plug the scan into a signup / onboarding flow.
  final VoidCallback? onSuccess;

  const PastorFacialScanScreen({super.key, this.onSuccess});

  @override
  State<PastorFacialScanScreen> createState() =>
      _PastorFacialScanScreenState();
}

class _PastorFacialScanScreenState extends State<PastorFacialScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progressAnim;

  // Simulated scan progress (0.0 to 1.0)
  double _scanProgress = 0.65;
  int _activeStep = 1; // 0=center, 1=rotate, 2=complete

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressAnim =
        Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    )..addListener(() {
            setState(() => _scanProgress = _progressAnim.value);
          });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _startCapture() async {
    // TODO: re-enable camera permission check when testing on a real device.
    // Permission.camera.request() is skipped on simulator since it has no camera.
    _ctrl.forward().then((_) {
      if (!mounted) return;
      // Simulate 70% success rate
      final success = DateTime.now().millisecond % 10 < 7;
      if (!success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ScanFailureScreen()),
        );
        return;
      }
      // Success → OTP verification step
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
                      builder: (_) => const VerificationSuccessfulScreen()),
                );
              }
            },
          ),
        ),
      );
    });
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
              backgroundColor: AppColors.primary,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final percent = (_scanProgress * 100).round();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top nav
            Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE4C9B6).withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: subColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Biometric Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Header text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            'Facial Scan',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.4,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Slowly turn your head in a full circle to complete the pastor verification.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Progress ring + camera view
                    SizedBox(
                      width: 288,
                      height: 288,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // SVG-style progress ring via CustomPaint
                          SizedBox(
                            width: 288,
                            height: 288,
                            child: CustomPaint(
                              painter: _ProgressRingPainter(
                                progress: _scanProgress,
                                isDark: isDark,
                              ),
                            ),
                          ),

                          // Camera circle
                          Container(
                            width: 248,
                            height: 248,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF475569)
                                    : Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Stack(
                                children: [
                                  // Camera placeholder — gradient face silhouette
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: isDark
                                            ? [
                                                const Color(0xFF334155),
                                                const Color(0xFF1E293B),
                                              ]
                                            : [
                                                const Color(0xFFE4C9B6)
                                                    .withOpacity(0.4),
                                                const Color(0xFFF8F6F6),
                                              ],
                                      ),
                                    ),
                                  ),
                                  // Face icon placeholder
                                  Center(
                                    child: Icon(
                                      Icons.face_retouching_natural,
                                      size: 120,
                                      color: isDark
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFD7A49A)
                                              .withOpacity(0.6),
                                    ),
                                  ),
                                  // Dashed guide overlay
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _FaceGuidePainter(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Scan status badge
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: const Color(0xFFE4C9B6)
                                      .withOpacity(0.5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$percent% Scanned',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Instruction steps
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          _StepBadge(
                            icon: Icons.face,
                            label: 'Center\nFace',
                            state: _activeStep > 0
                                ? _StepState.done
                                : _activeStep == 0
                                    ? _StepState.active
                                    : _StepState.inactive,
                          ),
                          _StepBadge(
                            icon: Icons.autorenew,
                            label: 'Rotate\nHead',
                            state: _activeStep > 1
                                ? _StepState.done
                                : _activeStep == 1
                                    ? _StepState.active
                                    : _StepState.inactive,
                          ),
                          _StepBadge(
                            icon: Icons.check_circle_outline,
                            label: 'Complete',
                            state: _activeStep > 2
                                ? _StepState.done
                                : _activeStep == 2
                                    ? _StepState.active
                                    : _StepState.inactive,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2B8A3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFB2B8A3).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            color: const Color(0xFFB2B8A3), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Verification data is encrypted and used only for church leadership validation. Ensure you are in a well-lit area.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: subColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _ctrl.isAnimating ? null : _startCapture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor:
                            AppColors.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _ctrl.isAnimating
                          ? const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Scanning...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Start Manual Capture',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: Text(
                      'Cancel Verification',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subColor,
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

// ─── Progress ring painter ───────────────────────────────────────

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _ProgressRingPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    const strokeWidth = 6.0;

    // Track
    final trackPaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155)
          : const Color(0xFFE1DAD3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // start at top
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) =>
      old.progress != progress || old.isDark != isDark;
}

// ─── Face guide painter ──────────────────────────────────────────

class _FaceGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path();
    const dashLength = 6.0;
    const gapLength = 4.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    double angle = 0;
    while (angle < 2 * math.pi) {
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final arcAngle = dashLength / radius;
      final end = Offset(
        center.dx + radius * math.cos(angle + arcAngle),
        center.dy + radius * math.sin(angle + arcAngle),
      );
      canvas.drawLine(start, end, paint);
      angle += arcAngle + gapLength / radius;
    }
  }

  @override
  bool shouldRepaint(_FaceGuidePainter _) => false;
}

// ─── Step badge ──────────────────────────────────────────────────

enum _StepState { active, inactive, done }

class _StepBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final _StepState state;
  const _StepBadge(
      {required this.icon, required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color iconColor;
    Color textColor;
    double opacity = 1.0;

    switch (state) {
      case _StepState.active:
        bg = AppColors.primary.withOpacity(0.15);
        iconColor = AppColors.primary;
        textColor = AppColors.primary;
      case _StepState.done:
        bg = AppColors.primary;
        iconColor = Colors.white;
        textColor = AppColors.primary;
      case _StepState.inactive:
        bg = const Color(0xFFE2E8F0);
        iconColor = const Color(0xFF94A3B8);
        textColor = const Color(0xFF94A3B8);
        opacity = 0.4;
    }

    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: state == _StepState.active
                  ? Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2)
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: textColor,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
