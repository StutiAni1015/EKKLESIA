import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/location_service.dart';

// ── Category data ─────────────────────────────────────────────────────────────
enum _PrayerCategory { health, family, guidance, provision }

extension _PrayerCategoryExt on _PrayerCategory {
  String get label => switch (this) {
        _PrayerCategory.health    => 'Health',
        _PrayerCategory.family    => 'Family',
        _PrayerCategory.guidance  => 'Guidance',
        _PrayerCategory.provision => 'Provision',
      };

  IconData get icon => switch (this) {
        _PrayerCategory.health    => Icons.favorite_outline,
        _PrayerCategory.family    => Icons.group_outlined,
        _PrayerCategory.guidance  => Icons.explore_outlined,
        _PrayerCategory.provision => Icons.inventory_2_outlined,
      };

  Color get iconColor => switch (this) {
        _PrayerCategory.health    => const Color(0xFFF43F5E),
        _PrayerCategory.family    => AppColors.primary,
        _PrayerCategory.guidance  => const Color(0xFF059669),
        _PrayerCategory.provision => const Color(0xFF3B82F6),
      };

  Color get bgColor => switch (this) {
        _PrayerCategory.health    => const Color(0xFFFDE4E8),
        _PrayerCategory.family    => const Color(0xFFFEEADF),
        _PrayerCategory.guidance  => const Color(0xFFDCF3EC),
        _PrayerCategory.provision => const Color(0xFFDBEBF8),
      };
}

// ── Screen ────────────────────────────────────────────────────────────────────
class SubmitGlobalPrayerScreen extends StatefulWidget {
  const SubmitGlobalPrayerScreen({super.key});

  @override
  State<SubmitGlobalPrayerScreen> createState() =>
      _SubmitGlobalPrayerScreenState();
}

class _SubmitGlobalPrayerScreenState extends State<SubmitGlobalPrayerScreen> {
  final _titleCtrl    = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _bodyCtrl     = TextEditingController();

  _PrayerCategory _category = _PrayerCategory.family;
  bool _isAnonymous  = false;
  bool _isSubmitting = false;
  bool _isGettingLoc = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  void _submit() {
    final title = _titleCtrl.text.trim();
    final body  = _bodyCtrl.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the title and your prayer request.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final banned = firstBannedWord('$title $body');
    if (banned != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Your post contains inappropriate language. Please revise.',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      // Save to personal prayer list
      myPrayerRequestsNotifier.value = [
        ...myPrayerRequestsNotifier.value,
        UserPrayer(
          body: '$title — $body',
          isAnonymous: _isAnonymous,
          addedAt: DateTime.now(),
        ),
      ];

      // Light the user's COUNTRY on the global map — never exact coordinates.
      final iso  = userCountryIsoNotifier.value;
      final name = userCountryNotifier.value;
      if (iso.isNotEmpty) {
        final existing = globalPrayerLightsNotifier.value;
        final idx = existing.indexWhere((l) => l.countryIso == iso);
        if (idx >= 0) {
          // Country already glowing — increment its pray count
          final updated = List<GlobalPrayerLight>.from(existing);
          updated[idx].prayCount++;
          globalPrayerLightsNotifier.value = updated;
        } else {
          globalPrayerLightsNotifier.value = [
            ...existing,
            GlobalPrayerLight(
              countryIso:  iso,
              countryName: name,
              addedAt:     DateTime.now(),
            ),
          ];
        }
      }

      setState(() => _isSubmitting = false);
      _showSuccessSheet();
    });
  }

  // ── Auto-detect location (country-level only — privacy preserved) ─────────
  Future<void> _detectLocation() async {
    setState(() => _isGettingLoc = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final city    = userCityNotifier.value;
    final country = userCountryNotifier.value;
    final label   = [if (city.isNotEmpty) city, if (country.isNotEmpty) country]
        .join(', ');

    _locationCtrl.text = label.isNotEmpty ? label : 'Unknown location';
    setState(() => _isGettingLoc = false);
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SuccessSheet(
        onDone: () {
          Navigator.of(context).pop(); // close sheet
          Navigator.of(context).pop(); // go back to map
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg    = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              decoration: BoxDecoration(
                color: bg,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Submit to Global Prayer Network',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Scrollable body ─────────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        20, 24, 20, MediaQuery.of(context).padding.bottom + 130),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero copy
                        Text(
                          'Share your heart\nwith the world',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your prayer will appear as a light on the global map for others to join you in faith.',
                          style: TextStyle(
                              fontSize: 13, height: 1.6, color: subColor),
                        ),
                        const SizedBox(height: 28),

                        // Title
                        _FormLabel(label: 'Prayer Title'),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _titleCtrl,
                          hint: 'e.g., Healing for my community',
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(height: 18),

                        // Location
                        _FormLabel(label: 'Location'),
                        const SizedBox(height: 8),
                        _LocationField(
                          controller: _locationCtrl,
                          isLoading: _isGettingLoc,
                          onDetect: _detectLocation,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(height: 18),

                        // Category
                        _FormLabel(label: 'Prayer Category'),
                        const SizedBox(height: 10),
                        _CategoryGrid(
                          selected: _category,
                          onSelect: (c) => setState(() => _category = c),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 18),

                        // Detailed request
                        _FormLabel(label: 'Detailed Request'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _bodyCtrl,
                          maxLines: null,
                          minLines: 6,
                          style: TextStyle(
                              fontSize: 14, height: 1.6, color: textColor),
                          decoration: InputDecoration(
                            hintText: 'Describe your prayer request here...',
                            hintStyle:
                                TextStyle(color: subColor, fontSize: 14),
                            filled: true,
                            fillColor: cardBg,
                            contentPadding: const EdgeInsets.all(14),
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
                        const SizedBox(height: 18),

                        // Anonymous toggle
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.nude.withAlpha(isDark ? 20 : 80),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Share Anonymously',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Your name will be hidden on the map.',
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
                                activeThumbColor: AppColors.primary,
                                activeTrackColor:
                                    AppColors.primary.withAlpha(80),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Active prayers banner
                        _ActiveBanner(),
                        const SizedBox(height: 16),

                        // Scripture
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '"For where two or three are gathered in my name, there am I among them." — Matt 18:20',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                                color: subColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pinned submit button
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
                            bg.withAlpha(0),
                            bg.withAlpha(210),
                            bg,
                          ],
                          stops: const [0.0, 0.28, 1.0],
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
                          20, 24, 20,
                          MediaQuery.of(context).padding.bottom + 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
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
                              : const Icon(Icons.auto_awesome, size: 20),
                          label: Text(
                            _isSubmitting
                                ? 'Lighting your prayer...'
                                : 'Light a Prayer on the Map',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                                AppColors.primary.withAlpha(130),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor:
                                AppColors.primary.withAlpha(80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
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
}

// ── Category Grid ─────────────────────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  final _PrayerCategory selected;
  final ValueChanged<_PrayerCategory> onSelect;
  final bool isDark;

  const _CategoryGrid({
    required this.selected,
    required this.onSelect,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _PrayerCategory.values.map((cat) {
        final isSelected = cat == selected;
        return GestureDetector(
          onTap: () => onSelect(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withAlpha(18)
                  : (isDark
                      ? cat.bgColor.withAlpha(20)
                      : cat.bgColor.withAlpha(120)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cat.icon,
                  color: isSelected ? AppColors.primary : cat.iconColor,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  cat.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Active Banner ─────────────────────────────────────────────────────────────
class _ActiveBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Subtle dot-glow background
            Positioned.fill(
              child: CustomPaint(painter: _BannerDotPainter()),
            ),
            // Pill
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(230),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: _PulsingDot(),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '12,402 prayers active globally',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
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

class _BannerDotPainter extends CustomPainter {
  static const _dots = [
    Offset(0.08, 0.3), Offset(0.15, 0.7), Offset(0.25, 0.4),
    Offset(0.35, 0.6), Offset(0.45, 0.25), Offset(0.55, 0.75),
    Offset(0.62, 0.45), Offset(0.72, 0.65), Offset(0.82, 0.35),
    Offset(0.92, 0.55), Offset(0.12, 0.55), Offset(0.78, 0.8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final d in _dots) {
      paint.color = AppColors.primary
          .withAlpha((30 + (d.dy * 60)).toInt().clamp(0, 255));
      canvas.drawCircle(
          Offset(d.dx * size.width, d.dy * size.height), 3.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: 0.4 + 0.6 * _ctrl.value,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ── Small helpers ─────────────────────────────────────────────────────────────
class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF64748B),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: subColor, fontSize: 14),
        filled: true,
        fillColor: cardBg,
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
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onDetect;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;

  const _LocationField({
    required this.controller,
    required this.isLoading,
    required this.onDetect,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        hintText: 'Search or auto-detect',
        hintStyle: TextStyle(color: subColor, fontSize: 14),
        filled: true,
        fillColor: cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.my_location, color: AppColors.primary),
                onPressed: onDetect,
              ),
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
      ),
    );
  }
}

// ── Success Bottom Sheet ──────────────────────────────────────────────────────
class _SuccessSheet extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessSheet({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(
        color: Color(0xFF060D1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Prayer is Live!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your prayer is now a light on the global map.\nBrothers and sisters around the world can see and pray with you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.white.withAlpha(160),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'View on Map',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
