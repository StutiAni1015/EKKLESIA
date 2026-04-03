import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'personalized_daily_bread_screen.dart';
import 'kids_daily_bread_screen.dart';
import 'kids_home_screen.dart';

class DailyBreadCheckInScreen extends StatefulWidget {
  const DailyBreadCheckInScreen({super.key});

  @override
  State<DailyBreadCheckInScreen> createState() =>
      _DailyBreadCheckInScreenState();
}

class _DailyBreadCheckInScreenState extends State<DailyBreadCheckInScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedEmotion;
  bool _kidsMode = false;

  static const _emotions = [
    _Emotion('Anxious', Icons.air, Color(0xFF5B8CB8)),
    _Emotion('Joyful', Icons.sentiment_very_satisfied, Color(0xFFD4A547)),
    _Emotion('Grateful', Icons.volunteer_activism, Color(0xFF7B9E5E)),
    _Emotion('Stressed', Icons.thunderstorm, Color(0xFF8E6BBF)),
    _Emotion('Lonely', Icons.cloud, Color(0xFF5E80A8)),
    _Emotion('Peaceful', Icons.self_improvement, Color(0xFF5BA89A)),
  ];

  late final AnimationController _breatheController;
  late final Animation<double> _breatheAnim;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _breatheAnim = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_kidsMode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KidsHomeScreen()),
      );
      return;
    }
    if (_selectedEmotion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select how you are feeling today.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalizedDailyBreadScreen(
          emotionIndex: _selectedEmotion!,
        ),
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
                  const Expanded(
                    child: Text(
                      'DAILY REFLECTION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    24, 8, 24, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  children: [
                    // Hero illustration
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ScaleTransition(
                          scale: _breatheAnim,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary.withOpacity(0.2),
                                      AppColors.primary.withOpacity(0.05),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xFFB2C2A3).withOpacity(0.3),
                                      const Color(0xFFDCAE96).withOpacity(0.2),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.spa,
                                  size: 56,
                                  color: AppColors.primary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Kids mode toggle
                    GestureDetector(
                      onTap: () => setState(() {
                        _kidsMode = !_kidsMode;
                        if (_kidsMode) _selectedEmotion = null;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _kidsMode
                              ? const Color(0xFFFFF3E0)
                              : cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _kidsMode
                                ? const Color(0xFFFFB300)
                                : borderColor,
                            width: _kidsMode ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '🧒',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kids Mode',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _kidsMode
                                          ? const Color(0xFFE65100)
                                          : textColor,
                                    ),
                                  ),
                                  Text(
                                    'Fun devotions made for children',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _kidsMode,
                              onChanged: (v) => setState(() {
                                _kidsMode = v;
                                if (v) _selectedEmotion = null;
                              }),
                              activeColor: const Color(0xFFFFB300),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (!_kidsMode) ...[
                      // Title
                      Text(
                        'How are you feeling today?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          height: 1.2,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Take a moment to reflect on your heart and spirit.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: subColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Emotion grid
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.6,
                        children: List.generate(_emotions.length, (i) {
                          final e = _emotions[i];
                          final selected = _selectedEmotion == i;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedEmotion = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selected
                                    ? e.color.withOpacity(0.12)
                                    : cardBg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? e.color.withOpacity(0.7)
                                      : borderColor,
                                  width: selected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    e.icon,
                                    color: selected
                                        ? e.color
                                        : e.color.withOpacity(0.45),
                                    size: 26,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    e.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: selected ? textColor : subColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 28),
                    ] else ...[
                      const SizedBox(height: 8),
                      Text(
                        'Ready for a fun Bible adventure?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stories, verses, and activities made just for kids!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: subColor),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // CTA button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _proceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kidsMode
                              ? const Color(0xFFFFB300)
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: (_kidsMode
                                  ? const Color(0xFFFFB300)
                                  : AppColors.primary)
                              .withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _kidsMode
                                  ? 'Start Kids Devotion'
                                  : 'Continue to My Reflection',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'SAFE SPACE • 100% PRIVATE',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(99),
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

class _Emotion {
  final String label;
  final IconData icon;
  final Color color;
  const _Emotion(this.label, this.icon, this.color);
}
