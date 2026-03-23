import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';

class CreateGivingRequestScreen extends StatefulWidget {
  const CreateGivingRequestScreen({super.key});

  @override
  State<CreateGivingRequestScreen> createState() =>
      _CreateGivingRequestScreenState();
}

class _CreateGivingRequestScreenState
    extends State<CreateGivingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _category;
  bool _isSubmitting = false;

  static const _categories = [
    ('sickness', 'Sickness'),
    ('building', 'Church Building'),
    ('missionary', 'Missionary Support'),
    ('genuine', 'Other Genuine Need'),
  ];

  bool get _canSubmit =>
      _titleCtrl.text.trim().isNotEmpty &&
      _category != null &&
      _amountCtrl.text.trim().isNotEmpty &&
      _descCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleCtrl.addListener(_rebuild);
    _amountCtrl.addListener(_rebuild);
    _descCtrl.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    // TODO: POST /giving/requests
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Request submitted! It will be reviewed by an administrator.'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.maybePop(context);
    });
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
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final labelColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sticky header
            Container(
              decoration: BoxDecoration(
                color: bg.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
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
                      'Create Giving Request',
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
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16, MediaQuery.of(context).padding.bottom + 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero banner
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary.withOpacity(0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.volunteer_activism,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Share your vision with the community',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section heading
                      Text(
                        'Request Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Request Title
                      _label('Request Title', labelColor),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleCtrl,
                        style: TextStyle(fontSize: 15, color: textColor),
                        decoration: _inputDeco(
                          hint: 'e.g., Missionary Support',
                          cardBg: cardBg,
                          borderColor: borderColor,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Title is required'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // Category
                      _label('Category', labelColor),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _category,
                            hint: Text(
                              'Select category',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            isExpanded: true,
                            dropdownColor: cardBg,
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                            ),
                            icon: Icon(Icons.unfold_more, color: subColor),
                            items: _categories
                                .map((c) => DropdownMenuItem(
                                      value: c.$1,
                                      child: Text(c.$2),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _category = v),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Goal Amount
                      _label('Goal Amount', labelColor),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        style: TextStyle(fontSize: 15, color: textColor),
                        decoration: _inputDeco(
                          hint: '0.00',
                          cardBg: cardBg,
                          borderColor: borderColor,
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: subColor),
                            ),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Goal amount is required'
                                : null,
                      ),
                      const SizedBox(height: 16),

                      // Reason / Situation
                      _label('Reason / Situation', labelColor),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 4,
                        style: TextStyle(fontSize: 15, color: textColor),
                        decoration: _inputDeco(
                          hint: 'Describe the situation and how funds will be used...',
                          cardBg: cardBg,
                          borderColor: borderColor,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Description is required'
                                : null,
                      ),
                      const SizedBox(height: 24),

                      // Info box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E3A5F).withOpacity(0.4)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3B82F6).withOpacity(0.6)
                                : const Color(0xFF3B82F6),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: isDark
                                  ? const Color(0xFF60A5FA)
                                  : const Color(0xFF3B82F6),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.6,
                                    color: isDark
                                        ? const Color(0xFF93C5FD)
                                        : const Color(0xFF1D4ED8),
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'NOTE: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'For the safety and integrity of our community, all giving requests are reviewed and must be approved by an administrator before they become visible to the public.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _canSubmit && !_isSubmitting
                              ? _submit
                              : null,
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
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Post Request',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Disclaimer
                      Center(
                        child: Text(
                          'By posting, you agree to the community giving guidelines.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: subColor),
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

  Widget _label(String text, Color color) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      );

  InputDecoration _inputDeco({
    required String hint,
    required Color cardBg,
    required Color borderColor,
    Widget? prefix,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 0),
                child: prefix,
              )
            : null,
        prefixIconConstraints:
            prefix != null ? const BoxConstraints(minWidth: 0) : null,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
      );
}
