import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'new_journal_entry_screen.dart';

class MySpiritualJournalScreen extends StatefulWidget {
  const MySpiritualJournalScreen({super.key});

  @override
  State<MySpiritualJournalScreen> createState() =>
      _MySpiritualJournalScreenState();
}

class _MySpiritualJournalScreenState extends State<MySpiritualJournalScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _todayEntries = [
    _JournalEntry(
      title: 'Sunday Sermon Reflection',
      dateTime: 'Aug 20, 2024 • 10:30 AM',
      preview:
          'The message on hope really resonated with me today. Pastor John emphasized how faith acts as an anchor for the soul during turbulent times...',
      tags: [
        _Tag('Sermon Notes', _TagColor.orange),
        _Tag('Gratitude', _TagColor.green),
      ],
      hasImage: false,
    ),
  ];

  static const _weekEntries = [
    _JournalEntry(
      title: 'Morning Devotional: Psalm 23',
      dateTime: 'Aug 18, 2024 • 7:15 AM',
      preview:
          'He leads me beside still waters. I am learning to find peace in the stillness and trusting His timing for the next steps in my career...',
      tags: [
        _Tag('Prayer', _TagColor.blue),
        _Tag('Devotional', _TagColor.purple),
      ],
      hasImage: false,
    ),
    _JournalEntry(
      title: 'Community Service Day',
      dateTime: 'Aug 16, 2024 • 4:45 PM',
      preview:
          'What a blessing to serve alongside the youth group today. We managed to package over 500 meals for the local shelter. Seeing the smiles...',
      tags: [
        _Tag('Community', _TagColor.orange),
      ],
      hasImage: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

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
                  decoration: BoxDecoration(
                    color: bg.withOpacity(0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.primary, size: 20),
                                onPressed: () =>
                                    Navigator.maybePop(context),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'My Journal',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
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
                              child: IconButton(
                                icon: const Icon(Icons.search,
                                    color: AppColors.primary, size: 20),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: subColor,
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        indicatorColor: AppColors.primary,
                        indicatorWeight: 2,
                        tabs: const [
                          Tab(text: 'All Entries'),
                          Tab(text: 'Favorites'),
                          Tab(text: 'Shared'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // All Entries tab
                      ListView(
                        padding: EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            MediaQuery.of(context).padding.bottom + 96),
                        children: [
                          _DateSection(
                            label: 'Today',
                            entries: _todayEntries,
                            cardBg: cardBg,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 16),
                          _DateSection(
                            label: 'Earlier this week',
                            entries: _weekEntries,
                            cardBg: cardBg,
                            textColor: textColor,
                            subColor: subColor,
                          ),
                        ],
                      ),

                      // Favorites tab
                      Center(
                        child: Text(
                          'Your favorite entries appear here.',
                          style: TextStyle(color: subColor),
                        ),
                      ),

                      // Shared tab
                      Center(
                        child: Text(
                          'Entries shared with others appear here.',
                          style: TextStyle(color: subColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // FAB
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 80,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewJournalEntryScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                child: const Icon(Icons.add, size: 28),
              ),
            ),

            // Bottom nav
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _BottomNav(
                isDark: isDark,
                bottomPadding: MediaQuery.of(context).padding.bottom,
                onHome: () => Navigator.maybePop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewEntrySheet(
      BuildContext context, bool isDark, Color textColor, Color subColor) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Journal Entry',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: subColor),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                style: TextStyle(fontSize: 15, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Entry title...',
                  hintStyle: TextStyle(color: subColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bodyCtrl,
                maxLines: 5,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Write your thoughts...',
                  hintStyle: TextStyle(color: subColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Journal entry saved.'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Entry',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DateSection extends StatelessWidget {
  final String label;
  final List<_JournalEntry> entries;
  final Color cardBg;
  final Color textColor;
  final Color subColor;

  const _DateSection({
    required this.label,
    required this.entries,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ),
        ...entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _EntryCard(
                entry: e,
                cardBg: cardBg,
                textColor: textColor,
                subColor: subColor,
              ),
            )),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  final _JournalEntry entry;
  final Color cardBg;
  final Color textColor;
  final Color subColor;

  const _EntryCard({
    required this.entry,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder (only for entries with image)
          if (entry.hasImage)
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A6741), Color(0xFF8BA888)],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: Colors.white.withOpacity(0.3),
                  size: 48,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    Icon(Icons.more_vert, color: subColor, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  entry.dateTime,
                  style: TextStyle(fontSize: 11, color: subColor),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.preview,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: textColor.withOpacity(0.75),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: entry.tags.map((tag) {
                    final colors = _tagColors(tag.color);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.$1,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        tag.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: colors.$2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _tagColors(_TagColor c) {
    switch (c) {
      case _TagColor.orange:
        return (
          AppColors.primary.withOpacity(0.1),
          AppColors.primary
        );
      case _TagColor.green:
        return (
          const Color(0xFFD1FAE5),
          const Color(0xFF065F46)
        );
      case _TagColor.blue:
        return (
          const Color(0xFFDBEAFE),
          const Color(0xFF1D4ED8)
        );
      case _TagColor.purple:
        return (
          const Color(0xFFEDE9FE),
          const Color(0xFF6D28D9)
        );
    }
  }
}

class _BottomNav extends StatelessWidget {
  final bool isDark;
  final double bottomPadding;
  final VoidCallback onHome;

  const _BottomNav({
    required this.isDark,
    required this.bottomPadding,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.black.withOpacity(0.95)
        : Colors.white.withOpacity(0.95);
    final borderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding + 8),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
              icon: Icons.home,
              label: 'Home',
              active: false,
              onTap: onHome),
          _NavItem(
              icon: Icons.group,
              label: 'Community',
              active: false,
              onTap: () {}),
          const SizedBox(width: 56),
          _NavItem(
              icon: Icons.edit_note,
              label: 'Journal',
              active: true,
              onTap: () {}),
          _NavItem(
              icon: Icons.person,
              label: 'Profile',
              active: false,
              onTap: () {}),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : const Color(0xFF94A3B8);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

enum _TagColor { orange, green, blue, purple }

class _Tag {
  final String label;
  final _TagColor color;
  const _Tag(this.label, this.color);
}

class _JournalEntry {
  final String title;
  final String dateTime;
  final String preview;
  final List<_Tag> tags;
  final bool hasImage;

  const _JournalEntry({
    required this.title,
    required this.dateTime,
    required this.preview,
    required this.tags,
    required this.hasImage,
  });
}
