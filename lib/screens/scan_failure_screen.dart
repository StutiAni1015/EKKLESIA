import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'pastor_facial_scan_screen.dart';

class ScanFailureScreen extends StatefulWidget {
  const ScanFailureScreen({super.key});

  @override
  State<ScanFailureScreen> createState() => _ScanFailureScreenState();
}

class _ScanFailureScreenState extends State<ScanFailureScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  final _tipChecks = [false, false, false];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark
        ? const Color(0xFF1E293B).withOpacity(0.5)
        : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final tips = [
      (
        'Find better lighting',
        'Ensure your face is evenly lit without harsh shadows.'
      ),
      (
        'Clear your face',
        'Please remove any glasses, hats, or masks.'
      ),
      (
        'Eye-level position',
        'Hold your phone directly in front of your face.'
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Facial Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
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

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    24, 32, 24, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  children: [
                    // Error icon with pulsing bg
                    SizedBox(
                      width: 192,
                      height: 192,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing bg
                          AnimatedBuilder(
                            animation: _pulseCtrl,
                            builder: (_, __) => Container(
                              width:
                                  160 + _pulseCtrl.value * 20,
                              height:
                                  160 + _pulseCtrl.value * 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(
                                    0.06 * (1 + _pulseCtrl.value)),
                              ),
                            ),
                          ),
                          // Inner circle
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.no_photography_outlined,
                              color: AppColors.primary,
                              size: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Text
                    Text(
                      'Verification Unsuccessful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We couldn't quite catch your face this time. A few small adjustments might help us verify your identity.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Troubleshooting card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TROUBLESHOOTING TIPS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...tips.asMap().entries.map((e) {
                            final i = e.key;
                            final tip = e.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: i < tips.length - 1 ? 16 : 0),
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _tipChecks[i] =
                                        !_tipChecks[i]),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Checkbox
                                    AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 150),
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(
                                          top: 2),
                                      decoration: BoxDecoration(
                                        color: _tipChecks[i]
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        border: Border.all(
                                          color: _tipChecks[i]
                                              ? AppColors.primary
                                              : borderColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: _tipChecks[i]
                                          ? const Icon(Icons.check,
                                              color: Colors.white,
                                              size: 14)
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tip.$1,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            tip.$2,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: subColor,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PastorFacialScanScreen(),
                          ),
                        ),
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
                        child: const Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support chat coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                          foregroundColor: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF475569),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Contact Support',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'If you continue to have trouble, our community helpers are available to assist you in person.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: subColor.withOpacity(0.7),
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
