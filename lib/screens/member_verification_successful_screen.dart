import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'find_your_church_screen.dart';

class MemberVerificationSuccessfulScreen extends StatefulWidget {
  const MemberVerificationSuccessfulScreen({super.key});

  @override
  State<MemberVerificationSuccessfulScreen> createState() =>
      _MemberVerificationSuccessfulScreenState();
}

class _MemberVerificationSuccessfulScreenState
    extends State<MemberVerificationSuccessfulScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _ringAnim;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
    _ringAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _goToFindChurch() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const FindYourChurchScreen()),
      (route) => route.isFirst,
    );
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sage.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: babyBlue.withOpacity(0.1),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 56),

                        // Pulsing verified icon
                        Center(
                          child: AnimatedBuilder(
                            animation: _pulse,
                            builder: (_, __) => Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer ping ring
                                Container(
                                  width: 200 + _ringAnim.value * 20,
                                  height: 200 + _ringAnim.value * 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: sage.withOpacity(
                                        0.08 * (1 - _ringAnim.value)),
                                  ),
                                ),
                                // Glow halo
                                Container(
                                  width: 168,
                                  height: 168,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: sage.withOpacity(0.15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: sage.withOpacity(
                                            0.2 + _pulse.value * 0.15),
                                        blurRadius:
                                            24 + _pulse.value * 12,
                                        spreadRadius:
                                            _pulse.value * 6,
                                      ),
                                    ],
                                  ),
                                ),
                                // Icon
                                ScaleTransition(
                                  scale: _scaleAnim,
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          sage,
                                          babyBlue,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              sage.withOpacity(0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.verified_user,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Floating accents
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: 48,
                              top: 0,
                              child: AnimatedBuilder(
                                animation: _pulse,
                                builder: (_, __) => Transform.translate(
                                  offset: Offset(
                                      0, -4 + _pulse.value * 8),
                                  child: Icon(Icons.auto_awesome,
                                      color: babyBlue.withOpacity(
                                          0.6 + _pulse.value * 0.3),
                                      size: 18),
                                ),
                              ),
                            ),
                            // Heading
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28),
                              child: Column(
                                children: [
                                  Text(
                                    'You\'re Verified!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: textColor,
                                      letterSpacing: -0.6,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: subColor,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text:
                                                'Welcome to the community, '),
                                        TextSpan(
                                          text: 'Sarah',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const TextSpan(
                                            text:
                                                '. Your identity has been confirmed. You can now join your church and connect with the family.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // What's unlocked card
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sage.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.lock_open_outlined,
                                        color: sage, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'What\'s Now Unlocked',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF374151),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ...[
                                  (Icons.church_outlined, 'Find & join your church community'),
                                  (Icons.forum_outlined, 'Post testimonies and prayer requests'),
                                  (Icons.people_outline, 'Connect with verified members'),
                                  (Icons.event_outlined, 'Register for church events'),
                                ].map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color:
                                                sage.withOpacity(0.12),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(item.$1,
                                              color: sage, size: 14),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          item.$2,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: subColor,
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
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, 0, 20,
                      MediaQuery.of(context).padding.bottom + 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _goToFindChurch,
                          icon: const Icon(Icons.search, size: 20),
                          label: const Text(
                            'Find Your Church',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sage,
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor: sage.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _goHome,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                            ),
                            foregroundColor: subColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'Go to Home',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer
                Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).padding.bottom + 4),
                  child: Text(
                    '"For where two or three gather in my name, there am I." — Matt 18:20',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: subColor.withOpacity(0.55),
                      height: 1.5,
                    ),
                  ),
                ),

                // Decorative gradient bar
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [sage, babyBlue, dustyRose],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
