import 'package:flutter/material.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';
import '../service/location_service.dart';
import 'dashboard_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoLight = Color(0xFFE0E7FF);

class ChurchCreationReviewScreen extends StatefulWidget {
  const ChurchCreationReviewScreen({super.key});

  @override
  State<ChurchCreationReviewScreen> createState() =>
      _ChurchCreationReviewScreenState();
}

class _ChurchCreationReviewScreenState
    extends State<ChurchCreationReviewScreen> {
  bool _allowTestimonies = true;
  bool _guidelinesAccepted = false;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_guidelinesAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Please accept the community guidelines to continue.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final draft = churchDraftNotifier.value;

    // Grab location — use already-stored value or try fetching now
    double? lat = userLatNotifier.value;
    double? lng = userLngNotifier.value;
    if (lat == null) {
      final pos = await LocationService.requestAndGetLocation();
      if (pos != null) {
        lat = pos.latitude;
        lng = pos.longitude;
        userLatNotifier.value = lat;
        userLngNotifier.value = lng;
      }
    }

    try {
      await ApiService.createChurch(
        name:              draft.name,
        denomination:      draft.denomination,
        address:           draft.address,
        city:              draft.city,
        country:           draft.country,
        phone:             draft.phone,
        email:             draft.email,
        website:           draft.website,
        youtube:           draft.youtube,
        instagram:         draft.instagram,
        allowTestimonies:  _allowTestimonies,
        lat:               lat,
        lng:               lng,
      );
      // Mark user as a pastor in local session
      isPastorNotifier.value = true;
      // Clear draft
      draft.clear();
      churchDraftNotifier.notifyListeners();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    _showSuccessSheet();
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
            28, 32, 28, MediaQuery.of(context).padding.bottom + 32),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E293B)
              : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: _indigoLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: _indigo,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Submitted for Review!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _indigo,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your church profile has been submitted.\nOur team will review it within 24–48 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _indigo,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1A1040),
                    const Color(0xFF221610),
                    const Color(0xFF1E293B),
                  ]
                : [
                    const Color(0xFFDBEAFE), // pastel blue
                    Colors.white,
                    const Color(0xFFF3E8FF), // pastel purple
                  ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Sticky header
              Container(
                color: isDark
                    ? const Color(0xFF1A1040).withOpacity(0.85)
                    : Colors.white.withOpacity(0.85),
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _indigoLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: _indigo,
                              size: 18,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Final Review',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Step 4 of 4',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _indigo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 1.0,
                        minHeight: 5,
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : _indigoLight,
                        valueColor:
                            const AlwaysStoppedAnimation(_indigo),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).padding.bottom + 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Church Identity card
                      _ReviewCard(
                        cardBg: cardBg,
                        borderColor: borderColor,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Church Identity',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                _EditChip(subColor: subColor),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Church name row
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        _indigoLight,
                                        Color(0xFFF3E8FF),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.church,
                                      color: _indigo, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        churchDraftNotifier.value.name.isNotEmpty
                                            ? churchDraftNotifier.value.name
                                            : 'Your Church',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        churchDraftNotifier.value.denomination.isNotEmpty
                                            ? churchDraftNotifier.value.denomination
                                            : 'Church',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Divider(color: borderColor, height: 1),
                            const SizedBox(height: 14),
                            // Address
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: _indigo,
                                    size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    [
                                      churchDraftNotifier.value.address,
                                      churchDraftNotifier.value.city,
                                      churchDraftNotifier.value.country,
                                    ].where((s) => s.isNotEmpty).join(', '),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: subColor,
                                        height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Service times
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: _indigo,
                                    size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Sundays 9:00 AM · 11:00 AM',
                                  style: TextStyle(
                                      fontSize: 13, color: subColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Media & Socials card
                      _ReviewCard(
                        cardBg: cardBg,
                        borderColor: borderColor,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Media & Socials',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                _EditChip(subColor: subColor),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                // Logo placeholder
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFDBEAFE),
                                        _indigoLight,
                                      ],
                                    ),
                                  ),
                                  child: const Icon(Icons.church,
                                      color: _indigo, size: 28),
                                ),
                                const SizedBox(width: 12),
                                // Cover placeholder
                                Expanded(
                                  child: Container(
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFF3E8FF),
                                          Color(0xFFFCE7F3),
                                        ],
                                      ),
                                    ),
                                    child: const Icon(Icons.image,
                                        color: Color(0xFFA78BFA),
                                        size: 28),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _SocialChip(
                                  icon: Icons.language,
                                  label: 'gracechapel.org',
                                  color: _indigo,
                                ),
                                _SocialChip(
                                  icon: Icons.play_circle_fill,
                                  label: '@gracechapeltv',
                                  color: const Color(0xFFEF4444),
                                ),
                                _SocialChip(
                                  icon: Icons.camera_alt_outlined,
                                  label: '@gracechapel',
                                  color: const Color(0xFFEC4899),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Community Guidelines card
                      _ReviewCard(
                        cardBg: cardBg,
                        borderColor: borderColor,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Allow Testimony Posts',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Members can share testimonies on the community feed',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subColor,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Switch.adaptive(
                                  value: _allowTestimonies,
                                  onChanged: (v) => setState(
                                      () => _allowTestimonies = v),
                                  activeColor: const Color(0xFF10B981),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: borderColor, height: 1),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => setState(() =>
                                  _guidelinesAccepted =
                                      !_guidelinesAccepted),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 150),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _guidelinesAccepted
                                          ? _indigo
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _guidelinesAccepted
                                            ? _indigo
                                            : borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: _guidelinesAccepted
                                        ? const Icon(Icons.check,
                                            color: Colors.white,
                                            size: 14)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: subColor,
                                        ),
                                        children: [
                                          const TextSpan(
                                              text:
                                                  'I agree to Ekklesia\'s '),
                                          TextSpan(
                                            text:
                                                'Community Guidelines',
                                            style: const TextStyle(
                                              color: _indigo,
                                              fontWeight:
                                                  FontWeight.w600,
                                              decoration: TextDecoration
                                                  .underline,
                                            ),
                                          ),
                                          const TextSpan(
                                              text:
                                                  ' and confirm this church information is accurate.'),
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
                      const SizedBox(height: 16),

                      // Admin Verification info box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _indigoLight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: _indigo.withOpacity(0.25)),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _indigoLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                color: _indigo,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Admin Verification',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _indigo,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'After submission, our team will verify your church within 24–48 hours. You\'ll be notified once your church goes live.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: isDark
                                          ? const Color(0xFF93C5FD)
                                          : const Color(0xFF4338CA),
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
                ),
              ),
            ],
          ),
        ),
      ),

      // Fixed bottom buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E293B).withOpacity(0.95)
              : Colors.white.withOpacity(0.95),
          border: Border(
            top: BorderSide(
                color: borderColor, width: 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Submit for Review
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _indigo,
                  disabledBackgroundColor: _indigo.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: _indigo.withOpacity(0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_outlined, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Submit for Review',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            // Save as Draft
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Draft saved'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor:
                          isDark ? const Color(0xFF334155) : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderColor),
                  foregroundColor: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Save as Draft',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Supporting widgets ──────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  final Widget child;
  final Color cardBg;
  final Color borderColor;

  const _ReviewCard({
    required this.child,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _EditChip extends StatelessWidget {
  final Color subColor;
  const _EditChip({required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _indigoLight,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.edit_outlined, color: _indigo, size: 12),
          SizedBox(width: 4),
          Text(
            'Edit',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _indigo,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SocialChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
