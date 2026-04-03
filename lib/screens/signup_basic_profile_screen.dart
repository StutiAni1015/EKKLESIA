import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import 'signup_faith_background_screen.dart';
import 'otp_verification_screen.dart';

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
  final _cityCtrl = TextEditingController();

  DateTime? _dob;
  String? _gender;
  String? _selectedCountry;

  // Country → (countryCode, currency, symbol)
  static const _countries = [
    ('United States', 'US', 'USD', '\$'),
    ('United Kingdom', 'GB', 'GBP', '£'),
    ('Nigeria', 'NG', 'NGN', '₦'),
    ('Kenya', 'KE', 'KES', 'KSh'),
    ('Ghana', 'GH', 'GHS', '₵'),
    ('South Africa', 'ZA', 'ZAR', 'R'),
    ('Uganda', 'UG', 'UGX', 'USh'),
    ('Ethiopia', 'ET', 'ETB', 'Br'),
    ('Tanzania', 'TZ', 'TZS', 'TSh'),
    ('Rwanda', 'RW', 'RWF', 'Fr'),
    ('Brazil', 'BR', 'BRL', 'R\$'),
    ('Canada', 'CA', 'CAD', 'CA\$'),
    ('Australia', 'AU', 'AUD', 'A\$'),
    ('India', 'IN', 'INR', '₹'),
    ('Philippines', 'PH', 'PHP', '₱'),
    ('South Korea', 'KR', 'KRW', '₩'),
    ('Germany', 'DE', 'EUR', '€'),
    ('France', 'FR', 'EUR', '€'),
    ('Mexico', 'MX', 'MXN', 'MX\$'),
    ('Colombia', 'CO', 'COP', 'Col\$'),
    ('Argentina', 'AR', 'ARS', 'AR\$'),
    ('China', 'CN', 'CNY', '¥'),
    ('Japan', 'JP', 'JPY', '¥'),
    ('Indonesia', 'ID', 'IDR', 'Rp'),
    ('Pakistan', 'PK', 'PKR', '₨'),
    ('Zimbabwe', 'ZW', 'USD', '\$'),
    ('Zambia', 'ZM', 'ZMW', 'ZK'),
    ('Cameroon', 'CM', 'XAF', 'Fr'),
    ('DR Congo', 'CD', 'CDF', 'Fr'),
    ('Ivory Coast', 'CI', 'XOF', 'Fr'),
  ];

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
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // Maximum date allowed: must be at least 10 years old
    final maxDate = DateTime(now.year - 10, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: maxDate,
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

  static const _emojis = [
    '😊', '🙏', '✝️', '👑', '🕊️', '❤️', '🌟', '🎵', '📖', '🌸',
    '⚓', '🌈', '🦁', '🌿', '💛', '🫶', '🙌', '🌺', '🎶', '🕯️',
  ];

  void _showProfilePictureOptions(BuildContext context, bool isDark) {
    final sheetBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                // Options
                _SheetOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Upload from Gallery',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Gallery upload coming soon — choose an emoji for now!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _SheetOption(
                  icon: Icons.visibility_outlined,
                  label: 'View Current Photo',
                  isDark: isDark,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose Emoji Avatar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _emojis
                      .map((e) => GestureDetector(
                            onTap: () {
                              userProfileEmojiNotifier.value = e;
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: userProfileEmojiNotifier.value == e
                                    ? AppColors.primary.withOpacity(0.15)
                                    : (isDark
                                        ? const Color(0xFF0F172A)
                                        : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      userProfileEmojiNotifier.value == e
                                          ? AppColors.primary
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(e,
                                    style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                if (userProfileEmojiNotifier.value != null)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        userProfileEmojiNotifier.value = null;
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Remove Photo',
                        style: TextStyle(
                            color: Colors.red[400], fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // Validate age >= 10
      if (_dob != null) {
        final now = DateTime.now();
        final age = now.year -
            _dob!.year -
            ((now.month < _dob!.month ||
                    (now.month == _dob!.month && now.day < _dob!.day))
                ? 1
                : 0);
        if (age < 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You must be at least 10 years old to register.'),
              backgroundColor: Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }
      // Save name
      final name = _nameCtrl.text.trim();
      if (name.isNotEmpty) {
        userNameNotifier.value = name.split(' ').first;
      }
      // Register this email so it cannot be used again
      final email = _emailCtrl.text.trim().toLowerCase();
      registeredEmailsNotifier.value = {
        ...registeredEmailsNotifier.value,
        email,
      };
      // Save country + currency if selected
      if (_selectedCountry != null) {
        final entry = _countries.firstWhere(
            (c) => c.$1 == _selectedCountry,
            orElse: () => _countries.first);
        userCountryNotifier.value = entry.$2;
        userCurrencyNotifier.value = entry.$3;
        userCurrencySymbolNotifier.value = entry.$4;
      }
      // ── Step 1: Verify phone number ────────────────────────────────────
      final phone = _phoneCtrl.text.trim();
      final maskedPhone = _maskPhone(phone);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            title: 'Phone Verification',
            verificationTarget: 'phone number',
            maskedContact: maskedPhone,
            onVerified: () {
              phoneVerifiedNotifier.value = true;
              // ── Step 2: Verify email ──────────────────────────────────
              final emailMasked = _maskEmail(email);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpVerificationScreen(
                    title: 'Email Verification',
                    verificationTarget: 'email address',
                    maskedContact: emailMasked,
                    onVerified: () {
                      emailVerifiedNotifier.value = true;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupFaithBackgroundScreen(),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  /// e.g. "+1 234 567 8901" → "+1 234 ••• 8901"
  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '${phone.substring(0, phone.length > 6 ? 4 : 2)} •••• $visible';
  }

  /// e.g. "john@gmail.com" → "j••n@gmail.com"
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final masked = name.length > 2
        ? '${name[0]}${'•' * (name.length - 2)}${name[name.length - 1]}'
        : '••';
    return '$masked@${parts[1]}';
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
                            ValueListenableBuilder<String?>(
                              valueListenable: userProfileEmojiNotifier,
                              builder: (context, emoji, _) {
                                return GestureDetector(
                                  onTap: () => _showProfilePictureOptions(
                                      context, isDark),
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
                                              color: Colors.black
                                                  .withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: emoji != null
                                            ? Center(
                                                child: Text(emoji,
                                                    style: const TextStyle(
                                                        fontSize: 52)),
                                              )
                                            : Icon(
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
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to add your picture or choose emoji',
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
                            if (registeredEmailsNotifier.value
                                .contains(v.trim().toLowerCase())) {
                              return 'This email is already registered';
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

                      // Country picker
                      _FieldLabel(
                        label: 'Country',
                        isDark: isDark,
                        labelColor: labelColor,
                        child: Container(
                          height: 56,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.public,
                                  color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCountry,
                                    isExpanded: true,
                                    dropdownColor: cardBg,
                                    hint: Text(
                                      'Select your country',
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 15),
                                    ),
                                    icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[500]),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    onChanged: (v) =>
                                        setState(() => _selectedCountry = v),
                                    items: _countries
                                        .map((c) => DropdownMenuItem(
                                              value: c.$1,
                                              child: Text(c.$1),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // City (optional)
                      _FieldLabel(
                        label: 'City',
                        optional: true,
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
                                    color: Colors.grey, size: 20),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _cityCtrl,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your city',
                                    hintStyle:
                                        TextStyle(color: Colors.grey),
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

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right,
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
                size: 18),
          ],
        ),
      ),
    );
  }
}
