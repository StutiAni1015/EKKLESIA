import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'church_creation_basic_info_screen.dart';
import 'church_join_application_screen.dart';

class JoinAChurchScreen extends StatefulWidget {
  const JoinAChurchScreen({super.key});

  @override
  State<JoinAChurchScreen> createState() => _JoinAChurchScreenState();
}

class _JoinAChurchScreenState extends State<JoinAChurchScreen> {
  final _searchCtrl = TextEditingController();
  int _activeChip = -1;

  static const _chips = ['Nearby', 'Baptist', 'Non-denominational'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
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
              color: cardBg.withOpacity(0.8),
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Join a Church',
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

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    24, 0, 24, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Illustration circle
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow blur
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                const Color(0xFF4F46E5).withOpacity(0.08),
                          ),
                        ),
                        // Gradient circle
                        Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFE0E7FF), // pastel blue
                                Color(0xFFF3E8FF), // pastel purple
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.church,
                            size: 72,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Hero text
                    Text(
                      "Let's add you to a church",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        height: 1.2,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Connect with a local community to grow\nyour faith and find support.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        style: TextStyle(fontSize: 15, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'Search by name, city, or denomination',
                          hintStyle:
                              TextStyle(color: subColor, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: subColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F46E5),
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: cardBg,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Suggestion chips
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: List.generate(_chips.length, (i) {
                        final active = _activeChip == i;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _activeChip = active ? -1 : i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF4F46E5).withOpacity(0.1)
                                  : cardBg,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: active
                                    ? const Color(0xFF4F46E5)
                                    : borderColor,
                              ),
                            ),
                            child: Text(
                              _chips[i],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? const Color(0xFF4F46E5)
                                    : subColor,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),

                    // "Create church" link
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ChurchCreationBasicInfoScreen(),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 13, color: subColor),
                            children: const [
                              TextSpan(text: "Can't find yours? "),
                              TextSpan(
                                text: 'Create a church',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nearby churches heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nearby Churches',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '3 found',
                          style: TextStyle(fontSize: 13, color: subColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Church cards
                    ...[
                      _ChurchResult(
                        name: 'Grace Community Church',
                        location: 'Austin, TX',
                        denomination: 'Non-denominational',
                        members: '1,200+',
                        distance: '0.8 mi',
                      ),
                      _ChurchResult(
                        name: 'Calvary Baptist Church',
                        location: 'Austin, TX',
                        denomination: 'Baptist',
                        members: '450',
                        distance: '1.4 mi',
                      ),
                      _ChurchResult(
                        name: 'Hope Fellowship',
                        location: 'Austin, TX',
                        denomination: 'Pentecostal',
                        members: '820',
                        distance: '2.1 mi',
                      ),
                    ].map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ChurchCard(
                          church: c,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          subColor: subColor,
                          textColor: textColor,
                          onJoin: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChurchJoinApplicationScreen(
                                churchName: c.name,
                                churchLocation: c.location,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider before map
                    Divider(
                        color:
                            isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),
                    Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Map placeholder
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFD1FAE5),
                            isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFBFDBFE),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Map grid lines (decorative)
                          ...List.generate(4, (i) => Positioned(
                                top: 0,
                                bottom: 0,
                                left: i * 60.0 + 30,
                                child: Container(
                                  width: 1,
                                  color:
                                      Colors.white.withOpacity(0.15),
                                ),
                              )),
                          ...List.generate(4, (i) => Positioned(
                                left: 0,
                                right: 0,
                                top: i * 45.0 + 20,
                                child: Container(
                                  height: 1,
                                  color:
                                      Colors.white.withOpacity(0.15),
                                ),
                              )),

                          // Location chip
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withOpacity(0.7)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.circular(99),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF4F46E5),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Use my current location',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Church pins
                          Positioned(
                            top: 40,
                            left: 80,
                            child: _MapPin(isDark: isDark),
                          ),
                          Positioned(
                            top: 90,
                            right: 60,
                            child: _MapPin(isDark: isDark),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 140,
                            child: _MapPin(isDark: isDark),
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

// ── Church result data ─────────────────────────────────────────────────────

class _ChurchResult {
  final String name;
  final String location;
  final String denomination;
  final String members;
  final String distance;

  const _ChurchResult({
    required this.name,
    required this.location,
    required this.denomination,
    required this.members,
    required this.distance,
  });
}

// ── Church card widget ─────────────────────────────────────────────────────

class _ChurchCard extends StatelessWidget {
  final _ChurchResult church;
  final Color cardBg;
  final Color borderColor;
  final Color subColor;
  final Color textColor;
  final VoidCallback onJoin;

  const _ChurchCard({
    required this.church,
    required this.cardBg,
    required this.borderColor,
    required this.subColor,
    required this.textColor,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Church icon avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
            ),
            child: const Icon(Icons.church, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  church.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${church.location} · ${church.denomination}',
                  style: TextStyle(fontSize: 12, color: subColor),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _Chip(
                      icon: Icons.people_outline,
                      label: church.members,
                      subColor: subColor,
                    ),
                    const SizedBox(width: 10),
                    _Chip(
                      icon: Icons.near_me_outlined,
                      label: church.distance,
                      subColor: subColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Join button
          ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Join',
              style:
                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color subColor;

  const _Chip(
      {required this.icon, required this.label, required this.subColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: subColor),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(fontSize: 11, color: subColor)),
      ],
    );
  }
}

// ── Map pin ────────────────────────────────────────────────────────────────

class _MapPin extends StatelessWidget {
  final bool isDark;
  const _MapPin({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.church, color: Colors.white, size: 12),
    );
  }
}
