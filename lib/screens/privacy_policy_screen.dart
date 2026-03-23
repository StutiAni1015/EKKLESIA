import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    _PolicySection(
      icon: Icons.person_search,
      title: 'Information We Collect',
      intro: 'To help you connect deeply with our community, we collect:',
      bullets: [
        _Bullet(
          title: 'Identity & Faith',
          body:
              'Your name and faith background to personalize your spiritual journey.',
        ),
        _Bullet(
          title: 'Location',
          body:
              'To help you find local small groups and community events near you.',
        ),
        _Bullet(
          title: 'Contact Details',
          body:
              'Your email or phone number for important community updates.',
        ),
      ],
    ),
    _PolicySection(
      icon: Icons.security,
      title: 'Secure Stewardship',
      body:
          'Your data is stored using industry-standard encryption. We treat your digital presence with the same reverence as your physical presence in our sanctuary. We never sell your data to third parties.',
    ),
    _PolicySection(
      icon: Icons.groups,
      title: 'Enhancing Fellowship',
      body:
          'We use your data strictly to enhance the community experience—tailoring event recommendations, facilitating small group connections, and ensuring you receive the support you need when you need it.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg =
        isDark ? const Color(0xFF1E293B).withOpacity(0.4) : Colors.white;

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
                  bottom: BorderSide(
                      color: AppColors.primary.withOpacity(0.1)),
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
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.verified_user,
                        color: AppColors.primary, size: 22),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 24, 16, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero heading
                    const Text(
                      'Our Commitment\nto You',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'At our church community, your trust is sacred. We are committed to being transparent about how we handle your information as we grow together in faith. This policy outlines how we steward the data you share with us.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Policy sections
                    ..._sections.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _SectionCard(
                            section: s,
                            cardBg: cardBg,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        )),

                    const SizedBox(height: 8),

                    // Last updated + button
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Last Updated: October 24, 2023',
                            style: TextStyle(
                                fontSize: 11, color: subColor),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.maybePop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor:
                                    AppColors.primary.withOpacity(0.25),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32),
                              ),
                              child: const Text(
                                'I Understand',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
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

class _SectionCard extends StatelessWidget {
  final _PolicySection section;
  final Color cardBg;
  final Color textColor;
  final Color subColor;

  const _SectionCard({
    required this.section,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.primary.withOpacity(0.05)),
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
          // Section header
          Row(
            children: [
              Icon(section.icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                section.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Intro text
          if (section.intro != null) ...[
            Text(
              section.intro!,
              style: TextStyle(fontSize: 14, color: subColor),
            ),
            const SizedBox(height: 12),
          ],

          // Bullet list
          if (section.bullets != null)
            ...section.bullets!.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.check_circle,
                            color: AppColors.primary, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              b.body,
                              style: TextStyle(
                                fontSize: 13,
                                color: subColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

          // Body paragraph
          if (section.body != null)
            Text(
              section.body!,
              style: TextStyle(
                  fontSize: 14, height: 1.6, color: subColor),
            ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final IconData icon;
  final String title;
  final String? intro;
  final List<_Bullet>? bullets;
  final String? body;

  const _PolicySection({
    required this.icon,
    required this.title,
    this.intro,
    this.bullets,
    this.body,
  });
}

class _Bullet {
  final String title;
  final String body;
  const _Bullet({required this.title, required this.body});
}
