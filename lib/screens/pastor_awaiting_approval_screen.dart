import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PastorAwaitingApprovalScreen extends StatefulWidget {
  const PastorAwaitingApprovalScreen({super.key});

  @override
  State<PastorAwaitingApprovalScreen> createState() =>
      _PastorAwaitingApprovalScreenState();
}

class _PastorAwaitingApprovalScreenState
    extends State<PastorAwaitingApprovalScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFE1DAD3);
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);
    const babyBlue = Color(0xFFA4B1BA);
    const sage = Color(0xFFD7A49A);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // Pulsing status icon
                    Center(
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) => Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: babyBlue.withOpacity(
                                0.6 + _pulse.value * 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: babyBlue.withOpacity(
                                    0.2 + _pulse.value * 0.1),
                                blurRadius: 24 + _pulse.value * 8,
                                spreadRadius: _pulse.value * 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Heading
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            'Application Under Review',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.4,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Our global admin team is currently verifying your church credentials, including your facial scan, ID, and church details, to ensure the highest level of community safety.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // What to Expect glass card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B).withOpacity(0.6)
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.help_outline,
                                    color: sage, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'What to Expect',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _ExpectItem(
                              bullet: sage,
                              text: 'The review process typically takes ',
                              boldText: '24–48 hours',
                              trailing: '.',
                              textColor: subColor,
                            ),
                            const SizedBox(height: 12),
                            _ExpectItem(
                              bullet: sage,
                              text:
                                  'You will receive a notification and email once your account is fully approved.',
                              textColor: subColor,
                            ),
                            const SizedBox(height: 12),
                            _ExpectItem(
                              bullet: sage,
                              text:
                                  'In the meantime, you can explore the community with limited access.',
                              textColor: subColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.maybePop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                side: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE5E7EB),
                                ),
                                foregroundColor: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF374151),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
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
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: babyBlue,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor:
                                    babyBlue.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Browse Community',
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
              child: Text(
                'VERIFICATION STATUS: PENDING',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: subColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpectItem extends StatelessWidget {
  final Color bullet;
  final String text;
  final String? boldText;
  final String? trailing;
  final Color textColor;

  const _ExpectItem({
    required this.bullet,
    required this.text,
    this.boldText,
    this.trailing,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7, right: 12),
          decoration: BoxDecoration(
            color: bullet,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: boldText != null
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 13, height: 1.5, color: textColor),
                    children: [
                      TextSpan(text: text),
                      TextSpan(
                        text: boldText,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      if (trailing != null) TextSpan(text: trailing),
                    ],
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                      fontSize: 13, height: 1.5, color: textColor),
                ),
        ),
      ],
    );
  }
}
