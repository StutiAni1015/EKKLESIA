import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/user_session.dart';
import 'know_jesus_screen.dart';
import 'watch_stories_screen.dart';
import 'quiz_time_screen.dart';
import 'kids_daily_bread_screen.dart';

// ── Tab index constants ───────────────────────────────────────────────────────
const kKidsTabHome      = 0;
const kKidsTabWatch     = 1;
const kKidsTabKnowJesus = 2;
const kKidsTabQuiz      = 3;

// ── Design tokens ─────────────────────────────────────────────────────────────
const kKidsPrimary            = Color(0xFFA53500);
const kKidsPrimaryContainer   = Color(0xFFFF7947);
const kKidsSecondary          = Color(0xFF006289);
const kKidsSecondaryContainer = Color(0xFF9FD9FF);
const kKidsTertiary           = Color(0xFF306800);
const kKidsTertiaryContainer  = Color(0xFF9EEC69);
const kKidsError              = Color(0xFFB31B25);
const kKidsErrorContainer     = Color(0xFFFB5151);
const kKidsSurface            = Color(0xFFF5F6F7);
const kKidsSurfaceContLow     = Color(0xFFEFF1F2);
const kKidsSurfaceContHigh    = Color(0xFFE0E3E4);
const kKidsSurfaceContLowest  = Color(0xFFFFFFFF);
const kKidsOnSurface          = Color(0xFF2C2F30);
const kKidsOnSurfaceVariant   = Color(0xFF595C5D);
const kKidsOnSecondaryContainer = Color(0xFF004D6C);
const kKidsOnTertiaryContainer  = Color(0xFF265600);
const kKidsOnErrorContainer     = Color(0xFF570008);

class KidsHomeScreen extends StatefulWidget {
  final Map<String, dynamic>? child;
  const KidsHomeScreen({super.key, this.child});

  @override
  State<KidsHomeScreen> createState() => _KidsHomeScreenState();
}

class _KidsHomeScreenState extends State<KidsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final childName   = widget.child?['name']         as String?;
    final childEmoji  = widget.child?['avatarEmoji']  as String? ?? '🧒';
    final childPoints = widget.child?['totalPoints']  as int?    ?? 0;
    final name = childName?.isNotEmpty == true
        ? childName!
        : (userNameNotifier.value.isNotEmpty
            ? userNameNotifier.value.split(' ').first
            : 'Storyteller');

    return Scaffold(
      backgroundColor: kKidsSurface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(name, childEmoji, childPoints),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDailyStoryHero(context),
                const SizedBox(height: 32),
                _sectionLabel('Today\'s Modules'),
                const SizedBox(height: 16),
                _buildBentoGrid(context),
                const SizedBox(height: 32),
                _sectionLabel('New For You'),
                const SizedBox(height: 4),
                _buildNewRow(),
                const SizedBox(height: 4),
                _buildNewRow2(),
                const SizedBox(height: 4),
                _buildNewRow3(),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: KidsBottomNav(activeIndex: kKidsTabHome, child: widget.child),
    );
  }

  // ── App bar ─────────────────────────────────────────────────────────────────
  SliverAppBar _buildAppBar(String name, String emoji, int points) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: kKidsSurfaceContLowest.withAlpha(204),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black.withAlpha(13),
      titleSpacing: 20,
      leadingWidth: 60,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: kKidsSurfaceContLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kKidsPrimary),
          ),
        ),
      ),
      title: Row(
        children: [
          // Child avatar circle
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kKidsPrimaryContainer, width: 2),
              color: kKidsPrimaryContainer.withAlpha(30),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Text(
            'Hi, $name!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w800,
              color: kKidsPrimary, letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        // Points chip
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: kKidsTertiaryContainer.withAlpha(90),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: kKidsTertiary, size: 16),
              const SizedBox(width: 4),
              Text('$points',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800, fontSize: 13, color: kKidsTertiary)),
            ],
          ),
        ),
        // Notification bell
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: kKidsSurfaceContLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_outlined, color: kKidsOnSurface, size: 20),
          ),
        ),
      ],
    );
  }

  // ── Daily story hero ────────────────────────────────────────────────────────
  Widget _buildDailyStoryHero(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KidsDailyBreadScreen()),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            // Image area with gradient overlay
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A3A5C), Color(0xFF2D6A4F)],
                    ),
                  ),
                  child: const Center(
                    child: Text('🌊⛵🌈', style: TextStyle(fontSize: 64)),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20, left: 20, right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kKidsPrimaryContainer,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text('THE DAILY STORY',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 9, fontWeight: FontWeight.w900,
                                color: Colors.white, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 8),
                      Text("Noah's Big Adventure",
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 22, fontWeight: FontWeight.w900,
                              color: Colors.white, height: 1.1)),
                    ],
                  ),
                ),
              ],
            ),
            // Progress bar row
            Container(
              color: kKidsSurfaceContLowest,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: 0.65,
                            minHeight: 8,
                            backgroundColor: kKidsSurfaceContHigh,
                            valueColor: const AlwaysStoppedAnimation<Color>(kKidsPrimaryContainer),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('65% OF STORY COMPLETED',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, fontWeight: FontWeight.w700,
                                color: kKidsOnSurfaceVariant, letterSpacing: 0.8)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kKidsPrimary, kKidsPrimaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: kKidsPrimary.withAlpha(80), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bento grid ───────────────────────────────────────────────────────────────
  Widget _buildBentoGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: [
        _BentoCard(
          emoji: '🎬',
          title: 'Watch',
          subtitle: 'Bible Adventures',
          bg: kKidsSecondaryContainer,
          titleColor: kKidsOnSecondaryContainer,
          subtitleColor: kKidsSecondary,
          topLeft: 48,
          onTap: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => WatchStoriesScreen(child: widget.child)), (r) => false),
        ),
        _BentoCard(
          emoji: '📖',
          title: 'Learn Scripture',
          subtitle: 'Daily Verses',
          bg: kKidsTertiaryContainer,
          titleColor: kKidsOnTertiaryContainer,
          subtitleColor: kKidsTertiary,
          topRight: 48,
          onTap: () {},
        ),
        _BentoCard(
          emoji: '✨',
          title: 'Know Jesus',
          subtitle: 'His Miracles',
          bg: kKidsSurfaceContLowest,
          titleColor: kKidsOnSurface,
          subtitleColor: kKidsOnSurfaceVariant,
          hasShadow: true,
          topLeft: 48,
          bottomRight: 48,
          topRight: 16,
          bottomLeft: 16,
          onTap: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => KnowJesusScreen(child: widget.child)), (r) => false),
        ),
        _BentoCard(
          emoji: '🎯',
          title: 'Quiz Time',
          subtitle: 'Earn Badges',
          bg: kKidsErrorContainer,
          titleColor: kKidsOnErrorContainer,
          subtitleColor: kKidsOnErrorContainer.withAlpha(178),
          topRight: 48,
          onTap: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => QuizTimeScreen(child: widget.child)), (r) => false),
        ),
      ],
    );
  }

  // ── New For You rows ─────────────────────────────────────────────────────────
  Widget _buildNewRow() => _NewForYouCard(emoji: '🐑', title: 'The Good Shepherd',
      ref: 'John 10:11', duration: '5 min',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KidsDailyBreadScreen())));
  Widget _buildNewRow2() => _NewForYouCard(emoji: '🌊', title: 'Moses & The Red Sea',
      ref: 'Exodus 14', duration: '8 min',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KidsDailyBreadScreen())));
  Widget _buildNewRow3() => _NewForYouCard(emoji: '⭐', title: 'The Star of Bethlehem',
      ref: 'Matthew 2', duration: '5 min',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KidsDailyBreadScreen())));

  Widget _sectionLabel(String text) => Text(
    text,
    style: GoogleFonts.plusJakartaSans(
        fontSize: 12, fontWeight: FontWeight.w900,
        letterSpacing: 1.2, color: kKidsOnSurfaceVariant),
  );
}

// ── Bento card ────────────────────────────────────────────────────────────────
class _BentoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bg;
  final Color titleColor;
  final Color subtitleColor;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final bool hasShadow;
  final VoidCallback onTap;

  const _BentoCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.titleColor,
    required this.subtitleColor,
    this.topLeft = 16,
    this.topRight = 16,
    this.bottomLeft = 16,
    this.bottomRight = 16,
    this.hasShadow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeft),
              topRight: Radius.circular(topRight),
              bottomLeft: Radius.circular(bottomLeft),
              bottomRight: Radius.circular(bottomRight),
            ),
            boxShadow: hasShadow
                ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.w800,
                          color: titleColor, letterSpacing: -0.2)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, fontWeight: FontWeight.w500,
                          color: subtitleColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── New For You card ──────────────────────────────────────────────────────────
class _NewForYouCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String ref;
  final String duration;
  final VoidCallback? onTap;
  const _NewForYouCard({required this.emoji, required this.title, required this.ref, required this.duration, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kKidsSurfaceContLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: kKidsSurfaceContLow, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w700, color: kKidsOnSurface)),
                const SizedBox(height: 2),
                Text('$ref • $duration',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, fontWeight: FontWeight.w500, color: kKidsOnSurfaceVariant)),
              ],
            ),
          ),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: kKidsPrimaryContainer.withAlpha(30), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: kKidsPrimary),
          ),
        ],
      ),
    ));
  }
}

// ── Shared Kids Bottom Nav ────────────────────────────────────────────────────
class KidsBottomNav extends StatelessWidget {
  final int activeIndex;
  final Map<String, dynamic>? child;
  const KidsBottomNav({super.key, required this.activeIndex, this.child});

  void _onTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    Widget dest;
    switch (index) {
      case kKidsTabHome:      dest = KidsHomeScreen(child: child);       break;
      case kKidsTabWatch:     dest = WatchStoriesScreen(child: child);   break;
      case kKidsTabKnowJesus: dest = KnowJesusScreen(child: child);     break;
      case kKidsTabQuiz:      dest = QuizTimeScreen(child: child);       break;
      default: return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => dest));
  }

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (Icons.home_rounded,        Icons.home_outlined,        'Home'),
      (Icons.play_circle_rounded, Icons.play_circle_outline,  'Watch'),
      (Icons.auto_awesome_rounded,Icons.auto_awesome_outlined,'Know Jesus'),
      (Icons.extension_rounded,   Icons.extension_outlined,   'Quiz'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: kKidsSurfaceContLowest.withAlpha(230),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 32, offset: const Offset(0, -6))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isActive = activeIndex == i;
              return GestureDetector(
                onTap: () => _onTap(context, i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? kKidsPrimaryContainer.withAlpha(50) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isActive ? tabs[i].$1 : tabs[i].$2,
                          size: 22, color: isActive ? kKidsPrimary : kKidsOnSurfaceVariant),
                      const SizedBox(height: 3),
                      Text(tabs[i].$3,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 9, fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: isActive ? kKidsPrimary : kKidsOnSurfaceVariant)),
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
