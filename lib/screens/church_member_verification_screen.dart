import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'member_facial_scan_screen.dart';

class ChurchMemberVerificationScreen extends StatefulWidget {
  const ChurchMemberVerificationScreen({super.key});

  @override
  State<ChurchMemberVerificationScreen> createState() =>
      _ChurchMemberVerificationScreenState();
}

class _ChurchMemberVerificationScreenState
    extends State<ChurchMemberVerificationScreen> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _churchCtrl = TextEditingController();

  String _idType = 'National ID';
  bool _idUploaded = false;
  bool _submitting = false;

  static const _idTypes = [
    'National ID',
    'Passport',
    "Driver's License",
    'Voter's Card',
  ];

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _churchCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1930),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );
    if (d != null) {
      _dobCtrl.text =
          '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MemberFacialScanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const sage = Color(0xFFB6C9BB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                border:
                    Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Member Verification',
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
                      color: sage.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Step 1 of 2',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(sage),
              minHeight: 3,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero icon
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sage.withOpacity(0.15),
                          border: Border.all(
                              color: sage.withOpacity(0.4), width: 2),
                        ),
                        child: Icon(Icons.verified_user_outlined,
                            color: sage, size: 34),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'Verify Your Identity',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Your information is encrypted and never shared.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, color: subColor, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal details section
                    _SectionLabel(
                        label: 'Personal Details',
                        icon: Icons.person_outline,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 12),
                    _FieldLabel(label: 'Full Legal Name', textColor: textColor),
                    _InputField(
                      controller: _fullNameCtrl,
                      hint: 'e.g. Sarah A. Jenkins',
                      prefix: Icons.badge_outlined,
                      isDark: isDark,
                      inputBg: inputBg,
                      borderColor: borderColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(
                                  label: 'Email Address',
                                  textColor: textColor),
                              _InputField(
                                controller: _emailCtrl,
                                hint: 'you@email.com',
                                prefix: Icons.email_outlined,
                                isDark: isDark,
                                inputBg: inputBg,
                                borderColor: borderColor,
                                textColor: textColor,
                                keyboardType:
                                    TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(
                                  label: 'Phone Number',
                                  textColor: textColor),
                              _InputField(
                                controller: _phoneCtrl,
                                hint: '+1 555 0000',
                                prefix: Icons.phone_outlined,
                                isDark: isDark,
                                inputBg: inputBg,
                                borderColor: borderColor,
                                textColor: textColor,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(
                        label: 'Date of Birth', textColor: textColor),
                    GestureDetector(
                      onTap: _pickDob,
                      child: Container(
                        height: 52,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined,
                                size: 18, color: subColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _dobCtrl.text.isEmpty
                                    ? 'DD / MM / YYYY'
                                    : _dobCtrl.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _dobCtrl.text.isEmpty
                                      ? subColor
                                      : textColor,
                                ),
                              ),
                            ),
                            Icon(Icons.calendar_today_outlined,
                                size: 16, color: subColor),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Church connection
                    _SectionLabel(
                        label: 'Church Connection',
                        icon: Icons.church_outlined,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 12),
                    _FieldLabel(
                        label: 'Your Church Name',
                        textColor: textColor),
                    _InputField(
                      controller: _churchCtrl,
                      hint: 'e.g. Grace Community Church',
                      prefix: Icons.church_outlined,
                      isDark: isDark,
                      inputBg: inputBg,
                      borderColor: borderColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 24),

                    // ID upload section
                    _SectionLabel(
                        label: 'Government ID',
                        icon: Icons.credit_card_outlined,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 12),
                    _FieldLabel(
                        label: 'ID Type', textColor: textColor),
                    Container(
                      height: 52,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _idType,
                          isExpanded: true,
                          dropdownColor: inputBg,
                          style:
                              TextStyle(fontSize: 14, color: textColor),
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: subColor),
                          items: _idTypes
                              .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Row(
                                    children: [
                                      Icon(Icons.credit_card_outlined,
                                          size: 16, color: subColor),
                                      const SizedBox(width: 8),
                                      Text(t),
                                    ],
                                  )))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _idType = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(
                        label: 'Upload ID Document',
                        textColor: textColor),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _idUploaded = !_idUploaded),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 130,
                        decoration: BoxDecoration(
                          color: _idUploaded
                              ? sage.withOpacity(0.08)
                              : inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _idUploaded
                                ? sage.withOpacity(0.5)
                                : borderColor,
                            style: _idUploaded
                                ? BorderStyle.solid
                                : BorderStyle.solid,
                            width: _idUploaded ? 1.5 : 1,
                          ),
                        ),
                        child: _idUploaded
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: sage.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                        Icons.check_circle_outline,
                                        color: sage,
                                        size: 28),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ID document uploaded',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: sage,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Tap to replace',
                                    style: TextStyle(
                                        fontSize: 11, color: subColor),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_file_outlined,
                                      color: subColor, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload your $_idType',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: subColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'JPG, PNG or PDF · Max 5 MB',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            subColor.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Privacy note
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: sage.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: sage.withOpacity(0.25)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lock_outline,
                              color: sage, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your ID is encrypted end-to-end and reviewed only by verified church administrators. It is never stored beyond 48 hours.',
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

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sage,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              sage.withOpacity(0.5),
                          elevation: 6,
                          shadowColor: sage.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16)),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5),
                              )
                            : const Text(
                                'Continue to Facial Scan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'IDENTITY VERIFICATION · STEP 1 OF 2',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.4,
                          color: subColor.withOpacity(0.5),
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
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final Color textColor;

  const _SectionLabel({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFB6C9BB)),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final Color textColor;

  const _FieldLabel({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor.withOpacity(0.75),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final bool isDark;
  final Color inputBg;
  final Color borderColor;
  final Color textColor;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefix,
    required this.isDark,
    required this.inputBg,
    required this.borderColor,
    required this.textColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF);
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(prefix, size: 18, color: subColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(fontSize: 14, color: textColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(fontSize: 14, color: subColor),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
