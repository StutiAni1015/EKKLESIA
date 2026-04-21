import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';
import '../widgets/app_bottom_bar.dart';
import 'create_church_screen.dart';
import 'pastor_management_screen.dart';
import 'welcome_screen.dart';
import 'my_giving_dashboard_screen.dart';
import 'treasury_lock_screen.dart';
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
  void initState() {
    super.initState();
    // Refresh profile data every time this screen is opened so that isPastor,
    // name, bio and church info are always up-to-date.
    ApiService.fetchAndApplyProfile().catchError((_) {});
  }

  // ── Edit profile sheet ────────────────────────────────────────────────────
  void _openEditSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController(text: userNameNotifier.value);
    final bioCtrl  = TextEditingController(text: userBioNotifier.value);
    bool isSaving  = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final sheetBg    = isDark ? const Color(0xFF1E293B) : Colors.white;
          final textColor  = isDark ? Colors.white : const Color(0xFF1E293B);
          final subColor   = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
          final inputFill  = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

          InputDecoration _dec(String hint, IconData icon) => InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: subColor, fontSize: 14),
            prefixIcon: Icon(icon, color: subColor, size: 20),
            filled: true,
            fillColor: inputFill,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          );

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),

                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  Text('Display Name',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subColor)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: _dec('Your name', Icons.person_outline),
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  Text('Bio',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subColor)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: bioCtrl,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: _dec(
                        'A short bio about yourself…', Icons.info_outline),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              final name = nameCtrl.text.trim();
                              final bio  = bioCtrl.text.trim();
                              if (name.isEmpty) return;

                              setSheet(() => isSaving = true);
                              try {
                                await ApiService.updateProfile(
                                    name: name, bio: bio);
                                // Update local notifiers immediately
                                userNameNotifier.value =
                                    name.split(' ').first;
                                userBioNotifier.value = bio;
                                if (ctx.mounted) Navigator.pop(ctx);
                              } catch (e) {
                                if (ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text('$e'),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              } finally {
                                setSheet(() => isSaving = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Change Password ───────────────────────────────────────────────────────────
  void _openChangePasswordSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCtrl  = TextEditingController();
    final newCtrl      = TextEditingController();
    final confirmCtrl  = TextEditingController();
    bool obscureCurrent = true, obscureNew = true, obscureConfirm = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final sheetBg   = isDark ? const Color(0xFF1E293B) : Colors.white;
          final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
          final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
          final inputFill = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
          bool saving = false;

          InputDecoration dec(String hint, bool obscure, VoidCallback toggle) => InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: subColor, fontSize: 14),
            filled: true,
            fillColor: inputFill,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: subColor, size: 18),
              onPressed: toggle,
            ),
          );

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Change Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 4),
                  Text('Enter your current password and choose a new one.', style: TextStyle(fontSize: 13, color: subColor)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: currentCtrl,
                    obscureText: obscureCurrent,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('Current password', obscureCurrent, () => setSheet(() => obscureCurrent = !obscureCurrent)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newCtrl,
                    obscureText: obscureNew,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('New password (min 6 chars)', obscureNew, () => setSheet(() => obscureNew = !obscureNew)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: obscureConfirm,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('Confirm new password', obscureConfirm, () => setSheet(() => obscureConfirm = !obscureConfirm)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: StatefulBuilder(
                      builder: (_, setSave) => ElevatedButton(
                        onPressed: saving ? null : () async {
                          final cur  = currentCtrl.text.trim();
                          final nw   = newCtrl.text.trim();
                          final conf = confirmCtrl.text.trim();
                          if (cur.isEmpty || nw.isEmpty || conf.isEmpty) return;
                          if (nw != conf) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Passwords do not match'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
                            return;
                          }
                          if (nw.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Password must be at least 6 characters'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
                            return;
                          }
                          setSave(() => saving = true);
                          try {
                            await ApiService.changePassword(currentPassword: cur, newPassword: nw);
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Password changed successfully'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating));
                          } catch (e) {
                            setSave(() => saving = false);
                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$e'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: saving
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Update Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Privacy Settings ──────────────────────────────────────────────────────────
  void _openPrivacySheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Map<String, bool> settings = {
      'showInDirectory': true,
      'allowPrayerTags': true,
      'publicProfile': true,
      'showChurchMembership': true,
    };
    bool loading = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final sheetBg     = isDark ? const Color(0xFF1E293B) : Colors.white;
          final textColor   = isDark ? Colors.white : const Color(0xFF1E293B);
          final subColor    = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

          // Load on first build
          if (loading) {
            Future.microtask(() async {
              try {
                final data = await ApiService.getPrivacySettings();
                setSheet(() {
                  settings = {
                    'showInDirectory':    (data['showInDirectory'] as bool?) ?? true,
                    'allowPrayerTags':    (data['allowPrayerTags'] as bool?) ?? true,
                    'publicProfile':      (data['publicProfile'] as bool?) ?? true,
                    'showChurchMembership': (data['showChurchMembership'] as bool?) ?? true,
                  };
                  loading = false;
                });
              } catch (_) {
                setSheet(() => loading = false);
              }
            });
          }

          void toggle(String key) async {
            final newVal = !(settings[key] ?? true);
            setSheet(() => settings[key] = newVal);
            try {
              await ApiService.updatePrivacySettings({key: newVal});
            } catch (e) {
              setSheet(() => settings[key] = !newVal); // revert
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$e'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
            }
          }

          final options = [
            _PrivacyOption('showInDirectory',    'Show in Member Directory',  'Let church members find you in the directory.'),
            _PrivacyOption('allowPrayerTags',    'Allow Prayer Tags',         'Others can tag you in prayer requests.'),
            _PrivacyOption('publicProfile',      'Public Profile',            'Anyone can view your profile and bio.'),
            _PrivacyOption('showChurchMembership','Show Church Membership',   'Display your church on your public profile.'),
          ];

          return Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).padding.bottom + 24),
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)))),
                const SizedBox(height: 16),
                Text('Privacy Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 4),
                Text('Control what others can see about you.', style: TextStyle(fontSize: 13, color: subColor)),
                const SizedBox(height: 20),
                if (loading)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: AppColors.primary)))
                else
                  ...options.map((opt) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: SwitchListTile.adaptive(
                      value: settings[opt.key] ?? true,
                      onChanged: (_) => toggle(opt.key),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: Text(opt.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: Text(opt.subtitle, style: TextStyle(fontSize: 12, color: subColor, height: 1.4)),
                    ),
                  )),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Help & Support ────────────────────────────────────────────────────────────
  void _openHelpSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final sheetBg   = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
        final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
        final tileBg    = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

        final faqs = [
          _FAQ('How do I join a church?', 'Go to "Find a Church" from the dashboard or quick actions. Search by name or location, then submit a join request.'),
          _FAQ('How do I submit a prayer request?', 'Tap the + (center FAB) when on the Community tab, or visit Prayer Community from the dashboard.'),
          _FAQ('Why can\'t I access the Treasury?', 'Treasury access is restricted to pastors and designated committee members. Contact your church pastor.'),
          _FAQ('How do I change my church role?', 'Only a pastor can assign roles. Ask your pastor to update your role in church management.'),
          _FAQ('My account isn\'t syncing — what do I do?', 'Try logging out and logging back in. If the issue persists, contact support below.'),
          _FAQ('How do I delete my account?', 'Send an email to support@ekklesia.app with your registered email address and we\'ll process it within 48 hours.'),
        ];

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.92,
          builder: (_, ctrl) => Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Column(
                    children: [
                      Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)))),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.help_outline, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                              Text('Frequently asked questions', style: TextStyle(fontSize: 12, color: subColor)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: ctrl,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    children: [
                      ...faqs.map((faq) => _FaqTile(faq: faq, isDark: isDark, textColor: textColor, subColor: subColor, tileBg: tileBg)),
                      const SizedBox(height: 16),
                      // Contact card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.mail_outline, color: AppColors.primary, size: 28),
                            const SizedBox(height: 8),
                            Text('Still need help?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
                            const SizedBox(height: 4),
                            Text('Email us and we\'ll get back to you\nwithin 24 hours.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: subColor, height: 1.5)),
                            const SizedBox(height: 12),
                            Text('support@ekklesia.app', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.primary),
                      onPressed: _openEditSheet,
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
                            valueListenable: userBioNotifier,
                            builder: (_, bio, __) => bio.trim().isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      bio,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: subColor,
                                          height: 1.4),
                                    ),
                                  ),
                          ),
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
                          ValueListenableBuilder<bool>(
                            valueListenable: isPastorNotifier,
                            builder: (_, isPastor, __) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isPastor
                                        ? const Color(0xFFF59E0B)
                                        : AppColors.primary)
                                    .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isPastor ? 'Pastor' : 'Church Member',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isPastor
                                      ? const Color(0xFFD97706)
                                      : AppColors.primary,
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
                                onManageFeed: () {
                                  final churchId = myChurchIdNotifier.value;
                                  if (churchId == null) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PastorManagementScreen(
                                        churchId: churchId,
                                        churchName: church.name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),

              // ── My Finances section ───────────────────────────────────────
              _SectionHeader(label: 'My Finances', subColor: subColor),
              _SettingsGroup(
                isDark: isDark,
                cardBg: cardBg,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                children: [
                  _SettingsTile(
                    icon: Icons.volunteer_activism_rounded,
                    label: 'My Givings',
                    labelColor: const Color(0xFF10B981),
                    trailing: Icon(Icons.chevron_right, color: subColor, size: 18),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MyGivingDashboardScreen()),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.account_balance_outlined,
                    label: 'Church Treasury',
                    labelColor: const Color(0xFFF59E0B),
                    trailing: Icon(Icons.chevron_right, color: subColor, size: 18),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TreasuryLockScreen()),
                    ),
                  ),
                ],
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
                    onTap: _openChangePasswordSheet,
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Settings',
                    onTap: _openPrivacySheet,
                  ),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: _openHelpSheet,
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

// ── Privacy option model ──────────────────────────────────────────────────────
class _PrivacyOption {
  final String key;
  final String label;
  final String subtitle;
  const _PrivacyOption(this.key, this.label, this.subtitle);
}

// ── FAQ model + tile ──────────────────────────────────────────────────────────
class _FAQ {
  final String question;
  final String answer;
  const _FAQ(this.question, this.answer);
}

class _FaqTile extends StatefulWidget {
  final _FAQ faq;
  final bool isDark;
  final Color textColor, subColor, tileBg;
  const _FaqTile({required this.faq, required this.isDark, required this.textColor, required this.subColor, required this.tileBg});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.tileBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _expanded ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: widget.textColor),
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.primary, size: 20),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(
                  widget.faq.answer,
                  style: TextStyle(fontSize: 13, color: widget.subColor, height: 1.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
