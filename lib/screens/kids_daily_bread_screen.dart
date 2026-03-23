import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/user_session.dart';

// ─── Kids devotion data ──────────────────────────────────────────────────────
class _KidsLesson {
  final String emoji;
  final String title;
  final String storySummary;
  final String verseText;
  final String verseRef;
  final String activity;
  final List<Color> colors;
  const _KidsLesson({
    required this.emoji,
    required this.title,
    required this.storySummary,
    required this.verseText,
    required this.verseRef,
    required this.activity,
    required this.colors,
  });
}

const _lessons = [
  _KidsLesson(
    emoji: '🌟',
    title: 'You Are God\'s Star!',
    storySummary:
        'God made the sun, the moon, and all the stars. But did you know He also made YOU? And He thinks you are even more special than any star! God chose YOU to be here today.',
    verseText: '"I praise you because I am fearfully and wonderfully made."',
    verseRef: 'Psalm 139:14',
    activity:
        '✏️  Draw your favorite star and write your name inside it. Remember — God knows your name and loves you!',
    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
  ),
  _KidsLesson(
    emoji: '🌈',
    title: 'God Keeps His Promises',
    storySummary:
        'After a big rain, God put a rainbow in the sky. It was His promise to Noah — and to us — that He always keeps His word. Every rainbow you see is God saying: "I love you and I keep my promises!"',
    verseText: '"God is not human... Does he promise and not fulfill?"',
    verseRef: 'Numbers 23:19',
    activity:
        '🎨  Color a rainbow! Use as many colors as you can. Count the colors — just like God has SO many ways to show His love.',
    colors: [Color(0xFF6A1B9A), Color(0xFFCE93D8)],
  ),
  _KidsLesson(
    emoji: '🦁',
    title: 'Daniel and the Lions',
    storySummary:
        'Daniel prayed to God every day, even when it was dangerous. God sent an angel to shut the lions\' mouths and Daniel was safe! When we pray and trust God, He takes care of us too.',
    verseText: '"My God sent his angel, and he shut the mouths of the lions."',
    verseRef: 'Daniel 6:22',
    activity:
        '🙏  Make a prayer list! Write 3 things you want to say thank you to God for today.',
    colors: [Color(0xFFE65100), Color(0xFFFFB74D)],
  ),
  _KidsLesson(
    emoji: '🐑',
    title: 'The Good Shepherd',
    storySummary:
        'Jesus said He is like a shepherd who takes care of all His sheep. If one sheep gets lost, the shepherd leaves the 99 others to go find it! That\'s how much Jesus loves YOU — He will always look for you.',
    verseText:
        '"I am the good shepherd. The good shepherd lays down his life for the sheep."',
    verseRef: 'John 10:11',
    activity:
        '🐑  Act it out! Ask a family member to pretend to be a lost sheep while you are the good shepherd who finds them. Then switch!',
    colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
  ),
  _KidsLesson(
    emoji: '🍞',
    title: 'Jesus Feeds 5,000 People!',
    storySummary:
        'A boy had only 5 small loaves of bread and 2 fish. Jesus took his small lunch, said thank you to God, and suddenly there was enough food for 5,000 people! When we give what we have to Jesus, He can do amazing things.',
    verseText:
        '"Here is a boy with five small barley loaves and two small fish, but how far will they go among so many?"',
    verseRef: 'John 6:9',
    activity:
        '❤️  Think of something small you can share with someone today. A smile, a snack, or a kind word. Watch what God does with it!',
    colors: [Color(0xFF00695C), Color(0xFF4DB6AC)],
  ),
  _KidsLesson(
    emoji: '⭐',
    title: 'Jesus Walks on Water!',
    storySummary:
        'The disciples were in a boat during a storm. Then they saw Jesus WALKING on the water! Peter jumped out to walk to Jesus too — and when he kept his eyes on Jesus, he walked on water! When we look to Jesus and not the storm, we don\'t have to be afraid.',
    verseText: '"Take courage! It is I. Don\'t be afraid."',
    verseRef: 'Matthew 14:27',
    activity:
        '🌊  Draw the stormy sea and Jesus walking on it. Write one thing that scares you, then draw Jesus holding your hand.',
    colors: [Color(0xFF0D47A1), Color(0xFF64B5F6)],
  ),
  _KidsLesson(
    emoji: '🌱',
    title: 'The Tiny Mustard Seed',
    storySummary:
        'Jesus said that faith is like a tiny mustard seed. It starts SO small — but it grows into a BIG tree where birds can live! Even if your faith feels tiny today, God can grow it into something amazing.',
    verseText:
        '"If you have faith as small as a mustard seed... nothing will be impossible for you."',
    verseRef: 'Matthew 17:20',
    activity:
        '🌿  Plant a seed (or draw one)! Watch it grow this week. Every time you water it, tell God one thing you believe He can do.',
    colors: [Color(0xFF558B2F), Color(0xFFAED581)],
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class KidsDailyBreadScreen extends StatefulWidget {
  const KidsDailyBreadScreen({super.key});

  @override
  State<KidsDailyBreadScreen> createState() => _KidsDailyBreadScreenState();
}

class _KidsDailyBreadScreenState extends State<KidsDailyBreadScreen>
    with TickerProviderStateMixin {
  late final _KidsLesson _lesson;
  late final AnimationController _bounceCtrl;
  late final AnimationController _starCtrl;
  late final Animation<double> _bounceAnim;
  late final Animation<double> _starAnim;

  bool _activityDone = false;

  @override
  void initState() {
    super.initState();
    // Pick a lesson based on user + day (unique per person per day)
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final userHash = userNameNotifier.value.hashCode.abs();
    final idx = (userHash + dayOfYear) % _lessons.length;
    _lesson = _lessons[idx];

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _bounceAnim = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );

    _starAnim = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _starCtrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _starCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _lesson.colors.first.withOpacity(0.9),
              _lesson.colors.last.withOpacity(0.7),
              Colors.white,
            ],
            stops: const [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'KIDS DAILY BREAD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      20, 8, 20, MediaQuery.of(context).padding.bottom + 32),
                  child: Column(
                    children: [
                      // Big animated emoji
                      AnimatedBuilder(
                        animation: _bounceAnim,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, -_bounceAnim.value),
                          child: child,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rotating sparkles
                            AnimatedBuilder(
                              animation: _starAnim,
                              builder: (context, _) => Transform.rotate(
                                angle: _starAnim.value,
                                child: _SparkleRing(
                                    color: Colors.white.withOpacity(0.35),
                                    radius: 72),
                              ),
                            ),
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.25),
                              ),
                              child: Center(
                                child: Text(
                                  _lesson.emoji,
                                  style: const TextStyle(fontSize: 64),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        _lesson.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 8,
                              color: Color(0x40000000),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Story card
                      _KidsCard(
                        label: '📖  Today\'s Story',
                        labelColor: _lesson.colors.first,
                        child: Text(
                          _lesson.storySummary,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Verse card with colorful soothing bg
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Gradient background
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _lesson.colors.first.withOpacity(0.2),
                                    _lesson.colors.last.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            // Stars decoration
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Text(
                                '✨',
                                style: TextStyle(
                                    fontSize: 24,
                                    color:
                                        Colors.white.withOpacity(0.8)),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 12,
                              child: Text(
                                '🌟',
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        Colors.white.withOpacity(0.6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('📜',
                                          style:
                                              const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Memory Verse',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: _lesson.colors.first,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _lesson.verseText,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w700,
                                      height: 1.6,
                                      color: _lesson.colors.first,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _lesson.colors.first
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      _lesson.verseRef,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _lesson.colors.first,
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

                      // Activity card
                      _KidsCard(
                        label: '🎯  Fun Activity',
                        labelColor: const Color(0xFFE65100),
                        child: Text(
                          _lesson.activity,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Done button
                      GestureDetector(
                        onTap: () => setState(() => _activityDone = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _activityDone
                                ? const Color(0xFF2E7D32)
                                : _lesson.colors.first,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: _lesson.colors.first.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _activityDone ? '🎉' : '✅',
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _activityDone
                                    ? 'Amazing! God is proud of you!'
                                    : 'I did my activity!',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Footer
                      Text(
                        'Jesus loves me, this I know! ❤️',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF475569),
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

class _KidsCard extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Widget child;
  const _KidsCard(
      {required this.label, required this.labelColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SparkleRing extends StatelessWidget {
  final Color color;
  final double radius;
  const _SparkleRing({required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        painter: _SparkleRingPainter(color: color, radius: radius),
      ),
    );
  }
}

class _SparkleRingPainter extends CustomPainter {
  final Color color;
  final double radius;
  const _SparkleRingPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkleRingPainter old) =>
      old.color != color || old.radius != radius;
}
