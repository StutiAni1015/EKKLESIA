import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'signup_spiritual_profile_screen.dart';

class SignupCommunityPreferencesScreen extends StatefulWidget {
  const SignupCommunityPreferencesScreen({super.key});

  @override
  State<SignupCommunityPreferencesScreen> createState() =>
      _SignupCommunityPreferencesScreenState();
}

class _SignupCommunityPreferencesScreenState
    extends State<SignupCommunityPreferencesScreen> {
  // Interested In
  final Set<String> _interests = {'Bible Study Groups', 'Community Outreach'};

  static const _interestOptions = [
    'Bible Study Groups',
    'Youth & Family Ministry',
    'Community Outreach',
    'Choir & Worship Music',
  ];

  // Notifications
  bool _eventReminders = true;
  bool _communityChat = false;

  // Privacy
  String _privacy = 'friends';

  static const _privacyOptions = [
    _PrivacyOption(
      value: 'public',
      icon: Icons.public,
      title: 'Public',
      subtitle: 'Visible to everyone in the community',
    ),
    _PrivacyOption(
      value: 'friends',
      icon: Icons.group,
      title: 'Friends Only',
      subtitle: 'Only your connected friends see details',
    ),
    _PrivacyOption(
      value: 'private',
      icon: Icons.visibility_off,
      title: 'Private',
      subtitle: 'Only you can see your activity',
    ),
  ];

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignupSpiritualProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final dividerColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final borderColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: bg.withOpacity(0.8),
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Setup Profile',
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

            // Step dots (step 3 active)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  const SizedBox(width: 12),
                  _dot(false),
                  const SizedBox(width: 12),
                  _dot(true),
                  const SizedBox(width: 12),
                  _dot(false),
                  const SizedBox(width: 12),
                  _dot(false),
                ],
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Community Preferences',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Step 3 of 5: Personalize your experience',
                            style: TextStyle(fontSize: 13, color: subColor),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Interested In ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Icon(Icons.volunteer_activism,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Interested In',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    ..._interestOptions.map((item) => InkWell(
                          onTap: () => setState(() {
                            if (_interests.contains(item)) {
                              _interests.remove(item);
                            } else {
                              _interests.add(item);
                            }
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _interests.contains(item),
                                    onChanged: (_) => setState(() {
                                      if (_interests.contains(item)) {
                                        _interests.remove(item);
                                      } else {
                                        _interests.add(item);
                                      }
                                    }),
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                      color: isDark
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? const Color(0xFFE2E8F0)
                                        : const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                    Divider(
                        height: 48,
                        indent: 24,
                        endIndent: 24,
                        color: dividerColor),

                    // ── Notifications ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _NotifToggle(
                            title: 'Event Reminders',
                            subtitle: 'Get alerts for upcoming services',
                            value: _eventReminders,
                            textColor: textColor,
                            subColor: subColor,
                            onChanged: (v) =>
                                setState(() => _eventReminders = v),
                          ),
                          const SizedBox(height: 16),
                          _NotifToggle(
                            title: 'Community Chat',
                            subtitle: 'New message notifications',
                            value: _communityChat,
                            textColor: textColor,
                            subColor: subColor,
                            onChanged: (v) =>
                                setState(() => _communityChat = v),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                        height: 48,
                        indent: 24,
                        endIndent: 24,
                        color: dividerColor),

                    // ── Privacy Settings ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Icon(Icons.lock,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Privacy Settings',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: _privacyOptions
                            .map((opt) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _PrivacyCard(
                                    option: opt,
                                    selected: _privacy == opt.value,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    subColor: subColor,
                                    isDark: isDark,
                                    onTap: () =>
                                        setState(() => _privacy = opt.value),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed footer
            Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                    top: BorderSide(color: dividerColor, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _onContinue,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: subColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _dot(bool active) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: active ? 32 : 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: active
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.2),
        ),
      );
}

// Notification toggle row
class _NotifToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Color textColor;
  final Color subColor;
  final ValueChanged<bool> onChanged;

  const _NotifToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.textColor,
    required this.subColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: subColor)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

// Privacy option card
class _PrivacyCard extends StatelessWidget {
  final _PrivacyOption option;
  final bool selected;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final bool isDark;
  final VoidCallback onTap;

  const _PrivacyCard({
    required this.option,
    required this.selected,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.05) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              option.icon,
              color: selected ? AppColors.primary : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
                    style: TextStyle(fontSize: 12, color: subColor),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: selected ? 1.0 : 0.0,
              child: const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyOption {
  final String value;
  final IconData icon;
  final String title;
  final String subtitle;

  const _PrivacyOption({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
