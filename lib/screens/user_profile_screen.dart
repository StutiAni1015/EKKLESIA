import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';
import '../widgets/app_bottom_bar.dart';
import 'create_church_screen.dart';
import 'pastor_church_feed_screen.dart';
import 'welcome_screen.dart';
import '../widgets/tap_scale.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _notificationsOn = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _darkMode = isDark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: AppBottomBar(activeIndex: kTabProfile),
      floatingActionButton: buildCenterFab(context, activeIndex: kTabProfile),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: AppColors.primary),
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('Edit profile coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      )),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: borderColor),

              // Avatar + name hero
              Container(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                child: Row(
                  children: [
                    // Avatar
                    ValueListenableBuilder<String?>(
                      valueListenable: userProfileEmojiNotifier,
                      builder: (_, emoji, __) => ValueListenableBuilder<String>(
                        valueListenable: userNameNotifier,
                        builder: (_, name, __) {
                          final initials = name.trim().isEmpty
                              ? 'U'
                              : name.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').take(2).join();
                          return GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo upload coming soon!'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            ),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 38,
                                  backgroundColor: AppColors.primary.withOpacity(0.12),
                                  child: emoji != null
                                      ? Text(emoji, style: const TextStyle(fontSize: 34))
                                      : Text(
                                          initials,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: isDark
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          width: 2),
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: userNameNotifier,
                            builder: (_, name, __) => Text(
                              name.trim().isEmpty ? 'Member' : name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          ValueListenableBuilder<String>(
                            valueListenable: userCountryNotifier,
                            builder: (_, country, __) => Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: subColor, size: 13),
                                const SizedBox(width: 3),
                                Text(
                                  country,
                                  style:
                                      TextStyle(fontSize: 12, color: subColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Church Member',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _StatCard(
                      label: 'Days Read',
                      value: ValueListenableBuilder<BiblePlan?>(
                        valueListenable: selectedPlanNotifier,
                        builder: (_, plan, __) =>
                            Text('${plan?.daysCompleted ?? 0}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: textColor)),
                      ),
                      icon: Icons.calendar_today,
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'Prayers',
                      value: ValueListenableBuilder<List<UserPrayer>>(
                        valueListenable: myPrayerRequestsNotifier,
                        builder: (_, prayers, __) =>
                            Text('${prayers.length}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: textColor)),
                      ),
                      icon: Icons.volunteer_activism,
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'Sermons',
                      value: ValueListenableBuilder<List<SavedSermon>>(
                        valueListenable: savedSermonsNotifier,
                        builder: (_, sermons, __) =>
                            Text('${sermons.length}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: textColor)),
                      ),
                      icon: Icons.headset,
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Active Plan preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ValueListenableBuilder<BiblePlan?>(
                  valueListenable: selectedPlanNotifier,
                  builder: (_, plan, __) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: plan == null
                        ? Row(
                            children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.menu_book_outlined,
                                    color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('No Active Plan',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textColor)),
                                    const SizedBox(height: 2),
                                    Text('Browse plans to start your journey',
                                        style: TextStyle(
                                            fontSize: 12, color: subColor)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.menu_book,
                                    color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Active Plan',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: subColor)),
                                    const SizedBox(height: 2),
                                    Text(
                                      plan.title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(99),
                                      child: LinearProgressIndicator(
                                        value: plan.progress,
                                        minHeight: 4,
                                        backgroundColor: isDark
                                            ? const Color(0xFF334155)
                                            : const Color(0xFFE2E8F0),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(plan.dayLabel,
                                        style: TextStyle(
                                            fontSize: 10, color: subColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Verification status section ───────────────────────────
              _SectionHeader(label: 'Verification Status', subColor: subColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      _VerificationRow(
                        icon: Icons.phone_android,
                        label: 'Phone Number',
                        notifier: phoneVerifiedNotifier,
                        subColor: subColor,
                        textColor: textColor,
                      ),
                      Divider(height: 20, color: borderColor),
                      _VerificationRow(
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        notifier: emailVerifiedNotifier,
                        subColor: subColor,
                        textColor: textColor,
                      ),
                      Divider(height: 20, color: borderColor),
                      _VerificationRow(
                        icon: Icons.face_retouching_natural,
                        label: 'Face ID',
                        notifier: faceVerifiedNotifier,
                        subColor: subColor,
                        textColor: textColor,
                      ),
                      Divider(height: 20, color: borderColor),
                      _VerificationRow(
                        icon: Icons.lock_outline,
                        label: 'Account Password',
                        notifier: accountVerifiedNotifier,
                        subColor: subColor,
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Pastor Church section ─────────────────────────────────────
              ValueListenableBuilder<ChurchProfile?>(
                valueListenable: myChurchNotifier,
                builder: (_, church, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(label: 'My Church', subColor: subColor),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: church == null
                            ? _CreateChurchBanner(
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textColor: textColor,
                                subColor: subColor,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CreateChurchScreen()),
                                ),
                              )
                            : _MyChurchCard(
                                church: church,
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textColor: textColor,
                                subColor: subColor,
                                onManageFeed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PastorChurchFeedScreen()),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),

              // Settings section
              _SectionHeader(label: 'Settings', subColor: subColor),
              _SettingsGroup(
                isDark: isDark,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    trailing: Switch.adaptive(
                      value: _notificationsOn,
                      onChanged: (v) => setState(() => _notificationsOn = v),
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.language,
                    label: 'Language',
                    trailing: Text('English',
                        style: TextStyle(fontSize: 13, color: subColor)),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language settings coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.currency_exchange,
                    label: 'Currency',
                    trailing: ValueListenableBuilder<String>(
                      valueListenable: userCurrencyNotifier,
                      builder: (_, currency, __) => Text(currency,
                          style: TextStyle(fontSize: 13, color: subColor)),
                    ),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Currency settings coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                ],
              ),

              _SectionHeader(label: 'Account', subColor: subColor),
              _SettingsGroup(
                isDark: isDark,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                children: [
                  _SettingsTile(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password change coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Settings',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy settings coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Support coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.logout,
                    label: 'Log Out',
                    labelColor: const Color(0xFFEF4444),
                    onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Log Out?'),
                        content: const Text(
                            'Are you sure you want to log out of Ekklesia?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(ctx).pop();
                              // Erase saved "remember me" session, clear memory.
                              await ApiService.clearSavedSession();
                              ApiService.clearSession();
                              resetAllAppState();
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const WelcomeScreen(
                                      languageCode: 'en',
                                      languageNativeName: 'English',
                                    ),
                                  ),
                                  (_) => false,
                                );
                              }
                            },
                            child: const Text('Log Out',
                                style:
                                    TextStyle(color: Color(0xFFEF4444))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Ekklesia v1.0.0',
                  style: TextStyle(fontSize: 11, color: subColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final Widget value;
  final IconData icon;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(height: 6),
            value,
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final ValueNotifier<bool> notifier;
  final Color subColor;
  final Color textColor;

  const _VerificationRow({
    required this.icon,
    required this.label,
    required this.notifier,
    required this.subColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, verified, __) => Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: verified
                  ? const Color(0xFF10B981).withOpacity(0.12)
                  : const Color(0xFF94A3B8).withOpacity(0.12),
            ),
            child: Icon(
              icon,
              size: 18,
              color: verified
                  ? const Color(0xFF10B981)
                  : subColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  verified ? 'Verified' : 'Not yet verified',
                  style: TextStyle(
                    fontSize: 11,
                    color: verified
                        ? const Color(0xFF10B981)
                        : subColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: verified
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : const Color(0xFFEF4444).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  verified ? Icons.check_circle : Icons.cancel_outlined,
                  size: 12,
                  color: verified
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  verified ? 'Verified' : 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: verified
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
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

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color subColor;
  const _SectionHeader({required this.label, required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: subColor,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final List<_SettingsTile> children;

  const _SettingsGroup({
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              _SettingsTileWrapper(
                tile: children[i],
                textColor: textColor,
                subColor: subColor,
              ),
              if (i < children.length - 1)
                Divider(height: 1, indent: 52, color: borderColor),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsTile {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.labelColor,
    this.trailing,
    this.onTap,
  });
}

class _SettingsTileWrapper extends StatelessWidget {
  final _SettingsTile tile;
  final Color textColor;
  final Color subColor;

  const _SettingsTileWrapper({
    required this.tile,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tile.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(tile.icon,
                size: 20,
                color: tile.labelColor ?? AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                tile.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: tile.labelColor ?? textColor,
                ),
              ),
            ),
            if (tile.trailing != null)
              tile.trailing!
            else if (tile.onTap != null)
              Icon(Icons.arrow_forward_ios,
                  size: 13, color: subColor),
          ],
        ),
      ),
    );
  }
}

// ── Create Church banner (shown when no church exists) ────────────────────────

class _CreateChurchBanner extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final VoidCallback onTap;

  const _CreateChurchBanner({
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_business,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Church',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Register as pastor and manage your congregation\'s feed.',
                    style: TextStyle(fontSize: 12, color: subColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ── My Church card (shown after church is created) ────────────────────────────

class _MyChurchCard extends StatelessWidget {
  final ChurchProfile church;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final VoidCallback onManageFeed;

  const _MyChurchCard({
    required this.church,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.onManageFeed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          // Church info header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.7),
                        AppColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.church,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              church.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              'PASTOR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 11, color: subColor),
                          const SizedBox(width: 3),
                          Text(
                            church.location,
                            style:
                                TextStyle(fontSize: 12, color: subColor),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.church_outlined,
                              size: 11, color: subColor),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              church.denomination,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, color: subColor),
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

          Divider(height: 1, color: borderColor),

          // Action: Manage Feed
          InkWell(
            onTap: onManageFeed,
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune,
                        color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Church Feed',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        ValueListenableBuilder<List<ChurchPost>>(
                          valueListenable: churchPostsNotifier,
                          builder: (_, posts, __) {
                            final pending = posts
                                .where((p) =>
                                    p.status == PostStatus.pending)
                                .length;
                            return Text(
                              pending > 0
                                  ? '$pending post${pending == 1 ? '' : 's'} awaiting approval'
                                  : 'Approve, reject, or delete posts',
                              style: TextStyle(
                                  fontSize: 11, color: pending > 0 ? AppColors.primary : subColor),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 13, color: subColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
