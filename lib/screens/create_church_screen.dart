import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';

class CreateChurchScreen extends StatefulWidget {
  const CreateChurchScreen({super.key});

  @override
  State<CreateChurchScreen> createState() => _CreateChurchScreenState();
}

class _CreateChurchScreenState extends State<CreateChurchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _denomination = 'Non-Denominational';
  bool _saving = false;
  String? _uploadedDocName; // simulates a document upload

  static const _denominations = [
    'Non-Denominational',
    'Baptist',
    'Catholic',
    'Pentecostal',
    'Methodist',
    'Presbyterian',
    'Lutheran',
    'Anglican / Episcopal',
    'Seventh-day Adventist',
    'Assemblies of God',
    'Church of Christ',
    'Orthodox',
    'Reformed',
    'Evangelical',
    'Other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    // In a real app this would open the file picker.
    // For now we simulate a successful document upload.
    setState(() => _uploadedDocName = 'church_registration_license.pdf');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document uploaded successfully.'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_uploadedDocName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your church registration document before continuing.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    myChurchNotifier.value = ChurchProfile(
      name: _nameCtrl.text.trim(),
      denomination: _denomination,
      location: _locationCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      createdAt: DateTime.now(),
    );
    isPastorNotifier.value = true;

    setState(() => _saving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_nameCtrl.text.trim()} has been created!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                      'Create Your Church',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.85),
                              AppColors.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: const Icon(Icons.church,
                                  color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Establish Your Congregation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You will become the pastor of this church with full administrative authority.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.85),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      _fieldLabel('Church Name *', textColor),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: _nameCtrl,
                        hint: 'e.g. Grace Community Church',
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Church name is required' : null,
                      ),
                      const SizedBox(height: 20),

                      _fieldLabel('Denomination *', textColor),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _denomination,
                          dropdownColor: cardBg,
                          style: TextStyle(fontSize: 15, color: textColor),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: InputBorder.none,
                          ),
                          items: _denominations
                              .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _denomination = v ?? _denomination),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _fieldLabel('Location *', textColor),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: _locationCtrl,
                        hint: 'e.g. Lagos, Nigeria',
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        prefixIcon: Icons.location_on_outlined,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Location is required' : null,
                      ),
                      const SizedBox(height: 20),

                      _fieldLabel('About Your Church', textColor),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 4,
                        style: TextStyle(fontSize: 15, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'Describe your vision, mission, and values…',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: cardBg,
                          contentPadding: const EdgeInsets.all(16),
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
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Church Registration Document ──────────────────────
                      _fieldLabel('Church Registration / License *', textColor),
                      const SizedBox(height: 6),
                      Text(
                        'Upload an official document proving your church is legally registered (e.g. CAC certificate, government license, or incorporation papers).',
                        style: TextStyle(fontSize: 12, color: subColor, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _simulateUpload,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _uploadedDocName != null
                                ? const Color(0xFF10B981).withOpacity(0.07)
                                : cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _uploadedDocName != null
                                  ? const Color(0xFF10B981).withOpacity(0.5)
                                  : AppColors.primary.withOpacity(0.4),
                              width: _uploadedDocName != null ? 1.5 : 1,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: _uploadedDocName == null
                              ? Column(
                                  children: [
                                    Icon(Icons.upload_file,
                                        color: AppColors.primary, size: 32),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to upload document',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'PDF, JPG or PNG · Max 10 MB',
                                      style: TextStyle(
                                          fontSize: 11, color: subColor),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981)
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.description,
                                          color: Color(0xFF10B981), size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _uploadedDocName!,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: textColor),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Document uploaded ✓',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF10B981)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(
                                          () => _uploadedDocName = null),
                                      child: const Icon(Icons.close,
                                          color: Colors.grey, size: 18),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Permissions info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F2027)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_user,
                                    color: Color(0xFF10B981), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'As Pastor, you can:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...[
                              'Approve or reject member posts before they appear',
                              'Delete any post from the church feed',
                              'Block content with inappropriate language',
                              'Generate treasury access codes',
                              'Manage member verifications',
                            ].map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Color(0xFF10B981), size: 14),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(item,
                                          style: TextStyle(
                                              fontSize: 12, color: subColor)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            shadowColor: AppColors.primary.withOpacity(0.3),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text(
                                  'Create Church',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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

  Widget _fieldLabel(String label, Color color) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: cardBg,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey, size: 20)
            : null,
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
