import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'signup_security_agreement_screen.dart';

class SignupSpiritualProfileScreen extends StatefulWidget {
  const SignupSpiritualProfileScreen({super.key});

  @override
  State<SignupSpiritualProfileScreen> createState() =>
      _SignupSpiritualProfileScreenState();
}

class _SignupSpiritualProfileScreenState
    extends State<SignupSpiritualProfileScreen> {
  final _verseCtrl = TextEditingController();
  final _testimonyCtrl = TextEditingController();
  final _prayerCtrl = TextEditingController();

  final Set<String> _ministries = {'Worship Arts'};

  static const _ministryOptions = [
    'Small Groups',
    'Youth Ministry',
    'Worship Arts',
    'Community Outreach',
  ];

  @override
  void dispose() {
    _verseCtrl.dispose();
    _testimonyCtrl.dispose();
    _prayerCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignupSecurityAgreementScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B).withOpacity(0.5) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final labelColor =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Step 4 of 5',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _onContinue,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Step dots (dot 4 active)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  const SizedBox(width: 12),
                  _dot(false),
                  const SizedBox(width: 12),
                  _dot(false),
                  const SizedBox(width: 12),
                  _dot(true),
                  const SizedBox(width: 12),
                  _dot(false),
                ],
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title block
                    Text(
                      'Spiritual Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This information helps us connect you with the right small groups and ministries (optional).',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Favorite Bible Verse
                    _UpperLabel('Favorite Bible Verse', labelColor),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _verseCtrl,
                      hint: 'e.g. Philippians 4:13',
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 24),

                    // Testimony
                    _UpperLabel('Your Testimony', labelColor),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _testimonyCtrl,
                      maxLines: 5,
                      style: TextStyle(fontSize: 15, color: textColor),
                      decoration: _inputDecoration(
                        hint: 'Briefly share your journey...',
                        cardBg: cardBg,
                        borderColor: borderColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Prayer Requests
                    _UpperLabel('Prayer Requests', labelColor),
                    const SizedBox(height: 8),
                    _buildInput(
                      controller: _prayerCtrl,
                      hint: 'How can we pray for you?',
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 24),

                    // Ministry Interests
                    _UpperLabel('Ministry Interests', labelColor),
                    const SizedBox(height: 12),
                    ..._ministryOptions.map((ministry) {
                      final checked = _ministries.contains(ministry);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            if (checked) {
                              _ministries.remove(ministry);
                            } else {
                              _ministries.add(ministry);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: checked
                                  ? AppColors.primary.withOpacity(0.05)
                                  : cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: checked
                                    ? AppColors.primary.withOpacity(0.5)
                                    : borderColor,
                                width: checked ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: checked,
                                    onChanged: (_) => setState(() {
                                      if (checked) {
                                        _ministries.remove(ministry);
                                      } else {
                                        _ministries.add(ministry);
                                      }
                                    }),
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                      color: checked
                                          ? AppColors.primary
                                          : borderColor,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  ministry,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue to Final Step',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Step 4 of 5 - Optional Profile',
                        style:
                            TextStyle(fontSize: 12, color: subColor),
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

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: _inputDecoration(
          hint: hint, cardBg: cardBg, borderColor: borderColor),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required Color cardBg,
    required Color borderColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF64748B)
              : const Color(0xFF94A3B8)),
      filled: true,
      fillColor: cardBg,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _dot(bool active) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: active ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: active
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.3),
        ),
      );
}

class _UpperLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _UpperLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color,
      ),
    );
  }
}
