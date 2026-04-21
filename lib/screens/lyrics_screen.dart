import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';
import '../widgets/app_bottom_bar.dart';

const kTabLyrics = 3; // slot in bottom nav

// Roles that can manage lyrics
const _managerRoles = {'worship_leader', 'pastor'};

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  List<Map<String, dynamic>> _all = [];
  bool _loading = true;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final list = await ApiService.getChurchLyrics(churchId);
      if (mounted) setState(() => _all = list.cast<Map<String, dynamic>>());
    } catch (e) {
      _snack('$e', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _canManage =>
      isPastorNotifier.value; // also checked by memberRole fetched separately

  List<Map<String, dynamic>> get _approved =>
      _all.where((l) => l['isApproved'] == true).toList();

  List<Map<String, dynamic>> get _pending =>
      _all.where((l) => l['isApproved'] != true).toList();

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> list) {
    if (_search.isEmpty) return list;
    final q = _search.toLowerCase();
    return list.where((l) {
      final title = (l['title'] as String? ?? '').toLowerCase();
      final artist = (l['artist'] as String? ?? '').toLowerCase();
      return title.contains(q) || artist.contains(q);
    }).toList();
  }

  Future<void> _approve(Map<String, dynamic> l) async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    try {
      await ApiService.approveChurchLyrics(churchId, l['_id']);
      _snack('"${l['title']}" approved!');
      await _load();
    } catch (e) {
      _snack('$e', error: true);
    }
  }

  Future<void> _reject(Map<String, dynamic> l) async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Lyrics'),
        content: Text('Remove "${l['title']}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Remove', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ApiService.rejectChurchLyrics(churchId, l['_id']);
      _snack('"${l['title']}" removed.', error: false);
      await _load();
    } catch (e) {
      _snack('$e', error: true);
    }
  }

  Future<void> _delete(Map<String, dynamic> l) async {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Lyrics'),
        content: Text('Delete "${l['title']}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ApiService.deleteChurchLyrics(churchId, l['_id']);
      _snack('"${l['title']}" deleted.');
      await _load();
    } catch (e) {
      _snack('$e', error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _openAddSheet() {
    final churchId = myChurchIdNotifier.value;
    if (churchId == null) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddLyricsSheet(
        isDark: isDark,
        onSave: (title, artist, text) async {
          try {
            await ApiService.submitChurchLyrics(churchId,
                title: title, artist: artist, textContent: text);
            if (mounted) Navigator.pop(context);
            _snack('Lyrics added!');
            await _load();
          } catch (e) {
            _snack('$e', error: true);
          }
        },
      ),
    );
  }

  void _openViewer(Map<String, dynamic> lyric) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _LyricsViewer(lyric: lyric),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final headerBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final inputFill = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final pending = _pending;
    final churchId = myChurchIdNotifier.value;

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: const AppBottomBar(activeIndex: kTabLyrics),
      floatingActionButton: buildCenterFab(context, activeIndex: kTabLyrics),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              color: headerBg,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lyrics',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                    color: textColor)),
                            Text(
                              myChurchNotifier.value?.name ?? 'Church Songbook',
                              style:
                                  TextStyle(fontSize: 12, color: subColor),
                            ),
                          ],
                        ),
                      ),
                      // Add button (any member can submit; worship leader auto-approves)
                      if (churchId != null)
                        GestureDetector(
                          onTap: _openAddSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC4899),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text('Add Lyrics',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search bar
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _search = v),
                      style: TextStyle(fontSize: 13, color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Search songs…',
                        hintStyle:
                            TextStyle(fontSize: 13, color: subColor),
                        prefixIcon:
                            Icon(Icons.search, color: subColor, size: 18),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: _search.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close,
                                    color: subColor, size: 16),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _search = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tabs
                  TabBar(
                    controller: _tab,
                    labelColor: const Color(0xFFEC4899),
                    unselectedLabelColor: subColor,
                    indicatorColor: const Color(0xFFEC4899),
                    indicatorWeight: 2,
                    tabs: [
                      const Tab(text: 'All Songs'),
                      if (_canManage && pending.isNotEmpty)
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Pending'),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEC4899),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text('${pending.length}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        )
                      else
                        const Tab(text: 'Pending'),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: churchId == null
                  ? _noChurch(textColor, subColor)
                  : TabBarView(
                      controller: _tab,
                      children: [
                        // Tab 0: Approved songs
                        _SongList(
                          songs: _filtered(_approved),
                          loading: _loading,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          canManage: _canManage,
                          onTap: _openViewer,
                          onDelete: _delete,
                          emptyLabel: _search.isNotEmpty
                              ? 'No songs match "$_search"'
                              : 'No lyrics yet',
                          emptySubLabel: 'Tap "Add Lyrics" to submit a song.',
                          onRefresh: _load,
                        ),

                        // Tab 1: Pending approval
                        _SongList(
                          songs: _filtered(_pending),
                          loading: _loading,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          canManage: _canManage,
                          onTap: _openViewer,
                          onApprove: _approve,
                          onDelete: _reject,
                          emptyLabel: 'No pending submissions',
                          emptySubLabel: '',
                          onRefresh: _load,
                          isPendingTab: true,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noChurch(Color textColor, Color subColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lyrics_outlined, size: 56, color: subColor.withOpacity(0.25)),
          const SizedBox(height: 16),
          Text('Join a Church First',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 6),
          Text('Lyrics are shared within your church community.',
              style: TextStyle(fontSize: 13, color: subColor)),
        ],
      ),
    );
  }
}

// ── Song list ─────────────────────────────────────────────────────────────────

class _SongList extends StatelessWidget {
  final List<Map<String, dynamic>> songs;
  final bool loading;
  final bool isDark;
  final Color textColor, subColor;
  final bool canManage;
  final bool isPendingTab;
  final ValueChanged<Map<String, dynamic>> onTap;
  final Future<void> Function(Map<String, dynamic>)? onApprove;
  final Future<void> Function(Map<String, dynamic>) onDelete;
  final String emptyLabel, emptySubLabel;
  final Future<void> Function() onRefresh;

  const _SongList({
    required this.songs,
    required this.loading,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.canManage,
    required this.onTap,
    this.onApprove,
    required this.onDelete,
    required this.emptyLabel,
    required this.emptySubLabel,
    required this.onRefresh,
    this.isPendingTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    if (loading) return const Center(child: CircularProgressIndicator());

    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.music_note_outlined,
                size: 48, color: subColor.withOpacity(0.25)),
            const SizedBox(height: 12),
            Text(emptyLabel,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            if (emptySubLabel.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(emptySubLabel,
                  style: TextStyle(fontSize: 13, color: subColor)),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, MediaQuery.of(context).padding.bottom + 100),
        itemCount: songs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final l = songs[i];
          final contentType = l['contentType'] as String? ?? 'text';
          final artist = l['artist'] as String? ?? '';
          final submitterRole = l['submitterRole'] as String? ?? 'member';
          final isOwner =
              (l['submittedBy'] as String? ?? '') == authUserIdNotifier.value;

          return GestureDetector(
            onTap: () => onTap(l),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isPendingTab
                      ? const Color(0xFFF59E0B).withOpacity(0.3)
                      : borderColor,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      contentType == 'file'
                          ? _fileIcon(l['mediaFileType'] as String? ?? '')
                          : Icons.lyrics_outlined,
                      color: const Color(0xFFEC4899),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l['title'] as String? ?? 'Untitled',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textColor)),
                        if (artist.isNotEmpty) ...[
                          const SizedBox(height: 1),
                          Text(artist,
                              style:
                                  TextStyle(fontSize: 11, color: subColor)),
                        ],
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: _roleColor(submitterRole)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                _roleLabel(submitterRole),
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: _roleColor(submitterRole)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: (contentType == 'text'
                                        ? const Color(0xFF0EA5E9)
                                        : const Color(0xFFF59E0B))
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                contentType == 'text' ? 'Text' : 'File',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: contentType == 'text'
                                        ? const Color(0xFF0EA5E9)
                                        : const Color(0xFFF59E0B)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  if (isPendingTab && canManage) ...[
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline,
                          color: Color(0xFF10B981), size: 22),
                      tooltip: 'Approve',
                      onPressed: () => onApprove?.call(l),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined,
                          color: Colors.redAccent, size: 22),
                      tooltip: 'Reject',
                      onPressed: () => onDelete(l),
                    ),
                  ] else if (!isPendingTab &&
                      (isOwner || canManage)) ...[
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 18),
                      onPressed: () => onDelete(l),
                    ),
                  ] else ...[
                    Icon(Icons.chevron_right, color: subColor, size: 20),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static IconData _fileIcon(String type) => switch (type) {
        'pdf' => Icons.picture_as_pdf_outlined,
        'image' => Icons.image_outlined,
        'ppt' => Icons.slideshow_outlined,
        _ => Icons.insert_drive_file_outlined,
      };

  static Color _roleColor(String role) => switch (role) {
        'worship_leader' => const Color(0xFFEC4899),
        'media_team' => const Color(0xFF0EA5E9),
        'choir' => const Color(0xFFF97316),
        'secretary' => const Color(0xFF8B5CF6),
        'pastor' => const Color(0xFFD97706),
        _ => AppColors.primary,
      };

  static String _roleLabel(String role) => switch (role) {
        'worship_leader' => 'Worship Leader',
        'media_team' => 'Media Team',
        'choir' => 'Choir',
        'secretary' => 'Secretary',
        'pastor' => 'Pastor',
        _ => 'Member',
      };
}

// ── Add lyrics bottom sheet ───────────────────────────────────────────────────

class _AddLyricsSheet extends StatefulWidget {
  final bool isDark;
  final Future<void> Function(String title, String artist, String text) onSave;

  const _AddLyricsSheet({required this.isDark, required this.onSave});

  @override
  State<_AddLyricsSheet> createState() => _AddLyricsSheetState();
}

class _AddLyricsSheetState extends State<_AddLyricsSheet> {
  final _titleCtrl  = TextEditingController();
  final _artistCtrl = TextEditingController();
  final _textCtrl   = TextEditingController();
  bool _saving = false;

  // Quick insert section labels
  static const _sections = ['[Verse 1]', '[Verse 2]', '[Chorus]', '[Bridge]', '[Outro]'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _artistCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _insertSection(String label) {
    final ctrl = _textCtrl;
    final sel = ctrl.selection;
    final txt = ctrl.text;
    final insertion = '\n$label\n';
    final pos = sel.end < 0 ? txt.length : sel.end;
    final newText = txt.substring(0, pos) + insertion + txt.substring(pos);
    ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: pos + insertion.length),
    );
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final text  = _textCtrl.text.trim();
    if (title.isEmpty || text.isEmpty) return;
    setState(() => _saving = true);
    await widget.onSave(title, _artistCtrl.text.trim(), text);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final inputFill = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    InputDecoration dec(String hint, {IconData? icon}) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: subColor, fontSize: 13),
      prefixIcon: icon != null ? Icon(icon, color: subColor, size: 18) : null,
      filled: true,
      fillColor: inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEC4899), width: 1.5)),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle + header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(99)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Add Lyrics',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEC4899),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Submit',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  // Song title
                  TextField(
                    controller: _titleCtrl,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('Song title *', icon: Icons.music_note),
                  ),
                  const SizedBox(height: 10),

                  // Artist
                  TextField(
                    controller: _artistCtrl,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('Artist / author (optional)',
                        icon: Icons.person_outline),
                  ),
                  const SizedBox(height: 16),

                  // Section quick-insert chips
                  Text('Insert section:',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600, color: subColor)),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _sections.map((s) {
                        return GestureDetector(
                          onTap: () => _insertSection(s),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEC4899).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                  color: const Color(0xFFEC4899).withOpacity(0.3)),
                            ),
                            child: Text(s,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFEC4899))),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Lyrics text area
                  Container(
                    decoration: BoxDecoration(
                      color: inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      controller: _textCtrl,
                      maxLines: 20,
                      minLines: 10,
                      style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          height: 1.6,
                          fontFamily: 'monospace'),
                      decoration: InputDecoration(
                        hintText:
                            '[Verse 1]\nAmazing grace, how sweet the sound…\n\n[Chorus]\nThrough many dangers, toils and snares…',
                        hintStyle:
                            TextStyle(color: subColor.withOpacity(0.5), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tip: Use [Verse 1], [Chorus], [Bridge] to label sections. '
                    'Worship leaders\' submissions are auto-approved; others go to pending review.',
                    style: TextStyle(fontSize: 11, color: subColor, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Lyrics viewer ─────────────────────────────────────────────────────────────

class _LyricsViewer extends StatelessWidget {
  final Map<String, dynamic> lyric;
  const _LyricsViewer({required this.lyric});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final contentType = lyric['contentType'] as String? ?? 'text';
    final title  = lyric['title']  as String? ?? '';
    final artist = lyric['artist'] as String? ?? '';
    final text   = lyric['textContent'] as String? ?? '';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        foregroundColor: textColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            if (artist.isNotEmpty)
              Text(artist,
                  style: TextStyle(fontSize: 11, color: subColor)),
          ],
        ),
      ),
      body: contentType == 'file'
          ? _FileViewer(lyric: lyric, isDark: isDark, subColor: subColor)
          : _TextViewer(text: text, isDark: isDark),
    );
  }
}

// ── Text lyrics viewer with section highlighting ──────────────────────────────

class _TextViewer extends StatelessWidget {
  final String text;
  final bool isDark;
  const _TextViewer({required this.text, required this.isDark});

  List<_LyricBlock> _parse(String raw) {
    final blocks = <_LyricBlock>[];
    final lines = raw.split('\n');
    String? currentSection;
    final List<String> currentLines = [];

    void flush() {
      if (currentLines.isNotEmpty || currentSection != null) {
        blocks.add(_LyricBlock(
          section: currentSection,
          lines: List.from(currentLines),
        ));
        currentLines.clear();
        currentSection = null;
      }
    }

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        flush();
        currentSection = trimmed;
      } else {
        currentLines.add(line);
      }
    }
    flush();
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    final blocks = _parse(text);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final sectionColor = const Color(0xFFEC4899);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks.map((block) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (block.section != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: sectionColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      block.section!,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: sectionColor),
                    ),
                  ),
                ],
                ...block.lines.map((line) {
                  final trimmed = line.trim();
                  if (trimmed.isEmpty) {
                    return const SizedBox(height: 6);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      line,
                      style: TextStyle(
                          fontSize: 17,
                          height: 1.65,
                          color: textColor,
                          fontWeight: FontWeight.w400),
                    ),
                  );
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LyricBlock {
  final String? section;
  final List<String> lines;
  const _LyricBlock({required this.section, required this.lines});
}

// ── File-based lyrics viewer ──────────────────────────────────────────────────

class _FileViewer extends StatelessWidget {
  final Map<String, dynamic> lyric;
  final bool isDark;
  final Color subColor;

  const _FileViewer(
      {required this.lyric, required this.isDark, required this.subColor});

  @override
  Widget build(BuildContext context) {
    final fileType = lyric['mediaFileType'] as String? ?? '';
    final fileUrl = '${ApiService.baseUrl}${lyric['mediaFileUrl'] ?? ''}';

    if (fileType == 'image') {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: Image.network(
            fileUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined,
                    size: 48, color: subColor.withOpacity(0.4)),
                const SizedBox(height: 8),
                Text('Could not load image',
                    style: TextStyle(color: subColor)),
              ],
            ),
          ),
        ),
      );
    }

    // PDF / PPT: open externally
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            fileType == 'pdf'
                ? Icons.picture_as_pdf_outlined
                : Icons.slideshow_outlined,
            size: 64,
            color: subColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text('Open in external viewer',
              style: TextStyle(fontSize: 14, color: subColor)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final uri = Uri.tryParse(fileUrl);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC4899),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
