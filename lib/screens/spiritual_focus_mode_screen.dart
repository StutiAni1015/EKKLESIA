import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'prayer_focus_active_screen.dart';

class SpiritualFocusModeScreen extends StatefulWidget {
  const SpiritualFocusModeScreen({super.key});

  @override
  State<SpiritualFocusModeScreen> createState() =>
      _SpiritualFocusModeScreenState();
}

class _SpiritualFocusModeScreenState extends State<SpiritualFocusModeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1; // default = 30 min

  static const _durations = [
    _Duration(value: 15, unit: 'Minutes'),
    _Duration(value: 30, unit: 'Minutes'),
    _Duration(value: 45, unit: 'Minutes'),
    _Duration(value: 1, unit: 'Hour'),
  ];

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startFocus() {
    final d = _durations[_selectedIndex];
    final totalMinutes = d.unit == 'Hour' ? d.value * 60 : d.value;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PrayerFocusActiveScreen(totalMinutes: totalMinutes),
      ),
    );
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
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Spiritual Focus',
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

            // Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  children: [
                    // Illustration
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Blur glow ring
                            ScaleTransition(
                              scale: _pulseAnim,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppColors.primary.withOpacity(0.1),
                                ),
                              ),
                            ),
                            // Image placeholder with gradient
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary.withOpacity(0.08),
                                      const Color(0xFFB2C2A3)
                                          .withOpacity(0.3),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.self_improvement,
                                      size: 100,
                                      color: AppColors.primary
                                          .withOpacity(0.25),
                                    ),
                                    Positioned(
                                      bottom: 32,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: AppColors.primary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: const Text(
                                          'Be still, and know that I am God',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.primary,
                                          ),
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
                    ),
                    const SizedBox(height: 28),

                    // Title + description
                    Text(
                      'Spiritual Focus Mode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "This mode acts as a 'Child Lock' for your spiritual growth. Once started, you'll stay within the app to prevent distractions and keep your heart centered on the Word.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Duration label
                    Text(
                      'SELECT DURATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Duration grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.8,
                      children: List.generate(_durations.length, (i) {
                        final d = _durations[i];
                        final selected = _selectedIndex == i;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withOpacity(0.07)
                                  : cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : borderColor,
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${d.value}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: selected
                                        ? AppColors.primary
                                        : textColor,
                                  ),
                                ),
                                Text(
                                  d.unit.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: selected
                                        ? AppColors.primary.withOpacity(0.8)
                                        : subColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),

                    // Start button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _startFocus,
                        icon: const Icon(Icons.timer, size: 22),
                        label: const Text(
                          'Start Focus Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: AppColors.primary.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Footer note
                    Text(
                      'Your notifications will be paused until the timer ends.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: subColor),
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

class _Duration {
  final int value;
  final String unit;
  const _Duration({required this.value, required this.unit});
}
