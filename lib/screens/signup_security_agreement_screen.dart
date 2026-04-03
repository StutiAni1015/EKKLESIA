import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'community_guidelines_screen.dart';
import 'dashboard_screen.dart';
import 'location_currency_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import '../core/user_session.dart';

class SignupSecurityAgreementScreen extends StatefulWidget {
  const SignupSecurityAgreementScreen({super.key});

  @override
  State<SignupSecurityAgreementScreen> createState() =>
      _SignupSecurityAgreementScreenState();
}

class _SignupSecurityAgreementScreenState
    extends State<SignupSecurityAgreementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  bool _agreedTerms = false;
  bool _agreedGuidelines = false;

  bool get _canSubmit => _agreedTerms && _agreedGuidelines;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to both Terms and Community Guidelines.'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }
    accountVerifiedNotifier.value = true;
    // Ask for location/currency first, then go to dashboard
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => const LocationCurrencyScreen(isSetup: true)),
    );
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
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
                      'Security & Agreement',
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

            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Finalizing your account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Step 5 of 5',
                        style: TextStyle(fontSize: 13, color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 8,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Secure your account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.4,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set a strong password and review our community guidelines to finish joining our church family.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: subColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password
                      _fieldLabel('Password', textColor),
                      const SizedBox(height: 8),
                      _PasswordField(
                        controller: _passwordCtrl,
                        hint: 'Enter password',
                        visible: _showPassword,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        onToggle: () =>
                            setState(() => _showPassword = !_showPassword),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 8) {
                            return 'Minimum 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      _fieldLabel('Confirm Password', textColor),
                      const SizedBox(height: 8),
                      _PasswordField(
                        controller: _confirmCtrl,
                        hint: 'Confirm password',
                        visible: _showConfirm,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        onToggle: () =>
                            setState(() => _showConfirm = !_showConfirm),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (v != _passwordCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Terms & Conditions
                      _AgreementRow(
                        value: _agreedTerms,
                        onChanged: (v) =>
                            setState(() => _agreedTerms = v ?? false),
                        isDark: isDark,
                        textColor: textColor,
                        subColor: subColor,
                        label: 'I agree to the ',
                        linkText: 'Terms & Conditions',
                        subtitle:
                            'Please read our privacy policy and usage terms.',
                        onLinkTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsConditionsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Community Guidelines
                      _AgreementRow(
                        value: _agreedGuidelines,
                        onChanged: (v) =>
                            setState(() => _agreedGuidelines = v ?? false),
                        isDark: isDark,
                        textColor: textColor,
                        subColor: subColor,
                        label: 'I accept the ',
                        linkText: 'Community Guidelines',
                        subtitle:
                            'Help us keep our church community safe and welcoming.',
                        onLinkTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CommunityGuidelinesScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 36),

                      // Create Account button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _onCreateAccount : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.4),
                            foregroundColor: Colors.white,
                            disabledForegroundColor:
                                Colors.white.withOpacity(0.7),
                            elevation: _canSubmit ? 4 : 0,
                            shadowColor: AppColors.primary.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Log in link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 14, color: subColor),
                            children: [
                              const TextSpan(
                                  text: 'Already have an account? '),
                              TextSpan(
                                text: 'Log in',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // TODO: navigate to login
                                  },
                              ),
                            ],
                          ),
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
    );
  }

  Widget _fieldLabel(String text, Color color) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      );
}

// Password input with visibility toggle
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool visible;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.visible,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: 22,
          ),
          onPressed: onToggle,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

// Agreement checkbox row with tappable link
class _AgreementRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final String label;
  final String linkText;
  final String subtitle;
  final VoidCallback onLinkTap;

  const _AgreementRow({
    required this.value,
    required this.onChanged,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.label,
    required this.linkText,
    required this.subtitle,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: isDark
                  ? const Color(0xFF475569)
                  : const Color(0xFFCBD5E1),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  children: [
                    TextSpan(text: label),
                    TextSpan(
                      text: linkText,
                      style: const TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = onLinkTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: subColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
