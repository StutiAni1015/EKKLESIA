import 'package:flutter/material.dart';
import 'kids_home_screen.dart';
import 'know_jesus_screen.dart';
import 'quiz_time_screen.dart';

class WatchStoriesScreen extends StatelessWidget {
  const WatchStoriesScreen({super.key});

  static const kPrimary = Color(0xFFA53500);
  static const kPrimaryContainer = Color(0xFFFF7947);
  static const kSecondary = Color(0xFF006289);
  static const kSurface = Color(0xFFF5F6F7);
  static const kSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const kOnSurface = Color(0xFF2C2F30);
  static const kOnSurfaceVariant = Color(0xFF595C5D);

  static const _stories = [
    _Story('The Good Samaritan', 'A lesson about kindness and love for neighbours.', '6:12', '💛'),
    _Story('Noah\'s Ark', 'Join Noah and the animals on a journey of trust and new beginnings.', '10:30', '🌈'),
    _Story('Moses & The Red Sea', 'Watch the waters part in this amazing story of freedom and courage.', '12:15', '🌊'),
    _Story('Queen Esther\'s Courage', 'A brave queen risks everything to save her people. Truly inspiring!', '9:40', '👑'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      bottomNavigationBar: _KidsBottomNav(activeIndex: kKidsTabWatch),
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
              'Watch Stories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kPrimary,
                letterSpacing: -0.3,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: kOnSurface),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video search coming soon!'), behavior: SnackBarBehavior.floating)),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Featured Hero
                _buildFeaturedHero(context),
                const SizedBox(height: 28),
                const Text(
                  'MORE STORIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: kOnSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                // Story grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: _stories.length,
                  itemBuilder: (ctx, i) => _buildStoryCard(ctx, _stories[i]),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedHero(BuildContext context) {
    return GestureDetector(
      onTap: () => _showComingSoon(context),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(28),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2C3A), Color(0xFF2D4A2E)],
          ),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative stars
            Positioned(
              top: 20,
              right: 30,
              child: Text('⭐', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.4))),
            ),
            Positioned(
              top: 50,
              right: 70,
              child: Text('✨', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3))),
            ),
            // Play button center
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: kPrimaryContainer.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryContainer.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 40),
              ),
            ),
            // Bottom info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'FEATURED STORY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'David and Goliath 🪨',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'A small boy with big faith defeated a giant.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            // Duration badge
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '8:45',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, _Story story) {
    return GestureDetector(
      onTap: () => _showComingSoon(context),
      child: Container(
        decoration: BoxDecoration(
          color: kSurfaceContainerLowest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail area
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A2C3A),
                    const Color(0xFF2D4A2E).withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(story.emoji,
                        style: const TextStyle(fontSize: 40)),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        story.duration,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: kPrimary, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: kOnSurface,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: kOnSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video coming soon! 🎬'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _Story {
  final String title;
  final String description;
  final String duration;
  final String emoji;
  const _Story(this.title, this.description, this.duration, this.emoji);
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
