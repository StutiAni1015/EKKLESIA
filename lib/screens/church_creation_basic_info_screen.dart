import 'package:flutter/material.dart';
import 'church_creation_location_screen.dart';

const _ivory = Color(0xFFFFFDF9);
const _nude = Color(0xFFF7E7D6);
const _dustyRose = Color(0xFFDCAE96);
const _sage = Color(0xFFA7BCB9);

class ChurchCreationBasicInfoScreen extends StatefulWidget {
  const ChurchCreationBasicInfoScreen({super.key});

  @override
  State<ChurchCreationBasicInfoScreen> createState() =>
      _ChurchCreationBasicInfoScreenState();
}

class _ChurchCreationBasicInfoScreenState
    extends State<ChurchCreationBasicInfoScreen> {
  final _nameCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  String? _denomination;
  DateTime? _foundingDate;

  static const _denominations = [
    'Baptist',
    'Catholic',
    'Episcopal',
    'Methodist',
    'Non-denominational',
    'Pentecostal',
    'Presbyterian',
    'Other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _sage),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _foundingDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF221610) : _ivory;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final labelColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);
    final ringColor =
        isDark ? const Color(0xFF334155) : _nude;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Establish Identity',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      Text(
                        'Step 1 of 3',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _dustyRose,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: 1 / 3,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : _nude,
                      valueColor:
                          const AlwaysStoppedAnimation(_dustyRose),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    24, 0, 24, MediaQuery.of(context).padding.bottom + 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us a bit about your church to get started.',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Church Name
                    _FieldLabel('CHURCH NAME', labelColor),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _nameCtrl,
                      hint: 'e.g. Grace Community Chapel',
                      cardBg: cardBg,
                      ringColor: ringColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 20),

                    // Denomination
                    _FieldLabel('DENOMINATION', labelColor),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ringColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _denomination,
                          hint: Text(
                            'Select a denomination',
                            style:
                                TextStyle(color: subColor, fontSize: 15),
                          ),
                          isExpanded: true,
                          dropdownColor: cardBg,
                          style: TextStyle(
                              fontSize: 15, color: textColor),
                          icon:
                              Icon(Icons.unfold_more, color: subColor),
                          items: _denominations
                              .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _denomination = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Founding Date
                    _FieldLabel('FOUNDING DATE', labelColor),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: ringColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18, color: subColor),
                            const SizedBox(width: 10),
                            Text(
                              _foundingDate != null
                                  ? '${_foundingDate!.year}-${_foundingDate!.month.toString().padLeft(2, '0')}-${_foundingDate!.day.toString().padLeft(2, '0')}'
                                  : 'Select founding date',
                              style: TextStyle(
                                fontSize: 15,
                                color: _foundingDate != null
                                    ? textColor
                                    : subColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // About the Church
                    _FieldLabel('ABOUT THE CHURCH', labelColor),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ringColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _aboutCtrl,
                        maxLines: 5,
                        style: TextStyle(fontSize: 15, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'Share your mission or a brief history...',
                          hintStyle:
                              TextStyle(color: subColor, fontSize: 15),
                          contentPadding: const EdgeInsets.all(16),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
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

      // Fixed bottom "Next" button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            24, 12, 24, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: bg.withOpacity(0.85),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? const Color(0xFF334155)
                  : _nude.withOpacity(0.5),
            ),
          ),
        ),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChurchCreationLocationScreen(),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _sage,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: _sage.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _FieldLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color cardBg;
  final Color ringColor;
  final Color textColor;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.cardBg,
    required this.ringColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ringColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 15, color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: const Color(0xFF94A3B8), fontSize: 15),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
