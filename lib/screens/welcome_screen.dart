import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import 'signup_basic_profile_screen.dart';
import 'signin_screen.dart';

// Localized welcome text per language code
const _welcomeByCode = {
  'en': 'Welcome',
  'es': 'Bienvenido',
  'fr': 'Bienvenue',
  'pt': 'Bem-vindo',
  'ko': '환영합니다',
  'zh': '欢迎',
  'hi': 'स्वागत है',
  'ar': 'أهلاً وسهلاً',
  'sw': 'Karibu',
  'tl': 'Maligayang pagdating',
};

class WelcomeScreen extends StatefulWidget {
  final String languageCode;
  final String languageNativeName;

  const WelcomeScreen({
    super.key,
    required this.languageCode,
    required this.languageNativeName,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _spinCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _fadeCtrl;

  late final Animation<double> _pulseAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  String get _welcomeText =>
      _welcomeByCode[widget.languageCode] ?? 'Welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE1DAD3), Color(0xFFA4B1BA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main hero area
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Greek watermark
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      child: Text(
                        'ἐκκλησία',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 80,
                          color: Colors.white.withOpacity(0.10),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Globe with floating icons
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsing glow
                              ScaleTransition(
                                scale: _pulseAnim,
                                child: Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.4),
                                        blurRadius: 60,
                                        spreadRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Spinning globe
                              RotationTransition(
                                turns: _spinCtrl,
                                child: CustomPaint(
                                  size: const Size(220, 220),
                                  painter: _GlobePainter(),
                                ),
                              ),

                              // App logo in center of globe
                              ClipOval(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white.withOpacity(0.15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              // Floating heart 1
                              Positioned(
                                top: 16,
                                left: 32,
                                child: _BouncingWidget(
                                  delay: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.pink[100]!.withOpacity(0.6),
                                    size: 22,
                                  ),
                                ),
                              ),

                              // Floating heart 2
                              Positioned(
                                bottom: 32,
                                right: 12,
                                child: _BouncingWidget(
                                  delay: const Duration(milliseconds: 1500),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.pink[50]!.withOpacity(0.5),
                                    size: 16,
                                  ),
                                ),
                              ),

                              // People icon
                              Positioned(
                                right: 0,
                                child: _BouncingWidget(
                                  delay: const Duration(milliseconds: 800),
                                  child: Icon(
                                    Icons.people,
                                    color: Colors.white.withOpacity(0.4),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Messaging
                        SlideTransition(
                          position: _slideAnim,
                          child: FadeTransition(
                            opacity: _fadeAnim,
                            child: Column(
                              children: [
                                Text(
                                  _welcomeText,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF4A4A4A),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Connecting the global church, together.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: Text(
                                    '"Let us not give up meeting together, as some are in the habit of doing, but encouraging one another."',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600],
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'HEBREWS 10:25',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2.5,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Footer CTA
              FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SignupBasicProfileScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD7A49A),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SigninScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            children: const [
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 1.2,
                                  fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}

// Bouncing animation wrapper
class _BouncingWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _BouncingWidget({required this.child, required this.delay});

  @override
  State<_BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<_BouncingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _anim.value), child: child),
      child: widget.child,
    );
  }
}

// Globe painter (mirrors the SVG)
class _GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 2;

    // Outer circle
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Vertical great circle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 2, height: size.height - 4),
      paint,
    );

    // Horizontal equator
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), paint);

    // Wide horizontal ellipse
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: size.width - 4, height: r * 0.6),
      paint,
    );

    // Narrow vertical ellipse
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: r * 0.6, height: size.height - 4),
      paint,
    );

    // Latitude lines
    for (final fraction in [0.3, 0.7]) {
      final y = cy + (fraction - 0.5) * size.height * 0.8;
      final halfW =
          math.sqrt(math.max(0, r * r - math.pow(y - cy, 2).toDouble()));
      canvas.drawLine(
        Offset(cx - halfW, y),
        Offset(cx + halfW, y),
        paint..color = Colors.white.withOpacity(0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
