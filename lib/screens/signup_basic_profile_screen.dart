import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import 'signup_faith_background_screen.dart';

class SignupBasicProfileScreen extends StatefulWidget {
  const SignupBasicProfileScreen({super.key});

  @override
  State<SignupBasicProfileScreen> createState() =>
      _SignupBasicProfileScreenState();
}

class _SignupBasicProfileScreenState extends State<SignupBasicProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  DateTime? _dob;
  String? _gender;

  static const _genders = [
    _GenderOption('male', 'Male'),
    _GenderOption('female', 'Female'),
    _GenderOption('other', 'Other'),
    _GenderOption('prefer-not', 'Prefer not to say'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // Save the user's first name globally so all screens can display it
      final name = _nameCtrl.text.trim();
      if (name.isNotEmpty) {
        userNameNotifier.value = name.split(' ').first;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SignupFaithBackgroundScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final labelColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top nav
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black87),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Text(
                    'Create Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step 1: Basic Information',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '1 of 5',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: 0.2,
                      minHeight: 8,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile photo
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // TODO: image picker
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 128,
                                    height: 128,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFCBD5E1),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF1E293B)
                                            : Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 64,
                                      color: isDark
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to add your picture',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Full Name
                      _FieldLabel(
                        label: 'Full Name',
                        isDark: isDark,
                        labelColor: labelColor,
                        child: _InputField(
                          controller: _nameCtrl,
                          hint: 'Enter your full name',
                          cardBg: cardBg,
                          borderColor: borderColor,
                          isDark: isDark,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Full name is required'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      _FieldLabel(
                        label: 'Email Address',
                        isDark: isDark,
                        labelColor: labelColor,
                        child: _InputField(
                          controller: _emailCtrl,
                          hint: 'example@church.com',
                          keyboardType: TextInputType.emailAddress,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          isDark: isDark,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(v.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone (optional)
                      _FieldLabel(
                        label: 'Phone Number',
                        optional: true,
                        isDark: isDark,
                        labelColor: labelColor,
                        child: _InputField(
                          controller: _phoneCtrl,
                          hint: '+1 (555) 000-0000',
                          keyboardType: TextInputType.phone,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // DOB + Gender row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _FieldLabel(
                              label: 'Date of Birth',
                              isDark: isDark,
                              labelColor: labelColor,
                              child: GestureDetector(
                                onTap: _pickDate,
                                child: Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _dob != null
                                              ? '${_dob!.month.toString().padLeft(2, '0')}/'
                                                  '${_dob!.day.toString().padLeft(2, '0')}/'
                                                  '${_dob!.year}'
                                              : 'MM/DD/YYYY',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: _dob != null
                                                ? (isDark
                                                    ? Colors.white
                                                    : Colors.black87)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.calendar_today,
                                          size: 18, color: Colors.grey[500]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _FieldLabel(
                              label: 'Gender',
                              isDark: isDark,
                              labelColor: labelColor,
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _gender,
                                    hint: Text(
                                      'Select',
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 15),
                                    ),
                                    isExpanded: true,
                                    dropdownColor: cardBg,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey[500]),
                                    onChanged: (v) =>
                                        setState(() => _gender = v),
                                    items: _genders
                                        .map((g) => DropdownMenuItem(
                                              value: g.value,
                                              child: Text(g.label),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Country/City
                      _FieldLabel(
                        label: 'Country/City',
                        isDark: isDark,
                        labelColor: labelColor,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 14),
                                child: Icon(Icons.location_on,
                                    color: Colors.grey, size: 22),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _locationCtrl,
                                  decoration: const InputDecoration(
                                    hintText: 'Search your city',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue to Step 2',
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
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderOption {
  final String value;
  final String label;
  const _GenderOption(this.value, this.label);
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool optional;
  final Widget child;
  final bool isDark;
  final Color labelColor;

  const _FieldLabel({
    required this.label,
    required this.child,
    required this.isDark,
    required this.labelColor,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
              children: optional
                  ? [
                      TextSpan(
                        text: '  (Optional)',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: labelColor.withOpacity(0.6),
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final Color cardBg;
  final Color borderColor;
  final bool isDark;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.cardBg,
    required this.borderColor,
    required this.isDark,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 15,
        color: isDark ? Colors.white : Colors.black87,
      ),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
