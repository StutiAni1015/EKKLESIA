import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kids_home_screen.dart';

class WatchStoriesScreen extends StatelessWidget {
  final Map<String, dynamic>? child;
  const WatchStoriesScreen({super.key, this.child});

  static const _stories = [
    _Story('The Good Samaritan',      'A lesson about kindness and love for neighbours.',                    '6:12',  '💛'),
    _Story('Noah\'s Ark',             'Join Noah and the animals on a journey of trust and new beginnings.', '10:30', '🌈'),
    _Story('Moses & The Red Sea',     'Watch the waters part in this amazing story of freedom and courage.', '12:15', '🌊'),
    _Story('Queen Esther\'s Courage', 'A brave queen risks everything to save her people. Truly inspiring!', '9:40',  '👑'),
  ];

  @override
  Widget build(BuildContext context) {
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
                        MaterialPageRoute(builder: (_) => KidsHomeScreen(child: child))),
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
                    child: Text('Watch Stories 🎬',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 18, fontWeight: FontWeight.w900, color: kKidsPrimary)),
                  ),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Search coming soon!'), behavior: SnackBarBehavior.floating)),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: kKidsSurfaceContLowest,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.search_rounded, size: 20, color: kKidsPrimary),
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
                    _FeaturedHero(onTap: () => _showComingSoon(context)),
                    const SizedBox(height: 28),
                    Text('MORE STORIES',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, fontWeight: FontWeight.w900,
                            letterSpacing: 1.2, color: kKidsOnSurfaceVariant)),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.82,
                      ),
                      itemCount: _stories.length,
                      itemBuilder: (_, i) => _StoryCard(story: _stories[i], onTap: () => _showComingSoon(context)),
                    ),
                  ],
                ),
              ),
            ),

            KidsBottomNav(activeIndex: kKidsTabWatch, child: child),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video coming soon! 🎬'),
          behavior: SnackBarBehavior.floating, duration: Duration(seconds: 2)),
    );
  }
}

// ── Featured hero ─────────────────────────────────────────────────────────────

class _FeaturedHero extends StatelessWidget {
  final VoidCallback onTap;
  const _FeaturedHero({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(40),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF1A2C3A), Color(0xFF2D4A2E)],
          ),
          boxShadow: [BoxShadow(color: kKidsPrimary.withAlpha(50), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20, right: 30,
              child: Text('⭐', style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(100))),
            ),
            Positioned(
              top: 50, right: 70,
              child: Text('✨', style: TextStyle(fontSize: 10, color: Colors.white.withAlpha(76))),
            ),
            Center(
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: kKidsPrimaryContainer.withAlpha(230),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: kKidsPrimaryContainer.withAlpha(128), blurRadius: 20, spreadRadius: 4)],
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    colors: [Colors.black.withAlpha(190), Colors.transparent],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16), bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kKidsSecondary, borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('FEATURED STORY',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 9, fontWeight: FontWeight.w900,
                              color: Colors.white, letterSpacing: 1.0)),
                    ),
                    const SizedBox(height: 6),
                    Text('David and Goliath 🪨',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 22, fontWeight: FontWeight.w900,
                            color: Colors.white, letterSpacing: -0.4)),
                    const SizedBox(height: 4),
                    Text('A small boy with big faith defeated a giant.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14, right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(128), borderRadius: BorderRadius.circular(8),
                ),
                child: Text('8:45',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Story card ────────────────────────────────────────────────────────────────

class _StoryCard extends StatelessWidget {
  final _Story story;
  final VoidCallback onTap;
  const _StoryCard({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kKidsSurfaceContLowest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF1A2C3A), Color(0xFF2D4A2E)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28), topRight: Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Center(child: Text(story.emoji, style: const TextStyle(fontSize: 40))),
                  Positioned(
                    bottom: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(153), borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(story.duration,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(217), shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: kKidsPrimary, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, fontWeight: FontWeight.w800,
                          color: kKidsOnSurface, letterSpacing: -0.2),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(story.description,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: kKidsOnSurfaceVariant, height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _Story {
  final String title;
  final String description;
  final String duration;
  final String emoji;
  const _Story(this.title, this.description, this.duration, this.emoji);
}
