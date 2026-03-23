import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _agreedPrivacy = false;
  final _signatureCtrl = TextEditingController();

  bool get _canAccept =>
      _agreedPrivacy && _signatureCtrl.text.trim().length >= 2;

  static const _terms = [
    _Term('1', 'Community Standards',
        'Members must act with integrity and love.'),
    _Term('2', 'Privacy', 'We value your data protection.'),
    _Term('3', 'Content', 'You remain the owner of your posts.'),
    _Term('4', 'Conduct', 'No harassment or hate speech is tolerated.'),
    _Term('5', 'Safety', 'Report any suspicious activity.'),
    _Term('6', 'Membership', 'Accounts are for individual use.'),
    _Term('7', 'Donations', 'Contributions are voluntary.'),
    _Term('8', 'Events', 'Follow local guidelines for gatherings.'),
    _Term('9', 'Updates', 'Terms may change periodically.'),
    _Term('10', 'Liability', 'Use the platform at your own risk.'),
  ];

  @override
  void initState() {
    super.initState();
    _signatureCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _signatureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : Colors.white;
    final scaffoldBg =
        isDark ? const Color(0xFF0F172A).withOpacity(0.5) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark
        ? const Color(0xFF1E293B).withOpacity(0.4)
        : const Color(0xFFF8FAFC);
    final cardBorder =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final headerBorder =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final footerBg =
        isDark ? const Color(0xFF0F172A) : Colors.white;
    final footerBorder =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sticky header
            Container(
              decoration: BoxDecoration(
                color: bg.withOpacity(0.8),
                border: Border(
                    bottom: BorderSide(color: headerBorder)),
              ),
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Terms & Conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Platform Agreement heading
                    Text(
                      'Platform Agreement',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Last Updated: October 26, 2023',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Intro
                    Text(
                      'Welcome to our global church community platform. By accessing or using our services, you agree to be bound by the following terms:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Numbered term cards
                    ..._terms.map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TermCard(
                            term: t,
                            cardBg: cardBg,
                            cardBorder: cardBorder,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        )),

                    const SizedBox(height: 16),

                    // Privacy agreement checkbox
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedPrivacy,
                              onChanged: (v) =>
                                  setState(() => _agreedPrivacy = v ?? false),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: isDark
                                    ? const Color(0xFF475569)
                                    : const Color(0xFFCBD5E1),
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _agreedPrivacy = !_agreedPrivacy),
                              child: Text(
                                'I agree to respect the privacy of this community. I will not share private messages or content outside the platform without permission and will communicate respectfully with other members.',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: isDark
                                      ? const Color(0xFFE2E8F0)
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Signature field
                    Text(
                      'SIGN WITH FULL NAME (IN CAPITAL LETTERS)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _signatureCtrl,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'JANE DOE',
                        hintStyle: TextStyle(
                          color: subColor.withOpacity(0.5),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: headerBorder, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: headerBorder, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Fixed footer
            Container(
              padding: EdgeInsets.fromLTRB(
                  24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: footerBg,
                border:
                    Border(top: BorderSide(color: footerBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.maybePop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: headerBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: subColor,
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _canAccept
                            ? () => Navigator.maybePop(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.4),
                          foregroundColor: Colors.white,
                          disabledForegroundColor:
                              Colors.white.withOpacity(0.6),
                          elevation: _canAccept ? 4 : 0,
                          shadowColor: AppColors.primary.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Accept & Continue',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
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

class _TermCard extends StatelessWidget {
  final _Term term;
  final Color cardBg;
  final Color cardBorder;
  final Color textColor;
  final Color subColor;

  const _TermCard({
    required this.term,
    required this.cardBg,
    required this.cardBorder,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                term.number,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 14, height: 1.5, color: subColor),
                children: [
                  TextSpan(
                    text: '${term.title}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  TextSpan(text: term.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Term {
  final String number;
  final String title;
  final String body;
  const _Term(this.number, this.title, this.body);
}
