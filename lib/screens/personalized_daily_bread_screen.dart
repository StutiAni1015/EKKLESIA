import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../data/daily_bread_content.dart';

class PersonalizedDailyBreadScreen extends StatefulWidget {
  final int emotionIndex;
  const PersonalizedDailyBreadScreen({super.key, required this.emotionIndex});

  @override
  State<PersonalizedDailyBreadScreen> createState() =>
      _PersonalizedDailyBreadScreenState();
}

class _PersonalizedDailyBreadScreenState
    extends State<PersonalizedDailyBreadScreen> {
  final _reflectionCtrl = TextEditingController();
  bool _saved = false;
  bool _verseExpanded = false;

  late final BreadContent _content;

  @override
  void initState() {
    super.initState();
    // Seed = userName hash + day-of-year so each person gets a unique reflection
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final userHash = userNameNotifier.value.hashCode.abs();
    final seed = (userHash + dayOfYear) % 1000;
    _content = getDailyBread(widget.emotionIndex, seed);
  }

  @override
  void dispose() {
    _reflectionCtrl.dispose();
    super.dispose();
  }

  void _saveReflection() {
    if (_reflectionCtrl.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reflection saved.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
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

    final emotionLabel = emotionLabels[widget.emotionIndex];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: bg.withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Daily Bread',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  // Emotion badge
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _content.gradientColors.first.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      emotionLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _content.gradientColors.first,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero banner
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _content.gradientColors,
                            ),
                          ),
                        ),
                        // Decorative circles
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -10,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Bottom fade
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0x99000000)],
                              stops: [0.3, 1.0],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        _content.tag,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _content
                                              .gradientColors.first,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _content.heroTitle,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ── Verse of the Day ──────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.auto_awesome,
                                  color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Verse of the Day',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Verse card with soothing background
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                // Soothing gradient background
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        _content.gradientColors.first
                                            .withOpacity(0.18),
                                        _content.gradientColors.last
                                            .withOpacity(0.08),
                                      ],
                                    ),
                                  ),
                                ),
                                // Decorative orb top-right
                                Positioned(
                                  top: -16,
                                  right: -16,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _content.gradientColors.first
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                // Decorative orb bottom-left
                                Positioned(
                                  bottom: -20,
                                  left: -10,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _content.gradientColors.last
                                          .withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                // Subtle wave lines
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _WavePainter(
                                      color: _content.gradientColors.first
                                          .withOpacity(0.06),
                                    ),
                                  ),
                                ),
                                // Content
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.format_quote,
                                        color: _content.gradientColors.first
                                            .withOpacity(0.5),
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _content.verseText,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          height: 1.7,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF1E293B),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              color: _content
                                                  .gradientColors.first
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _content.verseRef,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: _content
                                                  .gradientColors.first,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Today's Reading ───────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.menu_book,
                                  color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Today\'s Reading',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _content.readingRef,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: _content.gradientColors.first,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _verseExpanded
                                      ? _content.readingText
                                      : _content.readingText.length > 280
                                          ? '${_content.readingText.substring(0, 280)}…'
                                          : _content.readingText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.7,
                                    color: textColor.withOpacity(0.85),
                                  ),
                                ),
                                if (_content.readingText.length > 280)
                                  GestureDetector(
                                    onTap: () => setState(
                                        () => _verseExpanded = !_verseExpanded),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        _verseExpanded
                                            ? 'Show less'
                                            : 'Read more',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _content.gradientColors.first,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Reflection ────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.edit_note,
                                  color: AppColors.primary, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Reflection',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _content.reflectionQuestion,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _reflectionCtrl,
                                  maxLines: 5,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write your thoughts here...',
                                    hintStyle:
                                        TextStyle(color: subColor),
                                    filled: true,
                                    fillColor: isDark
                                        ? AppColors.backgroundDark
                                        : AppColors.backgroundLight,
                                    contentPadding:
                                        const EdgeInsets.all(14),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: borderColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: borderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.5),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: _saveReflection,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _saved
                                          ? Colors.green
                                          : AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 10),
                                    ),
                                    child: Text(
                                      _saved ? 'Saved!' : 'Save Reflection',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Center(
                        child: Text(
                          _content.footerVerse,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: subColor,
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
    );
  }
}

/// Subtle wave/arc lines for soothing verse background
class _WavePainter extends CustomPainter {
  final Color color;
  const _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final yOffset = size.height * (0.25 + i * 0.18);
      path.moveTo(0, yOffset);
      path.quadraticBezierTo(
        size.width * 0.3,
        yOffset - 14,
        size.width * 0.6,
        yOffset + 8,
      );
      path.quadraticBezierTo(
        size.width * 0.8,
        yOffset + 18,
        size.width,
        yOffset,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.color != color;
}
