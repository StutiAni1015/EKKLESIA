import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Reusable bottom sheet that shows an interactive reading checklist for a
/// Bible plan. Used from both the Discover Plans screen and the Dashboard.
class PlanChecklistSheet extends StatefulWidget {
  final String planTitle;
  final Color gradientStart;
  final Color gradientEnd;
  final List<String> readings;
  /// Called when the user presses the CTA after completing all items.
  final VoidCallback? onComplete;

  const PlanChecklistSheet({
    super.key,
    required this.planTitle,
    required this.gradientStart,
    required this.gradientEnd,
    required this.readings,
    this.onComplete,
  });

  @override
  State<PlanChecklistSheet> createState() => _PlanChecklistSheetState();
}

class _PlanChecklistSheetState extends State<PlanChecklistSheet> {
  late final List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.readings.length, false);
  }

  int get _doneCount => _checked.where((v) => v).length;
  bool get _allDone =>
      _checked.isNotEmpty && _doneCount == _checked.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
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

          // Header row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.gradientStart,
                      widget.gradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.planTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      "Today's Reading Checklist",
                      style: TextStyle(fontSize: 12, color: subColor),
                    ),
                  ],
                ),
              ),
              // Progress pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _allDone
                      ? AppColors.primary.withOpacity(0.12)
                      : (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_doneCount / ${_checked.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _allDone ? AppColors.primary : subColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _checked.isEmpty
                  ? 0
                  : _doneCount / _checked.length,
              minHeight: 6,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),

          const SizedBox(height: 20),

          // Checklist items
          ...List.generate(widget.readings.length, (i) {
            final reading = widget.readings[i];
            final isSpecial = reading.startsWith('Memory Verse') ||
                reading.startsWith('Prayer Focus');
            return GestureDetector(
              onTap: () => setState(() => _checked[i] = !_checked[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _checked[i]
                      ? AppColors.primary.withOpacity(0.07)
                      : (isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _checked[i]
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _checked[i]
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: _checked[i]
                              ? AppColors.primary
                              : (isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFFCBD5E1)),
                          width: 2,
                        ),
                      ),
                      child: _checked[i]
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reading,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  _checked[i] ? subColor : textColor,
                              decoration: _checked[i]
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (isSpecial) ...[
                            const SizedBox(height: 2),
                            Text(
                              reading.startsWith('Memory')
                                  ? 'Memorize & meditate'
                                  : 'Pray for this region',
                              style: TextStyle(
                                  fontSize: 11, color: subColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isSpecial)
                      const Icon(Icons.auto_awesome,
                          size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // CTA button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_allDone && widget.onComplete != null) {
                  widget.onComplete!();
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.3),
              ),
              child: Text(
                _allDone
                    ? 'Day Complete! 🎉'
                    : _doneCount > 0
                        ? 'Keep Going ($_doneCount/${_checked.length} done)'
                        : 'Start Reading →',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
