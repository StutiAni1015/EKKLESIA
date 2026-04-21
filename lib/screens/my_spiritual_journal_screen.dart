import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../service/api_service.dart';
import '../widgets/app_bottom_bar.dart';
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

  List<Map<String, dynamic>> _entries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ApiService.getJournals();
      setState(() {
        _entries = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
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
      bottomNavigationBar: const AppBottomBar(activeIndex: kTabHome),
      floatingActionButton: buildCenterFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Search journals coming soon!'),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                ),
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
                          Tab(text: 'My'),
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
                      // My tab — real entries from API
                      _loading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : _error != null
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Could not load entries', style: TextStyle(color: subColor)),
                                      const SizedBox(height: 8),
                                      TextButton(onPressed: _loadEntries, child: const Text('Retry', style: TextStyle(color: AppColors.primary))),
                                    ],
                                  ),
                                )
                              : _entries.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.book_outlined, size: 48, color: subColor.withOpacity(0.5)),
                                          const SizedBox(height: 12),
                                          Text('No entries yet.\nTap + to write your first reflection.', textAlign: TextAlign.center, style: TextStyle(color: subColor)),
                                        ],
                                      ),
                                    )
                                  : RefreshIndicator(
                                      color: AppColors.primary,
                                      onRefresh: _loadEntries,
                                      child: ListView.builder(
                                        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 96),
                                        itemCount: _entries.length,
                                        itemBuilder: (ctx, i) {
                                          final e = _entries[i];
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: _ApiEntryCard(
                                              entry: e,
                                              cardBg: cardBg,
                                              textColor: textColor,
                                              subColor: subColor,
                                              onDelete: () async {
                                                try {
                                                  await ApiService.deleteJournal(e['_id'] as String);
                                                  _loadEntries();
                                                } catch (_) {}
                                              },
                                            ),
                                          );
                                        },
                                      ),
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

            // New entry FAB (corner)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 80,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'journal_add_fab',
                onPressed: () async {
                  final saved = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewJournalEntryScreen(),
                    ),
                  );
                  if (saved == true) _loadEntries();
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                child: const Icon(Icons.add, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// ── Real API entry card ───────────────────────────────────────────────────────
class _ApiEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final VoidCallback onDelete;

  const _ApiEntryCard({
    required this.entry,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.onDelete,
  });

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(dt.year, dt.month, dt.day);
      final diff = today.difference(d).inDays;
      final timeStr =
          '${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour < 12 ? 'AM' : 'PM'}';
      if (diff == 0) return 'Today • $timeStr';
      if (diff == 1) return 'Yesterday • $timeStr';
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • $timeStr';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = (entry['title'] as String? ?? '').isNotEmpty
        ? entry['title'] as String
        : 'Untitled Entry';
    final content = entry['content'] as String? ?? '';
    final dateStr = _formatDate(entry['createdAt'] as String?);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: subColor, size: 18),
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            if (dateStr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(dateStr, style: TextStyle(fontSize: 11, color: subColor)),
            ],
            if (content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(fontSize: 14, height: 1.5, color: textColor.withOpacity(0.75)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
