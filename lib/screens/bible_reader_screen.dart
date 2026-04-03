import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BibleReaderScreen extends StatefulWidget {
  final String bookName;
  final int chapter;

  const BibleReaderScreen({
    super.key,
    required this.bookName,
    required this.chapter,
  });

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  String _version = 'NIV';
  bool _isBookmarked = false;
  bool _showHighlightInfo = false;

  static const _versions = ['NIV', 'ESV', 'KJV', 'NLT', 'Message'];

  // Scripture data for John 1
  static const _chapterTitle = 'The Word Became Flesh';
  static const _verses = [
    (
      1,
      'In the beginning was the Word, and the Word was with God, and the Word was God.',
      false
    ),
    (2, 'He was with God in the beginning.', false),
    (
      3,
      'Through him all things were made; without him nothing was made that has been made.',
      false
    ),
    (
      4,
      'In him was life, and that life was the light of all mankind.',
      false
    ),
    (
      5,
      'The light shines in the darkness, and the darkness has not overcome it.',
      true // highlighted
    ),
    (
      6,
      'There was a man sent from God whose name was John.',
      false
    ),
    (
      7,
      'He came as a witness to testify concerning that light, so that through him all might believe.',
      false
    ),
    (
      8,
      'He himself was not the light; he came only as a witness to the light.',
      false
    ),
    (
      9,
      'The true light that gives light to everyone was coming into the world.',
      false
    ),
    (10, 'He was in the world, and though the world was made through him, the world did not recognize him.', false),
    (11, 'He came to that which was his own, but his own did not receive him.', false),
    (12, 'Yet to all who did receive him, to those who believed in his name, he gave the right to become children of God.', false),
    (13, 'Children born not of natural descent, nor of human decision or a husband\'s will, but born of God.', false),
    (14, 'The Word became flesh and made his dwelling among us. We have seen his glory, the glory of the one and only Son, who came from the Father, full of grace and truth.', false),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final bodyTextColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151);
    final reflectionBg = isDark
        ? AppColors.primary.withOpacity(0.07)
        : const Color(0xFFFDFBF7).withOpacity(0.8);
    final reflectionBorder =
        isDark ? AppColors.primary.withOpacity(0.12) : const Color(0xFFE4C9B6).withOpacity(0.5);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  color: bg.withOpacity(0.9),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: textColor, size: 20),
                              onPressed: () =>
                                  Navigator.maybePop(context),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${widget.bookName} ${widget.chapter}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.2,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    'New International Version (NIV)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: subColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.settings_outlined,
                                  color: textColor, size: 22),
                              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reading settings coming soon!'),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Version tabs
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          itemCount: _versions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 4),
                          itemBuilder: (ctx, i) {
                            final v = _versions[i];
                            final active = _version == v;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _version = v),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: active
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  v,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: active
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: active
                                        ? AppColors.primary
                                        : subColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(
                          height: 1,
                          color: AppColors.primary.withOpacity(0.1)),
                    ],
                  ),
                ),

                // Scripture body
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        24,
                        24,
                        24,
                        MediaQuery.of(context).padding.bottom + 120),
                    child: Column(
                      children: [
                        // Chapter title
                        Text(
                          _chapterTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Scripture text
                        _ScriptureBlock(
                          verses: _verses,
                          bodyColor: bodyTextColor,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 40),

                        // Reflections section
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: reflectionBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: reflectionBorder),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.edit_note,
                                      color: const Color(0xFFD7A49A),
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'My Reflections',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Today, 9:41 AM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      color: subColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'The concept of the Word being both with God and being God is profound. It reminds me of the creative power of speech and intention...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  height: 1.6,
                                  color: subColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating action buttons (right side)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 90,
              right: 20,
              child: Column(
                children: [
                  // Highlight
                  _FloatBtn(
                    icon: Icons.brush_outlined,
                    onTap: () => setState(
                        () => _showHighlightInfo = !_showHighlightInfo),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  // Bookmark
                  _FloatBtn(
                    icon: _isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    iconColor:
                        _isBookmarked ? AppColors.primary : null,
                    onTap: () =>
                        setState(() => _isBookmarked = !_isBookmarked),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  // Share
                  _FloatBtn(
                    icon: Icons.share,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share coming soon!'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                    isDark: isDark,
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        color: isDark
            ? AppColors.backgroundDark.withOpacity(0.97)
            : Colors.white.withOpacity(0.97),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    active: false,
                    color: subColor),
                _NavItem(
                    icon: Icons.volunteer_activism_outlined,
                    label: 'Pray',
                    active: false,
                    color: subColor),
                // Elevated Bible FAB
                Transform.translate(
                  offset: const Offset(0, -16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.backgroundDark
                                : const Color(0xFFF8F6F6),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.auto_stories,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'BIBLE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                _NavItem(
                    icon: Icons.group_outlined,
                    label: 'Groups',
                    active: false,
                    color: subColor),
                _NavItem(
                    icon: Icons.account_circle_outlined,
                    label: 'Profile',
                    active: false,
                    color: subColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Scripture block ─────────────────────────────────────────────

class _ScriptureBlock extends StatelessWidget {
  final List<(int, String, bool)> verses;
  final Color bodyColor;
  final bool isDark;

  const _ScriptureBlock({
    required this.verses,
    required this.bodyColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Group verses into paragraphs (every 2-3 verses)
    final paragraphs = <List<(int, String, bool)>>[];
    var current = <(int, String, bool)>[];
    for (var i = 0; i < verses.length; i++) {
      current.add(verses[i]);
      if ((i + 1) % 3 == 0 || i == verses.length - 1) {
        paragraphs.add(List.from(current));
        current = [];
      }
    }

    return Column(
      children: paragraphs.map((para) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                height: 1.8,
                color: bodyColor,
                fontFamily: 'PublicSans',
              ),
              children: para.map((v) {
                final span = TextSpan(
                  children: [
                    TextSpan(
                      text: '${v.$1} ',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: '${v.$2} ',
                      style: v.$3
                          ? TextStyle(
                              backgroundColor:
                                  Colors.yellow.withOpacity(0.35),
                            )
                          : null,
                    ),
                  ],
                );
                return span;
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Floating button ─────────────────────────────────────────────

class _FloatBtn extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool isDark;
  final bool isPrimary;

  const _FloatBtn({
    required this.icon,
    this.iconColor,
    required this.onTap,
    required this.isDark,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          shape: BoxShape.circle,
          border: isPrimary
              ? null
              : Border.all(
                  color: const Color(0xFFE4C9B6).withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary
              ? Colors.white
              : (iconColor ??
                  (isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569))),
        ),
      ),
    );
  }
}

// ─── Nav item ────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color color;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: active ? AppColors.primary : color, size: 24),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: active ? AppColors.primary : color,
          ),
        ),
      ],
    );
  }
}
