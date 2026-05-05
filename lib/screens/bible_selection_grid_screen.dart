import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'bible_reader_screen.dart';

class BibleSelectionGridScreen extends StatefulWidget {
  final String bookName;
  final int chapterCount;

  const BibleSelectionGridScreen({
    super.key,
    required this.bookName,
    required this.chapterCount,
  });

  @override
  State<BibleSelectionGridScreen> createState() =>
      _BibleSelectionGridScreenState();
}

class _BibleSelectionGridScreenState
    extends State<BibleSelectionGridScreen> {
  bool _showChapters = true;
  int _selectedChapter = 1;

  // Quick read verse for the preview card
  static const _quickRead = (
    '"In the beginning was the Word, and the Word was with God, and the Word was God."',
    'John 1:1'
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFEDE9E4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              color: bg.withOpacity(0.85),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: textColor),
                          onPressed: () =>
                              Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                widget.bookName,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.2,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'New International Version',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search, color: textColor),
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bible search coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                        ),
                      ],
                    ),
                  ),
                  // CHAPTERS / VERSES tabs
                  Row(
                    children: [
                      _GridTab(
                        label: 'CHAPTERS',
                        active: _showChapters,
                        onTap: () =>
                            setState(() => _showChapters = true),
                      ),
                      _GridTab(
                        label: 'VERSES',
                        active: !_showChapters,
                        onTap: () =>
                            setState(() => _showChapters = false),
                      ),
                    ],
                  ),
                  Divider(
                      height: 1,
                      color: AppColors.primary.withOpacity(0.1)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    MediaQuery.of(context).padding.bottom + 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        Text(
                          'Select Chapter',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: subColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${widget.chapterCount} Chapters',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Chapter grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: widget.chapterCount,
                      itemBuilder: (ctx, i) {
                        final num = i + 1;
                        final active = _selectedChapter == num;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedChapter = num);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BibleReaderScreen(
                                  bookName: widget.bookName,
                                  chapter: num,
                                ),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : cardBg,
                              borderRadius:
                                  BorderRadius.circular(14),
                              border: active
                                  ? null
                                  : Border.all(
                                      color: AppColors.primary
                                          .withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: active
                                      ? AppColors.primary
                                          .withOpacity(0.25)
                                      : Colors.black
                                          .withOpacity(0.04),
                                  blurRadius: active ? 12 : 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '$num',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: active
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: active
                                      ? Colors.white
                                      : textColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Quick Read card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_stories,
                                  color: AppColors.primary,
                                  size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'QUICK READ',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.3,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _quickRead.$1,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                              color: subColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '— ${_quickRead.$2}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary
                                  .withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.menu_book,
                            color: Colors.white, size: 24),
                      ),
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
                    icon: Icons.calendar_today_outlined,
                    label: 'Plans',
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

// ─── Supporting widgets ──────────────────────────────────────────

class _GridTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _GridTab(
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
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
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
