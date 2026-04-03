import 'package:flutter/material.dart';
import '../core/user_session.dart';
import '../core/app_colors.dart';
import 'know_jesus_screen.dart';
import 'watch_stories_screen.dart';
import 'quiz_time_screen.dart';

// ── Kids tab constants ────────────────────────────────────────────────────────
const kKidsTabHome = 0;
const kKidsTabWatch = 1;
const kKidsTabKnowJesus = 2;
const kKidsTabQuiz = 3;

class KidsHomeScreen extends StatefulWidget {
  const KidsHomeScreen({super.key});

  @override
  State<KidsHomeScreen> createState() => _KidsHomeScreenState();
}

class _KidsHomeScreenState extends State<KidsHomeScreen> {
  // Orange primary palette matching Lumina Kids design system
  static const kPrimary = Color(0xFFA53500);
  static const kPrimaryContainer = Color(0xFFFF7947);
  static const kSecondary = Color(0xFF006289);
  static const kSecondaryContainer = Color(0xFF9FD9FF);
  static const kTertiary = Color(0xFF306800);
  static const kTertiaryContainer = Color(0xFF9EEC69);
  static const kSurface = Color(0xFFF5F6F7);
  static const kSurfaceContainerLow = Color(0xFFEFF1F2);
  static const kSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const kOnSurface = Color(0xFF2C2F30);
  static const kOnSurfaceVariant = Color(0xFF595C5D);

  @override
  Widget build(BuildContext context) {
    final name = userNameNotifier.value.isNotEmpty
        ? userNameNotifier.value.split(' ').first
        : 'Explorer';

    return Scaffold(
      backgroundColor: kSurface,
      bottomNavigationBar: _KidsBottomNav(activeIndex: kKidsTabHome),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(name),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDailyStoryHero(context),
                const SizedBox(height: 28),
                _buildSectionLabel("Today's Journey"),
                const SizedBox(height: 16),
                _buildBentoGrid(context),
                const SizedBox(height: 28),
                _buildSectionLabel("New For You"),
                const SizedBox(height: 16),
                _buildNewForYou(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(String name) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.06),
      titleSpacing: 20,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [kPrimaryContainer, kPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name! 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Text(
                "Let's learn about God today",
                style: TextStyle(
                  fontSize: 11,
                  color: kOnSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: kTertiaryContainer.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.stars_rounded, color: kTertiary, size: 16),
              SizedBox(width: 4),
              Text(
                '120',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: kTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyStoryHero(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bible Stories coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
      child: Container(
        height: 200,
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
            colors: [Color(0xFF1A3A5C), Color(0xFF2D6A4F)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryContainer.withOpacity(0.15),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kPrimaryContainer.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TODAY\'S STORY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jesus Feeds\n5,000 People! 🐟🍞',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'John 6:1-14 • A miracle of love and sharing',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPrimaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Read Story →',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('5 min read',
                          style: TextStyle(
                              fontSize: 11, color: Colors.white54)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        color: kOnSurfaceVariant,
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.1,
      children: [
        _BentoCard(
          emoji: '🎬',
          title: 'Watch Stories',
          subtitle: 'Bible videos',
          gradient: const [Color(0xFF006289), Color(0xFF0094CC)],
          topLeft: 28,
          bottomRight: 28,
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WatchStoriesScreen()),
            (r) => false,
          ),
        ),
        _BentoCard(
          emoji: '📖',
          title: 'Learn Scripture',
          subtitle: 'Memory verses',
          gradient: const [Color(0xFF306800), Color(0xFF4CAF50)],
          topRight: 28,
          bottomLeft: 28,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scripture memory coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
        ),
        _BentoCard(
          emoji: '✨',
          title: 'Know Jesus',
          subtitle: 'Who is Jesus?',
          gradient: const [Color(0xFF7B4F9E), Color(0xFF9C6DC0)],
          topLeft: 28,
          bottomRight: 28,
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const KnowJesusScreen()),
            (r) => false,
          ),
        ),
        _BentoCard(
          emoji: '🎯',
          title: 'Quiz Time',
          subtitle: 'Test your faith!',
          gradient: const [Color(0xFFA53500), Color(0xFFFF7947)],
          topRight: 28,
          bottomLeft: 28,
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const QuizTimeScreen()),
            (r) => false,
          ),
        ),
      ],
    );
  }

  Widget _buildNewForYou(BuildContext context) {
    final items = [
      _NewItem('🌊', 'Moses & The Red Sea', 'Exodus 14', '8 min'),
      _NewItem('🦁', 'Daniel in the Lions Den', 'Daniel 6', '6 min'),
      _NewItem('⭐', 'The Star of Bethlehem', 'Matthew 2', '5 min'),
    ];

    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
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
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kSurfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(item.emoji,
                      style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kOnSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.reference} • ${item.duration}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: kOnSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kPrimaryContainer.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: kPrimary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── BentoCard ─────────────────────────────────────────────────────────────────

class _BentoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final VoidCallback onTap;

  const _BentoCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.topLeft = 12,
    this.topRight = 12,
    this.bottomLeft = 12,
    this.bottomRight = 12,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
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

class _NewItem {
  final String emoji;
  final String title;
  final String reference;
  final String duration;
  const _NewItem(this.emoji, this.title, this.reference, this.duration);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
