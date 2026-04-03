import 'package:flutter/material.dart';
import 'kids_home_screen.dart';
import 'watch_stories_screen.dart';
import 'quiz_time_screen.dart';

class KnowJesusScreen extends StatelessWidget {
  const KnowJesusScreen({super.key});

  static const kPrimary = Color(0xFFA53500);
  static const kPrimaryContainer = Color(0xFFFF7947);
  static const kSurface = Color(0xFFF5F6F7);
  static const kSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const kOnSurface = Color(0xFF2C2F30);
  static const kOnSurfaceVariant = Color(0xFF595C5D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      bottomNavigationBar: _KidsBottomNav(activeIndex: kKidsTabKnowJesus),
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white.withOpacity(0.9),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: kOnSurface, size: 20),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: const Text(
              'Know Jesus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero
                _buildHero(),
                const SizedBox(height: 28),
                // Section label
                const Text(
                  'EXPLORE HIS STORY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: kOnSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                // Asymmetric card layout
                _buildAsymmetricCards(context),
                const SizedBox(height: 28),
                // CTA Quiz button
                _buildQuizCTA(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1040), Color(0xFF3B1F7A)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B1F7A).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '✨  LUMINA KIDS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Who is\nJesus? 🕊️',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jesus is God\'s Son who came to earth to love us, teach us, and save us. Discover His amazing story!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('📖', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                'John 3:16 • Luke 2 • Matthew 5',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAsymmetricCards(BuildContext context) {
    return Column(
      children: [
        // Large card
        _JesusCard(
          emoji: '👦',
          title: 'Jesus as a Child',
          body:
              'Did you know Jesus was once your age? He grew up in Nazareth, helped his father Joseph, and even amazed teachers at the Temple when he was only 12!',
          gradientColors: const [Color(0xFF0D6EFD), Color(0xFF0DCAF0)],
          topLeft: 28,
          bottomRight: 28,
        ),
        const SizedBox(height: 14),
        // Two smaller side-by-side
        Row(
          children: [
            Expanded(
              child: _JesusCard(
                emoji: '❤️',
                title: 'Jesus Loves Kids',
                body:
                    '"Let the little children come to me." — Matthew 19:14',
                gradientColors: const [Color(0xFFE91E63), Color(0xFFFF5722)],
                topRight: 24,
                bottomLeft: 24,
                compact: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _JesusCard(
                emoji: '⚡',
                title: 'The Miracles',
                body:
                    'Water into wine, healing the sick, walking on water — Jesus did the impossible!',
                gradientColors: const [Color(0xFF306800), Color(0xFF4CAF50)],
                topLeft: 24,
                bottomRight: 24,
                compact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizCTA(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const QuizTimeScreen()),
        (r) => false,
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimary, kPrimaryContainer],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🎯', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Test Your Knowledge!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Take the Jesus Quiz and earn stars ⭐',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

class _JesusCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;
  final List<Color> gradientColors;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final bool compact;

  const _JesusCard({
    required this.emoji,
    required this.title,
    required this.body,
    required this.gradientColors,
    this.topLeft = 12,
    this.topRight = 12,
    this.bottomLeft = 12,
    this.bottomRight = 12,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji,
              style: TextStyle(fontSize: compact ? 28 : 36)),
          SizedBox(height: compact ? 10 : 14),
          Text(
            title,
            style: TextStyle(
              fontSize: compact ? 13 : 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: compact ? 6 : 10),
          Text(
            body,
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Kids Bottom Nav ─────────────────────────────────────────────────────

class _KidsBottomNav extends StatelessWidget {
  final int activeIndex;
  const _KidsBottomNav({required this.activeIndex});

  void _onTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    Widget dest;
    switch (index) {
      case kKidsTabHome:
        dest = const KidsHomeScreen();
        break;
      case kKidsTabWatch:
        dest = const WatchStoriesScreen();
        break;
      case kKidsTabKnowJesus:
        dest = const KnowJesusScreen();
        break;
      case kKidsTabQuiz:
        dest = const QuizTimeScreen();
        break;
      default:
        return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => dest),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _KidsTab(Icons.home_rounded, 'Home'),
      _KidsTab(Icons.play_circle_rounded, 'Watch'),
      _KidsTab(Icons.auto_awesome_rounded, 'Know Jesus'),
      _KidsTab(Icons.extension_rounded, 'Quiz'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isActive = activeIndex == i;
              return GestureDetector(
                onTap: () => _onTap(context, i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFFF7947).withOpacity(0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tabs[i].icon,
                        size: 22,
                        color: isActive
                            ? const Color(0xFFA53500)
                            : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tabs[i].label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isActive
                              ? const Color(0xFFA53500)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _KidsTab {
  final IconData icon;
  final String label;
  _KidsTab(this.icon, this.label);
}
