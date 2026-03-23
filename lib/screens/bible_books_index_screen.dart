import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'bible_selection_grid_screen.dart';

class BibleBooksIndexScreen extends StatefulWidget {
  const BibleBooksIndexScreen({super.key});

  @override
  State<BibleBooksIndexScreen> createState() =>
      _BibleBooksIndexScreenState();
}

class _BibleBooksIndexScreenState extends State<BibleBooksIndexScreen> {
  bool _isOldTestament = true;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Bible data ────────────────────────────────────────────────
  static const _otSections = [
    (
      'Pentateuch',
      [
        ('Genesis', 50, _sageC),
        ('Exodus', 40, _primaryC),
        ('Leviticus', 27, _blueC),
        ('Numbers', 36, _sageC),
        ('Deuteronomy', 34, _roseC),
      ]
    ),
    (
      'Historical Books',
      [
        ('Joshua', 24, _primaryC),
        ('Judges', 21, _sageC),
        ('Ruth', 4, _roseC),
        ('1 Samuel', 31, _blueC),
        ('2 Samuel', 24, _primaryC),
        ('1 Kings', 22, _sageC),
        ('2 Kings', 25, _roseC),
        ('Ezra', 10, _blueC),
        ('Nehemiah', 13, _primaryC),
        ('Esther', 10, _roseC),
      ]
    ),
    (
      'Poetry & Wisdom',
      [
        ('Job', 42, _sageC),
        ('Psalms', 150, _primaryC),
        ('Proverbs', 31, _roseC),
        ('Ecclesiastes', 12, _blueC),
        ('Song of Solomon', 8, _roseC),
      ]
    ),
    (
      'Major Prophets',
      [
        ('Isaiah', 66, _blueC),
        ('Jeremiah', 52, _primaryC),
        ('Lamentations', 5, _roseC),
        ('Ezekiel', 48, _sageC),
        ('Daniel', 12, _blueC),
      ]
    ),
    (
      'Minor Prophets',
      [
        ('Hosea', 14, _roseC),
        ('Joel', 3, _sageC),
        ('Amos', 9, _primaryC),
        ('Micah', 7, _blueC),
        ('Malachi', 4, _roseC),
      ]
    ),
  ];

  static const _ntSections = [
    (
      'The Gospels',
      [
        ('Matthew', 28, _primaryC),
        ('Mark', 16, _blueC),
        ('Luke', 24, _sageC),
        ('John', 21, _roseC),
      ]
    ),
    (
      'Acts & Letters',
      [
        ('Acts', 28, _primaryC),
        ('Romans', 16, _blueC),
        ('1 Corinthians', 16, _sageC),
        ('2 Corinthians', 13, _roseC),
        ('Galatians', 6, _primaryC),
        ('Ephesians', 6, _blueC),
        ('Philippians', 4, _roseC),
        ('Colossians', 4, _sageC),
      ]
    ),
    (
      'General Letters',
      [
        ('Hebrews', 13, _primaryC),
        ('James', 5, _sageC),
        ('1 Peter', 5, _blueC),
        ('2 Peter', 3, _roseC),
        ('1 John', 5, _primaryC),
        ('Jude', 1, _sageC),
      ]
    ),
    (
      'Prophecy',
      [
        ('Revelation', 22, _roseC),
      ]
    ),
  ];

  // Color tokens used in data
  static const _sageC = Color(0xFF7A9482);
  static const _primaryC = AppColors.primary;
  static const _blueC = Color(0xFF60A5FA);
  static const _roseC = Color(0xFFD7A49A);

  List<(String, List<(String, int, Color)>)> get _activeSections =>
      _isOldTestament ? _otSections : _ntSections;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFEDE9E4);

    // Filter if searching
    final sections = _query.isEmpty
        ? _activeSections
        : _activeSections
            .map((s) => (
                  s.$1,
                  s.$2
                      .where((b) => b.$1
                          .toLowerCase()
                          .contains(_query.toLowerCase()))
                      .toList()
                ))
            .where((s) => s.$2.isNotEmpty)
            .toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sticky Header
            Container(
              color: bg.withOpacity(0.9),
              child: Column(
                children: [
                  // Top row
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu,
                              color: AppColors.primary, size: 20),
                        ),
                        Expanded(
                          child: Text(
                            'Holy Bible',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                              color: textColor,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_circle,
                              color: AppColors.primary, size: 20),
                        ),
                      ],
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        style:
                            TextStyle(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'Search books, chapters or verses',
                          hintStyle: TextStyle(
                              color: subColor, fontSize: 14),
                          prefixIcon: Icon(Icons.search,
                              color: AppColors.primary
                                  .withOpacity(0.6),
                              size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: inputBg,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  // OT / NT tabs
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Tab(
                        label: 'Old Testament',
                        active: _isOldTestament,
                        onTap: () =>
                            setState(() => _isOldTestament = true),
                      ),
                      _Tab(
                        label: 'New Testament',
                        active: !_isOldTestament,
                        onTap: () =>
                            setState(() => _isOldTestament = false),
                      ),
                    ],
                  ),
                  Divider(
                      height: 1,
                      color:
                          AppColors.primary.withOpacity(0.1)),
                ],
              ),
            ),

            // Book list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    MediaQuery.of(context).padding.bottom + 90),
                itemCount: sections.length,
                itemBuilder: (ctx, si) {
                  final section = sections[si];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (si > 0) const SizedBox(height: 24),
                      // Section heading
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          section.$1.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: subColor,
                          ),
                        ),
                      ),
                      // Book rows
                      ...section.$2.asMap().entries.map((entry) {
                        final i = entry.key;
                        final book = entry.value;
                        final bgColors = [
                          const Color(0xFFFDFBF7), // ivory
                          const Color(0xFFF2E8DF).withOpacity(0.4), // nude
                          const Color(0xFFD9E4F5).withOpacity(0.3), // baby blue
                          Colors.white,
                        ];
                        final rowBg = isDark
                            ? const Color(0xFF1E293B).withOpacity(0.5)
                            : bgColors[i % bgColors.length];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BibleSelectionGridScreen(
                                  bookName: book.$1,
                                  chapterCount: book.$2,
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: rowBg,
                                borderRadius:
                                    BorderRadius.circular(14),
                                border: Border.all(
                                    color: borderColor
                                        .withOpacity(0.6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Initial circle
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: book.$3.withOpacity(0.15),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        book.$1[0],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: book.$3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.$1,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${book.$2} Chapters',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: subColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,
                                      color: subColor.withOpacity(0.5),
                                      size: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        color: isDark
            ? AppColors.backgroundDark.withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
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
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.menu_book,
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
                    icon: Icons.groups_outlined,
                    label: 'Church',
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

// ─── Tab widget ──────────────────────────────────────────────────

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab(
      {required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active
                  ? AppColors.primary
                  : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}

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
