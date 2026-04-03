import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';

/// Full-screen prayer focus lock screen.
/// Prevents back navigation until the timer ends (or user confirms early exit).
class PrayerFocusActiveScreen extends StatefulWidget {
  final int totalMinutes;

  const PrayerFocusActiveScreen({super.key, required this.totalMinutes});

  @override
  State<PrayerFocusActiveScreen> createState() =>
      _PrayerFocusActiveScreenState();
}

class _PrayerFocusActiveScreenState extends State<PrayerFocusActiveScreen>
    with TickerProviderStateMixin {
  late int _secondsLeft;
  Timer? _countdownTimer;
  bool _sessionComplete = false;

  // Pulsing ring animation
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  // Page controller for rotating scripture/prayer prompts
  final _pageCtrl = PageController();
  int _promptPage = 0;
  Timer? _promptTimer;

  static const _prompts = [
    _Prompt(
      icon: '🙏',
      title: 'Begin with Thanksgiving',
      body:
          '"Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name." — Psalm 100:4',
    ),
    _Prompt(
      icon: '📖',
      title: 'Meditate on the Word',
      body:
          '"Blessed is the one who does not walk in step with the wicked… but whose delight is in the law of the Lord, and who meditates on his law day and night." — Psalm 1:1–2',
    ),
    _Prompt(
      icon: '✝️',
      title: 'Intercession',
      body:
          'Bring your burdens before God. Pray for your family, your church, your nation, and those who need healing today.',
    ),
    _Prompt(
      icon: '🕊️',
      title: 'Surrender',
      body:
          '"Be still before the Lord and wait patiently for him." — Psalm 37:7\n\nRelease your worries. Rest in His presence.',
    ),
    _Prompt(
      icon: '🌟',
      title: 'Worship',
      body:
          '"Praise him with timbrel and dancing, praise him with the strings and pipe… Let everything that has breath praise the Lord." — Psalm 150:4,6',
    ),
    _Prompt(
      icon: '🌿',
      title: 'Listen',
      body:
          'Sit quietly. Ask the Holy Spirit to speak. Journal anything He brings to your heart during this sacred time.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.totalMinutes * 60;

    // Lock status bar / immersive
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _startCountdown();
    _startPromptCycle();
  }

  void _startCountdown() {
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          t.cancel();
          _sessionComplete = true;
        }
      });
    });
  }

  void _startPromptCycle() {
    _promptTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      final next = (_promptPage + 1) % _prompts.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() => _promptPage = next);
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _promptTimer?.cancel();
    _pulseCtrl.dispose();
    _pageCtrl.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String get _timeDisplay {
    final h = _secondsLeft ~/ 3600;
    final m = (_secondsLeft % 3600) ~/ 60;
    final s = _secondsLeft % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      1.0 -
      (_secondsLeft / (widget.totalMinutes * 60)).clamp(0.0, 1.0);

  Future<bool> _onWillPop() async {
    if (_sessionComplete) return true;
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF1E293B) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('End Focus Session?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'Are you sure you want to end your prayer time early? Your session will not be saved.',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Keep Praying',
                  style: TextStyle(color: AppColors.primary,
                      fontWeight: FontWeight.w700)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('End Session',
                  style: TextStyle(color: Color(0xFFEF4444))),
            ),
          ],
        );
      },
    );
    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: _sessionComplete,
      onPopInvoked: (didPop) async {
        if (!didPop && !_sessionComplete) {
          final leave = await _onWillPop();
          if (leave && mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF0A0F1E),
                      const Color(0xFF0F172A),
                      const Color(0xFF162032),
                    ]
                  : [
                      const Color(0xFF1A3A4A),
                      const Color(0xFF2C5F6E),
                      const Color(0xFF1E4458),
                    ],
            ),
          ),
          child: SafeArea(
            child: _sessionComplete
                ? _buildComplete(isDark)
                : _buildActive(isDark, size),
          ),
        ),
      ),
    );
  }

  Widget _buildActive(bool isDark, Size size) {
    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final leave = await _onWillPop();
                  if (leave && mounted) Navigator.of(context).pop();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, color: Colors.white54, size: 14),
                      SizedBox(width: 4),
                      Text('End',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4ADE80).withOpacity(0.6),
                            blurRadius: 4,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('Focus Mode ON',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Timer ring
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse glow
              ScaleTransition(
                scale: _pulseAnim,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.08),
                  ),
                ),
              ),
              // Progress arc
              SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: _TimerRingPainter(progress: _progress),
                ),
              ),
              // Time text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _timeDisplay,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const Text(
                    'remaining',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Prompt cards
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _promptPage = i),
            itemCount: _prompts.length,
            itemBuilder: (_, i) {
              final p = _prompts[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(p.icon,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Text(
                            p.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          p.body,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.75),
                            height: 1.6,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Page dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_prompts.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _promptPage == i ? 16 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _promptPage == i
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),

        const Spacer(),

        // Scripture label at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Text(
            '"Be still, and know that I am God" — Psalm 46:10',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplete(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4ADE80).withOpacity(0.15),
          ),
          child: const Icon(Icons.check_circle_outline,
              color: Color(0xFF4ADE80), size: 56),
        ),
        const SizedBox(height: 24),
        const Text(
          'Prayer Session Complete!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You completed ${widget.totalMinutes} ${widget.totalMinutes == 1 ? 'minute' : 'minutes'} of focused prayer.\n"The prayer of a righteous person is powerful and effective." — James 5:16',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.65),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Done',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  const _TimerRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeW = 8.0;

    // Track ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) => old.progress != progress;
}

class _Prompt {
  final String icon;
  final String title;
  final String body;
  const _Prompt({required this.icon, required this.title, required this.body});
}
