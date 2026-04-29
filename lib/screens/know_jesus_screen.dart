import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kids_home_screen.dart';
import 'quiz_time_screen.dart';

class KnowJesusScreen extends StatefulWidget {
  final Map<String, dynamic>? child;
  const KnowJesusScreen({super.key, this.child});

  @override
  State<KnowJesusScreen> createState() => _KnowJesusScreenState();
}

class _KnowJesusScreenState extends State<KnowJesusScreen> {
  bool _quizDone = false;

  @override
  void initState() {
    super.initState();
    _checkQuiz();
  }

  void _showInfoSheet(BuildContext ctx, String emoji, String title, String body) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kKidsSurfaceContLowest,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 20, fontWeight: FontWeight.w900, color: kKidsPrimary)),
            const SizedBox(height: 12),
            Text(body,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, color: kKidsOnSurface, height: 1.6)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kKidsPrimary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Got it! 👍',
                    style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkQuiz() async {
    final childId = widget.child?['_id'] as String? ?? 'guest';
    final now     = DateTime.now();
    final today   = '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
    final prefs   = await SharedPreferences.getInstance();
    if (mounted) setState(() => _quizDone = prefs.getBool('quiz_done_${childId}_$today') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final emoji = widget.child?['avatarEmoji'] as String? ?? '🧒';
    final name  = widget.child?['name']        as String? ?? 'Storyteller';

    return Scaffold(
      backgroundColor: kKidsSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => KidsHomeScreen(child: widget.child))),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: kKidsSurfaceContLowest,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kKidsPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, $name! 👋',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 18, fontWeight: FontWeight.w900, color: kKidsPrimary)),
                        Text('Explore who Jesus is',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11, color: kKidsOnSurfaceVariant)),
                      ],
                    ),
                  ),
                  // Kingdom badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kKidsPrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text('KINGDOM',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, fontWeight: FontWeight.w900,
                                color: Colors.white, letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero card ─────────────────────────────────────────
                    _HeroCard(),
                    const SizedBox(height: 16),

                    // ── Two side-by-side info cards ───────────────────────
                    Row(
                      children: [
                        Expanded(child: _InfoCard(
                          title: 'Jesus as\na Child',
                          emoji: '👶',
                          color: kKidsSecondaryContainer,
                          textColor: kKidsSecondary,
                          radius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          onTap: () => _showInfoSheet(context, '👶', 'Jesus as a Child',
                            'Jesus was born in Bethlehem in a manger. His family then moved to Nazareth, where He grew up. When Jesus was 12 years old, He visited the Temple in Jerusalem and amazed the teachers with His wisdom. The Bible says He grew in wisdom, stature, and favour with God and people.\n\n📖 Luke 2:52 — "Jesus grew in wisdom and stature, and in favour with God and man."'),
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: _InfoCard(
                          title: 'Jesus\nLoves Kids',
                          emoji: '❤️',
                          color: kKidsTertiaryContainer,
                          textColor: kKidsTertiary,
                          radius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(40),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          onTap: () => _showInfoSheet(context, '❤️', 'Jesus Loves Kids',
                            'One day, people brought little children to Jesus so He could bless them. His disciples tried to send them away, but Jesus said, "Let the children come to me and do not stop them — the Kingdom of God belongs to people like these."\n\nHe picked up the children, placed His hands on them, and blessed them.\n\n📖 Mark 10:14 — "Let the little children come to me, for the kingdom of God belongs to such as these."'),
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Miracles card ─────────────────────────────────────
                    _MiraclesCard(onMiracleTap: _showInfoSheet),
                    const SizedBox(height: 24),

                    // ── CTA button ────────────────────────────────────────
                    GestureDetector(
                      onTap: _quizDone ? null : () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => QuizTimeScreen(child: widget.child))),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: _quizDone
                              ? const LinearGradient(colors: [Color(0xFF64748B), Color(0xFF475569)])
                              : const LinearGradient(colors: [kKidsPrimary, Color(0xFFD64A00)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (_quizDone ? const Color(0xFF64748B) : kKidsPrimary).withAlpha(80),
                              blurRadius: 16, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_quizDone ? '✅' : '🎯', style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Text(_quizDone ? 'QUIZ COMPLETED' : 'TAKE THE JESUS QUIZ',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16, fontWeight: FontWeight.w900,
                                    color: Colors.white, letterSpacing: 0.8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom nav ────────────────────────────────────────────────
            KidsBottomNav(activeIndex: kKidsTabKnowJesus, child: widget.child),
          ],
        ),
      ),
    );
  }
}

// ── Hero card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF306800), Color(0xFF4A9E00)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text("TODAY'S TOPIC",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 9, fontWeight: FontWeight.w800,
                        color: Colors.white, letterSpacing: 1.5)),
              ),
              const Spacer(),
              const Text('✝️', style: TextStyle(fontSize: 36)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Who is Jesus?',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Jesus is the Son of God who came to earth to love us,\nteach us, and save us. He is our best friend!',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: Colors.white.withAlpha(220), height: 1.5)),
          const SizedBox(height: 16),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Journey Progress',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70)),
                  Text('3 of 5 topics',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.white.withAlpha(50),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  final Color textColor;
  final BorderRadius radius;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.textColor,
    required this.radius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: color, borderRadius: radius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w900, color: textColor, height: 1.2)),
          const SizedBox(height: 6),
          Text('Tap to learn more',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10, color: textColor.withAlpha(180))),
        ],
      ),
    ));
  }
}

// ── Miracles card ─────────────────────────────────────────────────────────────

class _MiraclesCard extends StatelessWidget {
  final void Function(BuildContext, String, String, String) onMiracleTap;
  const _MiraclesCard({required this.onMiracleTap});

  @override
  Widget build(BuildContext context) {
    final miracles = [
      ('⛈️', 'Storms', 'Calming the Storm',
        'One evening, Jesus and His disciples got into a boat. A huge storm arose and the waves crashed into the boat. The disciples were terrified! But Jesus stood up and said, "Quiet! Be still!" — and the wind stopped and the sea became completely calm.\n\n📖 Mark 4:39 — "He said to the waves, \'Quiet! Be still!\' Then the wind died down and it was completely calm."'),
      ('🤲', 'Healing', 'Healing the Sick',
        'Jesus healed many people who were sick. He touched a man with leprosy and made him clean. He healed blind people, helped people walk who could not walk, and even raised people from the dead! Jesus showed us that He cares about our pain and has power over sickness.\n\n📖 Matthew 4:23 — "Jesus went throughout Galilee, healing every disease and sickness among the people."'),
      ('🐟', 'Feeding 5,000', 'Feeding the Multitude',
        'A crowd of over 5,000 people had been listening to Jesus all day and were hungry. A boy gave Jesus 5 loaves of bread and 2 fish. Jesus looked up to heaven, gave thanks, and broke the loaves. His disciples gave the food to the people — and everyone ate until they were full! There were even 12 baskets of leftovers!\n\n📖 John 6:11 — "Jesus gave thanks and distributed to those who were seated as much as they wanted."'),
      ('👁️', 'Sight', 'Giving Sight to the Blind',
        'A blind man named Bartimaeus heard that Jesus was nearby. He cried out, "Jesus, Son of David, have mercy on me!" Jesus stopped and asked, "What do you want me to do for you?" He said, "Teacher, I want to see!" Jesus said, "Go, your faith has healed you." Immediately he could see!\n\n📖 Mark 10:52 — "Your faith has healed you." Immediately he received his sight."'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: kKidsSurfaceContLowest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Miracles of Jesus',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16, fontWeight: FontWeight.w900, color: kKidsOnSurface)),
                    const SizedBox(height: 4),
                    Text('Jesus performed amazing wonders!',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: kKidsOnSurfaceVariant)),
                  ],
                ),
              ),
              const Text('🧺', style: TextStyle(fontSize: 32)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: miracles.map((m) {
              return GestureDetector(
                onTap: () => onMiracleTap(context, m.$1, m.$3, m.$4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: kKidsPrimaryContainer.withAlpha(30),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: kKidsPrimaryContainer.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.$1, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(m.$2,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12, fontWeight: FontWeight.w700, color: kKidsPrimary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
