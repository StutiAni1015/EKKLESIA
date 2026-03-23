import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'signup_community_preferences_screen.dart';

class SignupFaithBackgroundScreen extends StatefulWidget {
  const SignupFaithBackgroundScreen({super.key});

  @override
  State<SignupFaithBackgroundScreen> createState() =>
      _SignupFaithBackgroundScreenState();
}

class _SignupFaithBackgroundScreenState
    extends State<SignupFaithBackgroundScreen> {
  String? _denomination;
  final _churchNameCtrl = TextEditingController();
  String? _role;
  bool _bornAgain = false;
  String _bibleVersion = 'NIV';
  final Set<String> _interests = {};

  static const _denominations = [
    'Catholic',
    'Baptist',
    'Pentecostal',
    'Methodist',
    'Non-denominational',
    'Other',
  ];

  static const _roles = ['Member', 'Pastor', 'Leader'];

  static const _bibleVersions = [
    _BibleVersion('NIV', 'NIV - New International Version'),
    _BibleVersion('KJV', 'KJV - King James Version'),
    _BibleVersion('ESV', 'ESV - English Standard Version'),
    _BibleVersion('NKJV', 'NKJV - New King James Version'),
    _BibleVersion('NLT', 'NLT - New Living Translation'),
  ];

  static const _interestOptions = [
    'Prayer',
    'Worship',
    'Missions',
    'Bible Study',
    'Youth',
    'Evangelism',
  ];

  @override
  void dispose() {
    _churchNameCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignupCommunityPreferencesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final labelColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header
            _buildHeader(isDark, textColor),

            // Step dots
            _buildStepDots(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Tell us about your journey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Help us connect you with your community.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Denomination
                    _sectionLabel('Denomination', labelColor),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _denomination,
                      hint: 'Select your denomination',
                      items: _denominations,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      isDark: isDark,
                      onChanged: (v) => setState(() => _denomination = v),
                    ),
                    const SizedBox(height: 24),

                    // Church Name
                    _sectionLabel('Church Name', labelColor, optional: true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _churchNameCtrl,
                      hint: 'Enter your home church',
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),

                    // Role in Church
                    _sectionLabel('Role in Church', labelColor),
                    const SizedBox(height: 8),
                    Row(
                      children: _roles
                          .map((r) => Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: r != _roles.last ? 8 : 0,
                                  ),
                                  child: _RoleChip(
                                    label: r,
                                    selected: _role == r,
                                    cardBg: cardBg,
                                    borderColor: borderColor,
                                    isDark: isDark,
                                    onTap: () =>
                                        setState(() => _role = r),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Born Again toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Born Again?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Committed to Christ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _bornAgain,
                            onChanged: (v) => setState(() => _bornAgain = v),
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Favorite Bible Version
                    _sectionLabel('Favorite Bible Version', labelColor),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _bibleVersion,
                          isExpanded: true,
                          dropdownColor: cardBg,
                          icon: Icon(Icons.expand_more,
                              color: Colors.grey[500]),
                          style: TextStyle(fontSize: 15, color: textColor),
                          onChanged: (v) =>
                              setState(() => _bibleVersion = v!),
                          items: _bibleVersions
                              .map((b) => DropdownMenuItem(
                                    value: b.code,
                                    child: Text(b.label),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Spiritual Interests
                    _sectionLabel('Spiritual Interests', labelColor),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 3.2,
                      children: _interestOptions
                          .map((interest) => _InterestTile(
                                label: interest,
                                checked: _interests.contains(interest),
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textColor: textColor,
                                isDark: isDark,
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    _interests.add(interest);
                                  } else {
                                    _interests.remove(interest);
                                  }
                                }),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 32),

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
                          shadowColor: AppColors.primary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue to Step 3',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Skip
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        onPressed: _onContinue,
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
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

  Widget _buildHeader(bool isDark, Color textColor) {
    return Container(
      color: isDark
          ? AppColors.backgroundDark.withOpacity(0.8)
          : AppColors.backgroundLight.withOpacity(0.8),
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Text(
              'Faith Background',
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
    );
  }

  Widget _buildStepDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StepDot(active: false),
          const SizedBox(width: 12),
          _StepDot(active: true, wide: true),
          const SizedBox(width: 12),
          _StepDot(active: false),
          const SizedBox(width: 12),
          _StepDot(active: false),
          const SizedBox(width: 12),
          _StepDot(active: false),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required bool isDark,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: TextStyle(color: Colors.grey[500], fontSize: 15)),
          isExpanded: true,
          dropdownColor: cardBg,
          icon: Icon(Icons.expand_more, color: Colors.grey[500]),
          style: TextStyle(fontSize: 15, color: textColor),
          onChanged: onChanged,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      ),
    );
  }

  Widget _sectionLabel(String text, Color color, {bool optional = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: color),
        children: optional
            ? [
                TextSpan(
                  text: '  (Optional)',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: color.withOpacity(0.6)),
                ),
              ]
            : [],
      ),
    );
  }
}

// Step dot widget
class _StepDot extends StatelessWidget {
  final bool active;
  final bool wide;

  const _StepDot({required this.active, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active && wide ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: active
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.2),
      ),
    );
  }
}

// Role chip toggle
class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color cardBg;
  final Color borderColor;
  final bool isDark;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.selected,
    required this.cardBg,
    required this.borderColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.05)
              : cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

// Interest checkbox tile
class _InterestTile extends StatelessWidget {
  final String label;
  final bool checked;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final bool isDark;
  final ValueChanged<bool?> onChanged;

  const _InterestTile({
    required this.label,
    required this.checked,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: checked
              ? AppColors.primary.withOpacity(0.05)
              : cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: checked ? AppColors.primary : borderColor,
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
                onChanged: onChanged,
                activeColor: AppColors.primary,
                side: BorderSide(color: borderColor, width: 1.5),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: checked ? AppColors.primary : textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BibleVersion {
  final String code;
  final String label;
  const _BibleVersion(this.code, this.label);
}
