import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class NewJournalEntryScreen extends StatefulWidget {
  const NewJournalEntryScreen({super.key});

  @override
  State<NewJournalEntryScreen> createState() => _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState extends State<NewJournalEntryScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _selectedDate = 'Today';
  final _dateOptions = ['Today', 'Yesterday', 'Custom Date'];
  final _availableTags = ['Reflection', 'Prayer', 'Study', 'Gratitude'];
  final _activeTags = {'Reflection'};

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty && _bodyCtrl.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal entry saved.'),
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
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

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
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'New Reflection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _save,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title input
                    TextField(
                      controller: _titleCtrl,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                      decoration: InputDecoration(
                        hintText: "What's on your heart today?",
                        hintStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: subColor.withOpacity(0.6),
                          letterSpacing: -0.3,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Date dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDate,
                          isDense: true,
                          dropdownColor: cardBg,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: AppColors.primary, size: 18),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          items: _dateOptions
                              .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _selectedDate = v);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Divider(
                        color: AppColors.primary.withOpacity(0.08), height: 1),
                    const SizedBox(height: 20),

                    // Reflections label
                    Row(
                      children: [
                        const Icon(Icons.edit_note,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Reflections',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: subColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Body textarea
                    TextField(
                      controller: _bodyCtrl,
                      maxLines: null,
                      minLines: 10,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Write your thoughts, prayers, or study notes here...',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: subColor.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Divider(
                        color: AppColors.primary.withOpacity(0.08), height: 1),
                    const SizedBox(height: 16),

                    // Tags label
                    Text(
                      'TAGS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tag chips row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._availableTags.map((tag) {
                          final active = _activeTags.contains(tag);
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (active) {
                                _activeTags.remove(tag);
                              } else {
                                _activeTags.add(tag);
                              }
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary.withOpacity(0.12)
                                    : cardBg,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primary.withOpacity(0.4)
                                      : borderColor,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: active ? AppColors.primary : subColor,
                                ),
                              ),
                            ),
                          );
                        }),

                        // Add tag button (dashed)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: borderColor,
                                // Simulate dashed with a semi-transparent color
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, size: 14, color: subColor),
                                const SizedBox(width: 4),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Decorative verse card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.08),
                            const Color(0xFF4A6741).withOpacity(0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.self_improvement,
                            color: AppColors.primary.withOpacity(0.5),
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"Be still, and know that I am God."',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '— Psalm 46:10',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Footer
                    Center(
                      child: Text(
                        'Global Community Journal',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.5,
                          color: subColor.withOpacity(0.6),
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
