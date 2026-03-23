import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'pastor_facial_scan_screen.dart';

class PastorVerificationScreen extends StatefulWidget {
  const PastorVerificationScreen({super.key});

  @override
  State<PastorVerificationScreen> createState() =>
      _PastorVerificationScreenState();
}

class _PastorVerificationScreenState
    extends State<PastorVerificationScreen> {
  final _churchNameCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _referenceCtrl = TextEditingController();
  bool _docUploaded = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _churchNameCtrl.dispose();
    _websiteCtrl.dispose();
    _referenceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PastorFacialScanScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final labelColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : AppColors.primary.withOpacity(0.2);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(4, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Pastor Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    20, 24, 20, MediaQuery.of(context).padding.bottom + 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Credentials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide the following details to verify your pastoral role within the community.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Church Name
                    _FieldLabel('Church Name', labelColor),
                    const SizedBox(height: 8),
                    _FormInput(
                      controller: _churchNameCtrl,
                      hint: "Enter your church's full name",
                      bg: inputBg,
                      textColor: textColor,
                      hintColor: subColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 20),

                    // Church Website
                    _FieldLabel('Church Website', labelColor),
                    const SizedBox(height: 8),
                    _FormInput(
                      controller: _websiteCtrl,
                      hint: 'https://www.yourchurch.org',
                      bg: inputBg,
                      textColor: textColor,
                      hintColor: subColor,
                      borderColor: borderColor,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 20),

                    // ID Upload
                    _FieldLabel('Identity Verification', labelColor),
                    const SizedBox(height: 4),
                    Text(
                      'Upload a copy of your ordination certificate or ministerial ID',
                      style:
                          TextStyle(fontSize: 12, color: subColor),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _docUploaded = !_docUploaded),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _docUploaded
                              ? AppColors.primary.withOpacity(0.08)
                              : AppColors.primary.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _docUploaded
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.check_circle_outline,
                                        color: Color(0xFF10B981),
                                        size: 32),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Document uploaded',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined,
                                      color: AppColors.primary,
                                      size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload document',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: subColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'PDF, JPG, or PNG (Max 5MB)',
                                    style: TextStyle(
                                        fontSize: 11, color: subColor),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Reference Contact
                    _FieldLabel('Reference Contact', labelColor),
                    const SizedBox(height: 8),
                    _FormInput(
                      controller: _referenceCtrl,
                      hint: 'Senior Pastor or Elder name & email',
                      bg: inputBg,
                      textColor: textColor,
                      hintColor: subColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pending status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'VERIFICATION PENDING',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor:
                            AppColors.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit for Review',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your data is securely encrypted and will only be used for professional verification purposes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: subColor),
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

// ─── Supporting widgets ──────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _FieldLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color bg;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;
  final TextInputType? keyboardType;

  const _FormInput({
    required this.controller,
    required this.hint,
    required this.bg,
    required this.textColor,
    required this.hintColor,
    required this.borderColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 15, color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
                color: AppColors.primary, width: 1.5),
          ),
          filled: true,
          fillColor: bg,
        ),
      ),
    );
  }
}
