import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';

/// OTP Verification screen shown after a successful facial scan.
/// [onVerified] is called once the user enters the correct code.
/// [maskedContact] is the phone/email shown in the subtitle (e.g. "+1 •••• 4821").
class OtpVerificationScreen extends StatefulWidget {
  final VoidCallback onVerified;
  final String maskedContact;

  /// Header title — defaults to 'OTP Verification'.
  /// Set to 'Phone Verification' or 'Email Verification' as needed.
  final String title;

  /// Human-readable contact type shown in the subtitle,
  /// e.g. 'phone number', 'email address'.
  final String verificationTarget;

  const OtpVerificationScreen({
    super.key,
    required this.onVerified,
    this.maskedContact = '+1 •••• •••• 4821',
    this.title = 'OTP Verification',
    this.verificationTarget = 'contact',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const _length = 6;

  final _controllers =
      List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  int _secondsLeft = 60;
  Timer? _timer;
  bool _verifying = false;
  bool _wrongCode = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first box after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _enteredCode =>
      _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    setState(() => _wrongCode = false);
    if (value.length == 1 && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-submit when last digit is filled
    if (index == _length - 1 && value.isNotEmpty) {
      _verify();
    }
  }

  void _onKeyDown(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verify() async {
    final code = _enteredCode;
    if (code.length < _length) return;

    setState(() => _verifying = true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Demo: "000000" always fails; anything else succeeds
    if (code == '000000') {
      setState(() {
        _verifying = false;
        _wrongCode = true;
      });
      for (final c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
    } else {
      setState(() => _verifying = false);
      widget.onVerified();
    }
  }

  void _resend() {
    for (final c in _controllers) c.clear();
    setState(() => _wrongCode = false);
    _startTimer();
    _focusNodes[0].requestFocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent successfully!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                child: Column(
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Enter Verification Code',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 13, color: subColor, height: 1.55),
                        children: [
                          TextSpan(
                              text: 'A 6-digit code has been sent to your ${widget.verificationTarget}\n'),
                          TextSpan(
                            text: widget.maskedContact,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // OTP input boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_length, (i) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (e) => _onKeyDown(i, e),
                            child: SizedBox(
                              width: 46,
                              height: 56,
                              child: TextField(
                                controller: _controllers[i],
                                focusNode: _focusNodes[i],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _wrongCode
                                      ? const Color(0xFFEF4444)
                                      : textColor,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: _wrongCode
                                      ? const Color(0xFFEF4444)
                                          .withOpacity(0.08)
                                      : cardBg,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _wrongCode
                                          ? const Color(0xFFEF4444)
                                          : borderColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _wrongCode
                                          ? const Color(0xFFEF4444)
                                          : borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _wrongCode
                                          ? const Color(0xFFEF4444)
                                          : AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (v) => _onDigitChanged(i, v),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    // Error message
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _wrongCode
                          ? Padding(
                              key: const ValueKey('err'),
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Color(0xFFEF4444), size: 14),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Incorrect code. Please try again.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color(0xFFEF4444),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(key: ValueKey('no-err'), height: 12),
                    ),

                    const SizedBox(height: 28),

                    // Resend row
                    _secondsLeft > 0
                        ? Text(
                            'Resend OTP in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 13,
                              color: subColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : TextButton(
                            onPressed: _resend,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                    const SizedBox(height: 32),

                    // Verify button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (_verifying ||
                                _enteredCode.length < _length)
                            ? null
                            : _verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.4),
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _verifying
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                              )
                            : const Text(
                                'Verify & Continue',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Privacy note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lock_outline,
                              color: AppColors.primary, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This verifies your ${widget.verificationTarget}. The code is valid for 10 minutes and expires after use.',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: subColor,
                                  height: 1.5),
                            ),
                          ),
                        ],
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
