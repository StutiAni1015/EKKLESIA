import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';

class AddPrayerRequestScreen extends StatefulWidget {
  const AddPrayerRequestScreen({super.key});

  @override
  State<AddPrayerRequestScreen> createState() =>
      _AddPrayerRequestScreenState();
}

class _AddPrayerRequestScreenState extends State<AddPrayerRequestScreen> {
  final _bodyCtrl = TextEditingController();
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _bodyCtrl.text.trim();
    if (text.isEmpty) return;

    // ── Word filter ───────────────────────────────────────────────
    final banned = firstBannedWord(text);
    if (banned != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Your post contains inappropriate language and cannot be submitted. Please revise your message.',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      // Add to personal prayer list
      final prayer = UserPrayer(
        body: text,
        isAnonymous: _isAnonymous,
        addedAt: DateTime.now(),
      );
      myPrayerRequestsNotifier.value = [
        ...myPrayerRequestsNotifier.value,
        prayer,
      ];

      // Also submit to church feed for pastor approval (if a church exists)
      if (myChurchNotifier.value != null) {
        final name = _isAnonymous ? 'Anonymous' : (userNameNotifier.value.trim().isEmpty ? 'Member' : userNameNotifier.value.trim());
        final initials = _isAnonymous ? 'AN' : name.split(' ').where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();
        final post = ChurchPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: name,
          authorInitials: initials,
          authorColor: const Color(0xFFB9D1EA),
          content: text,
          postedAt: DateTime.now(),
          status: PostStatus.pending,
        );
        churchPostsNotifier.value = [...churchPostsNotifier.value, post];
      }

      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            myChurchNotifier.value != null
                ? 'Your post is pending pastor approval.'
                : 'Prayer request posted to the community.',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.maybePop(context, prayer);
    });
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
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Prayer Request',
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

            // Body
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        20, 28, 20, MediaQuery.of(context).padding.bottom + 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero title
                        Text(
                          'How can we pray\nfor you?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your brothers and sisters will lift you up in prayer.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: subColor,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Large textarea
                        TextField(
                          controller: _bodyCtrl,
                          maxLines: null,
                          minLines: 8,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Share what is on your heart...',
                            hintStyle: TextStyle(
                                color: subColor, fontSize: 15),
                            filled: true,
                            fillColor: cardBg,
                            contentPadding: const EdgeInsets.all(16),
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
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Anonymous toggle
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.visibility_off_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Post Anonymously',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Your name will not be shown to others.',
                                      style: TextStyle(
                                          fontSize: 12, color: subColor),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isAnonymous,
                                onChanged: (v) =>
                                    setState(() => _isAnonymous = v),
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Guidance info box
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.favorite_outline,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your request will be visible to the community. Members can pray and leave encouraging words for you.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.6,
                                    color: isDark
                                        ? AppColors.primary
                                            .withOpacity(0.85)
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gradient fade + action buttons pinned at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            bg.withOpacity(0),
                            bg.withOpacity(0.85),
                            bg,
                          ],
                          stops: const [0.0, 0.3, 1.0],
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
                          20,
                          24,
                          20,
                          MediaQuery.of(context).padding.bottom + 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Post button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _submit,
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.send, size: 18),
                              label: Text(
                                _isSubmitting
                                    ? 'Posting...'
                                    : 'Post Prayer Request',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.5),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor:
                                    AppColors.primary.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Cancel link
                          GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
