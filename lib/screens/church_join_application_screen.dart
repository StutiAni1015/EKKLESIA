import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import 'member_facial_scan_screen.dart';

/// Multi-step church membership application flow:
///   Step 0 — Create a membership password
///   Step 1 — Facial scan + OTP (handled inside MemberFacialScanScreen)
///   Step 2 — Awaiting pastor approval
class ChurchJoinApplicationScreen extends StatefulWidget {
  final String churchName;
  final String churchLocation;

  const ChurchJoinApplicationScreen({
    super.key,
    required this.churchName,
    required this.churchLocation,
  });

  @override
  State<ChurchJoinApplicationScreen> createState() =>
      _ChurchJoinApplicationScreenState();
}

class _ChurchJoinApplicationScreenState
    extends State<ChurchJoinApplicationScreen> {
  int _step = 0; // 0=password, 2=pending

  // Password step
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _goToFacialScan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemberFacialScanScreen(
          onSuccess: () {
            // Called after facial scan + OTP both verified.
            Navigator.of(context).pop();
            // Submit membership request for pastor approval
            final name = userNameNotifier.value.trim().isEmpty
                ? 'New Applicant'
                : userNameNotifier.value.trim();
            final initials = name
                .split(' ')
                .where((w) => w.isNotEmpty)
                .take(2)
                .map((w) => w[0].toUpperCase())
                .join();
            membershipRequestsNotifier.value = [
              ...membershipRequestsNotifier.value,
              MembershipRequest(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                applicantName: name,
                applicantInitials: initials,
                applicantColor: const Color(0xFFB9D1EA),
                submittedAt: DateTime.now(),
              ),
            ];
            if (mounted) setState(() => _step = 2);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: _step == 2
            ? _buildPendingApproval(isDark)
            : _buildPasswordStep(isDark),
      ),
    );
  }

  // ── Step 0: Password ──────────────────────────────────────────────────────

  Widget _buildPasswordStep(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: Text(
                  'Join ${widget.churchName}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
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

        // Step indicator (3 steps: Password → Face+OTP → Done)
        _StepIndicator(currentStep: 0),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + title
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: const Icon(Icons.lock_outline,
                          color: AppColors.primary, size: 34),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Create a Membership Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This password will be used to verify your identity '
                    'when accessing church-specific features.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: subColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Password field
                  _FieldLabel(label: 'Password', textColor: textColor),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePass,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(fontSize: 15, color: textColor),
                    decoration: _inputDeco(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      hint: 'Enter a secure password',
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: subColor,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Password is required';
                      }
                      if (v.trim().length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm password
                  _FieldLabel(label: 'Confirm Password', textColor: textColor),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    style: TextStyle(fontSize: 15, color: textColor),
                    decoration: _inputDeco(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      hint: 'Re-enter your password',
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: subColor,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (v.trim() != _passwordCtrl.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Info card — explains pastor approval process
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'After completing this form, your application will be '
                            'reviewed by the pastor of ${widget.churchName}. '
                            'This is just a form submission — the final approval '
                            'will be done by your pastor.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: isDark
                                  ? AppColors.primary.withOpacity(0.9)
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToFacialScan,
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
                        'Continue to Facial Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Next: Facial scan → OTP verification',
                      style: TextStyle(fontSize: 12, color: subColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Step 2: Pending Pastor Approval ──────────────────────────────────────

  Widget _buildPendingApproval(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Application Submitted',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: textColor,
              ),
            ),
          ),
        ),
        _StepIndicator(currentStep: 2),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                28, 20, 28, MediaQuery.of(context).padding.bottom + 32),
            child: Column(
              children: [
                // Success illustration
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4ADE80).withOpacity(0.12),
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4ADE80).withOpacity(0.2),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF4ADE80),
                      size: 64,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  "You're Almost There!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your membership application for',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: subColor),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.churchName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'has been successfully submitted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: subColor),
                ),
                const SizedBox(height: 8),

                // Important note banner
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFF59E0B).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFFF59E0B), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This is a form submission only. Final '
                          'membership approval will be granted by the '
                          'pastor of ${widget.churchName}.',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // What happens next cards
                _NextStepCard(
                  icon: Icons.how_to_reg,
                  title: 'Pastor Review',
                  body:
                      'The pastor of ${widget.churchName} will review your application, verify your identity, and decide on your membership.',
                  color: const Color(0xFF6366F1),
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _NextStepCard(
                  icon: Icons.notifications_active_outlined,
                  title: "You'll Be Notified",
                  body:
                      'Once the pastor approves your membership, you will receive a notification and gain full access to church features.',
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _NextStepCard(
                  icon: Icons.people_outline,
                  title: 'Join the Community',
                  body:
                      'After approval you can access sermons, prayer groups, giving, church announcements, and fellowship features.',
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
                const SizedBox(height: 28),

                // Scripture card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🙏', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '"I was glad when they said to me, '
                          'Let us go to the house of the Lord." — Psalm 122:1\n\n'
                          'We pray your membership brings you into deeper '
                          'fellowship and spiritual growth.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.65,
                            fontStyle: FontStyle.italic,
                            color: subColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Back to home
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDeco({
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required String hint,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        fontSize: 14,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: cardBg,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep; // 0, 1, 2

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = ['Password', 'Verify', 'Done'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final done = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: done
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.15),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final done = stepIndex < currentStep;
          final active = stepIndex == currentStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 14)
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: active
                                ? Colors.white
                                : AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight:
                      active ? FontWeight.bold : FontWeight.normal,
                  color: active
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final Color textColor;
  const _FieldLabel({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final bool isDark;

  const _NextStepCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
