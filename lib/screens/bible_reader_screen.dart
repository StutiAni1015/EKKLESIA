import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String _version = 'WEB';
  bool _isBookmarked = false;
  bool _showHighlightInfo = false;
  bool _loading = true;
  String? _error;
  String _chapterTitle = '';
  List<(int, String, bool)> _verses = [];

  static const _versions = ['WEB', 'KJV', 'BBE', 'OEB', 'Darby'];
  static const _translationCodes = {
    'WEB': 'web', 'KJV': 'kjv', 'BBE': 'bbe', 'OEB': 'oeb', 'Darby': 'darby',
  };

  @override
  void initState() {
    super.initState();
    _fetchChapter();
  }

  // Maps full book names to the slug bible-api.com expects.
  static const _slugOverrides = {
    'song of solomon': 'song+of+songs',
    'psalms': 'psalms',
    '1 chronicles': '1+chronicles',
    '2 chronicles': '2+chronicles',
    '1 thessalonians': '1+thessalonians',
    '2 thessalonians': '2+thessalonians',
    '1 timothy': '1+timothy',
    '2 timothy': '2+timothy',
    '1 corinthians': '1+corinthians',
    '2 corinthians': '2+corinthians',
    '1 samuel': '1+samuel',
    '2 samuel': '2+samuel',
    '1 kings': '1+kings',
    '2 kings': '2+kings',
    '1 peter': '1+peter',
    '2 peter': '2+peter',
    '1 john': '1+john',
    '2 john': '2+john',
    '3 john': '3+john',
    'philemon': 'philemon',
  };

  String _bookSlug(String book) {
    final lower = book.toLowerCase();
    return _slugOverrides[lower] ?? lower.replaceAll(' ', '+');
  }

  Future<void> _fetchChapter() async {
    setState(() { _loading = true; _error = null; });
    try {
      final slug = _bookSlug(widget.bookName);
      final code = _translationCodes[_version] ?? 'web';
      final url = Uri.parse(
          'https://bible-api.com/$slug+${widget.chapter}?translation=$code');
      final r = await http.get(url).timeout(const Duration(seconds: 15));
      if (r.statusCode != 200) throw 'Server error ${r.statusCode}';
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      final raw = data['verses'] as List<dynamic>;
      setState(() {
        _chapterTitle = data['reference']?.toString() ?? '';
        _verses = raw.map<(int, String, bool)>((v) {
          final m = v as Map<String, dynamic>;
          return (
            (m['verse'] as num?)?.toInt() ?? 0,
            (m['text']?.toString() ?? '').trim(),
            false,
          );
        }).toList();
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

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
                                    _version == 'WEB' ? 'World English Bible (WEB)'
                                      : _version == 'KJV' ? 'King James Version (KJV)'
                                      : _version == 'BBE' ? 'Bible in Basic English (BBE)'
                                      : _version,
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
                              onTap: () {
                                setState(() => _version = v);
                                _fetchChapter();
                              },
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
                  child: _loading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : _error != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.wifi_off, size: 48, color: subColor),
                                    const SizedBox(height: 12),
                                    Text('Could not load chapter', style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    Text('Check your connection and try again.', style: TextStyle(color: subColor, fontSize: 13)),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _fetchChapter,
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
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
                  offset: const Offset(0, -12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
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
                          fontSize: 8,
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
