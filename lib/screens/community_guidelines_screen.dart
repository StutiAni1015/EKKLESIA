import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  static const _guidelines = [
    _Guideline(
      icon: Icons.favorite,
      title: 'Kindness First',
      body:
          'Practice grace and compassion in every interaction. We are called to love one another as Christ loved us.',
    ),
    _Guideline(
      icon: Icons.diversity_3,
      title: 'Respect Differences',
      body:
          'Our community represents many denominational backgrounds. Celebrate our shared faith while respecting diverse traditions.',
    ),
    _Guideline(
      icon: Icons.handshake,
      title: 'Promote Unity',
      body:
          'Avoid divisive speech, gossip, or heated theological debates that cause strife. Focus on what unites us in the Spirit.',
    ),
    _Guideline(
      icon: Icons.forum,
      title: 'Healthy Dialogue',
      body:
          'When disagreements arise, resolve them privately and biblically. Keep public forums uplifting and encouraging.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? AppColors.primary.withOpacity(0.05) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sticky header with bottom border
            Container(
              decoration: BoxDecoration(
                color: bg.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.primary),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Community Guidelines',
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
                    16, 16, 16, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero image placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // Gradient background standing in for the image
                          Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF4A6741),
                                  Color(0xFF8BA888),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.people,
                                size: 72,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                          // Bottom gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 80,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xCC221610),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Badge
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'OUR COVENANT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title + description
                    Text(
                      'Our Shared Values',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'To maintain a respectful and Christ-centered environment, we ask all members to follow these core principles for online and in-person interactions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Guideline cards
                    ..._guidelines.map(
                      (g) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GuidelineCard(
                          guideline: g,
                          cardBg: cardBg,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Commitment box
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 2,
                          // dashed effect via a custom painter below
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Our Commitment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"By this everyone will know that you are my disciples, if you love one another." — John 13:35',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF334155),
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

class _GuidelineCard extends StatelessWidget {
  final _Guideline guideline;
  final Color cardBg;
  final Color textColor;
  final Color subColor;

  const _GuidelineCard({
    required this.guideline,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(guideline.icon,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guideline.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guideline.body,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Guideline {
  final IconData icon;
  final String title;
  final String body;
  const _Guideline(
      {required this.icon, required this.title, required this.body});
}
