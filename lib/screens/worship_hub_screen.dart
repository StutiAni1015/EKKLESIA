import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';

// Roles that have access to the Worship Hub
const _worshipRoles = {'worship_leader', 'media_team', 'choir', 'secretary'};

class WorshipHubScreen extends StatefulWidget {
  final String churchId;
  final String churchName;
  final String memberRole;

  const WorshipHubScreen({
    super.key,
    required this.churchId,
    required this.churchName,
    required this.memberRole,
  });

  @override
  State<WorshipHubScreen> createState() => _WorshipHubScreenState();
}

class _WorshipHubScreenState extends State<WorshipHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _files = [];
  bool _loading = true;
  bool _uploading = false;
  String _activeFilter = 'All';

  // Tabs: Files (All/PDF/Images/Slides) + Lyrics
  static const _filterLabels = ['All', 'PDF', 'Images', 'Slides'];
  static const _filterValues = ['All', 'pdf', 'image', 'ppt'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getChurchMedia(widget.churchId);
      if (mounted) setState(() => _files = list.cast<Map<String, dynamic>>());
    } catch (e) {
      _snack('$e', color: Colors.redAccent);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Upload flow: pick file → choose type → choose title → upload ─────────────
  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'ppt', 'pptx'],
    );
    if (result == null || result.files.isEmpty) return;
    final picked = result.files.first;
    if (picked.path == null) return;

    // Step 1: Ask what type of file this is
    final selectedType = await _showTypePickerDialog();
    if (selectedType == null) return;

    // Step 2: Ask for a title
    final titleCtrl = TextEditingController(text: picked.name.replaceAll(RegExp(r'\.[^.]+$'), ''));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Name this ${_typeLabel(selectedType)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Song title or file name',
            prefixIcon: Icon(_typeIcon(selectedType),
                color: _typeColor(selectedType), size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC4899),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Upload'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _uploading = true);
    try {
      await ApiService.uploadChurchMedia(
        widget.churchId,
        picked.path!,
        titleCtrl.text.trim().isEmpty ? picked.name : titleCtrl.text.trim(),
        '',
        fileTypeOverride: selectedType,
      );
      _snack('Uploaded successfully!');
      await _loadFiles();
    } catch (e) {
      _snack('$e', color: Colors.redAccent);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<String?> _showTypePickerDialog() async {
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('What type of file is this?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TypeOption(
                label: 'PDF Document',
                subtitle: 'Sheet music, lyrics in PDF format',
                icon: Icons.picture_as_pdf_outlined,
                color: const Color(0xFFEF4444),
                value: 'pdf',
                isDark: isDark,
                onTap: () => Navigator.pop(ctx, 'pdf'),
              ),
              const SizedBox(height: 10),
              _TypeOption(
                label: 'Image (JPEG / PNG)',
                subtitle: 'Photo of lyrics or music sheet',
                icon: Icons.image_outlined,
                color: const Color(0xFF0EA5E9),
                value: 'image',
                isDark: isDark,
                onTap: () => Navigator.pop(ctx, 'image'),
              ),
              const SizedBox(height: 10),
              _TypeOption(
                label: 'Slide (PPT / PPTX)',
                subtitle: 'PowerPoint presentation or slides',
                icon: Icons.slideshow_outlined,
                color: const Color(0xFFF59E0B),
                value: 'ppt',
                isDark: isDark,
                onTap: () => Navigator.pop(ctx, 'ppt'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteFile(Map<String, dynamic> file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Delete "${file['title']}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.deleteChurchMedia(widget.churchId, file['_id']);
      _snack('File deleted.', color: Colors.orange);
      await _loadFiles();
    } catch (e) {
      _snack('$e', color: Colors.redAccent);
    }
  }

  Future<void> _toggleLyrics(Map<String, dynamic> file) async {
    try {
      final updated = await ApiService.toggleChurchMediaLyrics(
          widget.churchId, file['_id']);
      final isNowLyrics = updated['isLyrics'] as bool? ?? false;
      _snack(isNowLyrics
          ? '"${file['title']}" added to Lyrics tab'
          : '"${file['title']}" removed from Lyrics tab');
      await _loadFiles();
    } catch (e) {
      _snack('$e', color: Colors.redAccent);
    }
  }

  Future<void> _openFile(Map<String, dynamic> file) async {
    final fileType = file['fileType'] as String? ?? 'other';
    if (fileType == 'image') {
      // Show image inline in a full-screen viewer
      final url = '${ApiService.baseUrl}${file['fileUrl']}';
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _ImageLyricsViewer(
            imageUrl: url,
            title: file['title'] as String? ?? 'Lyrics',
          ),
        ),
      );
      return;
    }
    // PDFs and PPTs: open externally
    final url = '${ApiService.baseUrl}${file['fileUrl']}';
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _snack('Cannot open file', color: Colors.redAccent);
    }
  }

  void _snack(String msg, {Color color = const Color(0xFF10B981)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  List<Map<String, dynamic>> get _filteredFiles {
    if (_activeFilter == 'All') return _files;
    return _files.where((f) => f['fileType'] == _activeFilter).toList();
  }

  List<Map<String, dynamic>> get _lyricsFiles =>
      _files.where((f) => f['isLyrics'] == true).toList();

  bool get _canUpload =>
      isPastorNotifier.value || _worshipRoles.contains(widget.memberRole);

  bool get _canManageLyrics =>
      isPastorNotifier.value || widget.memberRole == 'worship_leader';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final headerBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final lyricsCount = _lyricsFiles.length;

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: _canUpload
          ? FloatingActionButton.extended(
              onPressed: _uploading ? null : _pickAndUpload,
              backgroundColor: const Color(0xFFEC4899),
              icon: _uploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.upload_file, color: Colors.white),
              label: Text(_uploading ? 'Uploading…' : 'Upload File',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: headerBg,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Worship Hub',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            Text(widget.churchName,
                                style: TextStyle(fontSize: 12, color: subColor)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC4899).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _roleLabel(widget.memberRole),
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFEC4899)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Main tabs: Files | Lyrics
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFFEC4899),
                    unselectedLabelColor: subColor,
                    indicatorColor: const Color(0xFFEC4899),
                    indicatorWeight: 2,
                    tabs: [
                      const Tab(text: 'Files'),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Lyrics'),
                            if (lyricsCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEC4899),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text('$lyricsCount',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ── Tab 0: Files ───────────────────────────────────────
                  Column(
                    children: [
                      // Filter chips
                      Container(
                        color: headerBg,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(_filterLabels.length, (i) {
                              final label = _filterLabels[i];
                              final value = _filterValues[i];
                              final active = value == _activeFilter;
                              final icon = i == 0
                                  ? Icons.folder_outlined
                                  : i == 1
                                      ? Icons.picture_as_pdf_outlined
                                      : i == 2
                                          ? Icons.image_outlined
                                          : Icons.slideshow_outlined;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _activeFilter = value),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? const Color(0xFFEC4899)
                                              .withOpacity(0.12)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: active
                                            ? const Color(0xFFEC4899)
                                                .withOpacity(0.4)
                                            : borderColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(icon,
                                            size: 13,
                                            color: active
                                                ? const Color(0xFFEC4899)
                                                : subColor),
                                        const SizedBox(width: 5),
                                        Text(label,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: active
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: active
                                                  ? const Color(0xFFEC4899)
                                                  : subColor,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildFileList(
                            _filteredFiles, isDark, textColor, subColor,
                            showLyricsToggle: _canManageLyrics),
                      ),
                    ],
                  ),

                  // ── Tab 1: Lyrics ──────────────────────────────────────
                  _buildLyricsTab(isDark, textColor, subColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(
    List<Map<String, dynamic>> files,
    bool isDark,
    Color textColor,
    Color subColor, {
    bool showLyricsToggle = false,
    bool isLyricsTab = false,
  }) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLyricsTab ? Icons.lyrics_outlined : Icons.music_note_outlined,
              size: 48,
              color: subColor.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              isLyricsTab ? 'No lyrics yet' : 'No files yet',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              isLyricsTab
                  ? 'Worship leaders can add files to the Lyrics tab\nusing the ♪ button on any file.'
                  : _canUpload
                      ? 'Tap + to upload files'
                      : 'No files shared yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: subColor),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFiles,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, MediaQuery.of(context).padding.bottom + 110),
        itemCount: files.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final file = files[i];
          final fileType = file['fileType'] as String? ?? 'other';
          final uploaderRole = file['uploaderRole'] as String? ?? 'member';
          final ts = DateTime.tryParse(file['createdAt'] as String? ?? '');
          final isOwner =
              (file['uploadedBy'] as String? ?? '') == authUserIdNotifier.value;
          final canDelete = isOwner || isPastorNotifier.value;
          final isLyrics = file['isLyrics'] as bool? ?? false;

          return GestureDetector(
            onTap: () => _openFile(file),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isLyrics
                      ? const Color(0xFFEC4899).withOpacity(0.3)
                      : borderColor,
                ),
              ),
              child: Row(
                children: [
                  // File type icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _fileColor(fileType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_fileIcon(fileType),
                        color: _fileColor(fileType), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                file['title'] as String? ?? 'Untitled',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textColor),
                              ),
                            ),
                            if (isLyrics)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.lyrics,
                                    size: 14, color: Color(0xFFEC4899)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(file['uploaderName'] as String? ?? '',
                                style: TextStyle(fontSize: 11, color: subColor)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color:
                                    _roleColorMap(uploaderRole).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(_roleLabel(uploaderRole),
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: _roleColorMap(uploaderRole))),
                            ),
                          ],
                        ),
                        if (ts != null)
                          Text(_formatDate(ts),
                              style:
                                  TextStyle(fontSize: 10, color: subColor)),
                      ],
                    ),
                  ),

                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lyrics toggle (worship_leader / pastor only)
                      if (showLyricsToggle)
                        IconButton(
                          tooltip:
                              isLyrics ? 'Remove from Lyrics' : 'Add to Lyrics',
                          icon: Icon(
                            isLyrics ? Icons.lyrics : Icons.lyrics_outlined,
                            color: isLyrics
                                ? const Color(0xFFEC4899)
                                : subColor,
                            size: 20,
                          ),
                          onPressed: () => _toggleLyrics(file),
                        ),
                      // Delete button
                      if (canDelete)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 18),
                          onPressed: () => _deleteFile(file),
                        )
                      else
                        Icon(Icons.open_in_new, size: 16, color: subColor),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLyricsTab(bool isDark, Color textColor, Color subColor) {
    final lyrics = _lyricsFiles;

    if (_loading) return const Center(child: CircularProgressIndicator());

    if (lyrics.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lyrics_outlined,
                size: 56, color: subColor.withOpacity(0.25)),
            const SizedBox(height: 16),
            Text('No Lyrics Yet',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Worship leaders can promote any file to the Lyrics tab by tapping the ♪ icon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: subColor, height: 1.5),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFiles,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).padding.bottom + 110),
        itemCount: lyrics.length,
        itemBuilder: (_, i) {
          final file = lyrics[i];
          final fileType = file['fileType'] as String? ?? 'other';
          return _LyricsCard(
            file: file,
            fileType: fileType,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
            canManage: _canManageLyrics,
            onView: () => _openFile(file),
            onRemove: () => _toggleLyrics(file),
          );
        },
      ),
    );
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  static String _formatDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }

  static String _typeLabel(String type) => switch (type) {
        'pdf' => 'PDF',
        'image' => 'Image',
        'ppt' => 'Slide',
        _ => 'File',
      };

  static IconData _typeIcon(String type) => switch (type) {
        'pdf' => Icons.picture_as_pdf_outlined,
        'image' => Icons.image_outlined,
        'ppt' => Icons.slideshow_outlined,
        _ => Icons.insert_drive_file_outlined,
      };

  static Color _typeColor(String type) => switch (type) {
        'pdf' => const Color(0xFFEF4444),
        'image' => const Color(0xFF0EA5E9),
        'ppt' => const Color(0xFFF59E0B),
        _ => const Color(0xFF8B5CF6),
      };

  static IconData _fileIcon(String type) => switch (type) {
        'pdf' => Icons.picture_as_pdf_outlined,
        'image' => Icons.image_outlined,
        'ppt' => Icons.slideshow_outlined,
        _ => Icons.insert_drive_file_outlined,
      };

  static Color _fileColor(String type) => switch (type) {
        'pdf' => const Color(0xFFEF4444),
        'image' => const Color(0xFF0EA5E9),
        'ppt' => const Color(0xFFF59E0B),
        _ => const Color(0xFF8B5CF6),
      };

  static Color _roleColorMap(String role) => switch (role) {
        'worship_leader' => const Color(0xFFEC4899),
        'media_team' => const Color(0xFF0EA5E9),
        'choir' => const Color(0xFFF97316),
        'secretary' => const Color(0xFF8B5CF6),
        'pastor' => const Color(0xFFD97706),
        _ => AppColors.primary,
      };
}

// ── Type selection option tile ───────────────────────────────────────────────

class _TypeOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String value;
  final bool isDark;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E293B))),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Lyrics card (shown in the Lyrics tab) ────────────────────────────────────

class _LyricsCard extends StatelessWidget {
  final Map<String, dynamic> file;
  final String fileType;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final bool canManage;
  final VoidCallback onView;
  final VoidCallback onRemove;

  const _LyricsCard({
    required this.file,
    required this.fileType,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.canManage,
    required this.onView,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final ts = DateTime.tryParse(file['createdAt'] as String? ?? '');

    final typeColor = switch (fileType) {
      'pdf' => const Color(0xFFEF4444),
      'image' => const Color(0xFF0EA5E9),
      'ppt' => const Color(0xFFF59E0B),
      _ => const Color(0xFF8B5CF6),
    };
    final typeIcon = switch (fileType) {
      'pdf' => Icons.picture_as_pdf_outlined,
      'image' => Icons.image_outlined,
      'ppt' => Icons.slideshow_outlined,
      _ => Icons.insert_drive_file_outlined,
    };
    final typeLabel = switch (fileType) {
      'pdf' => 'PDF',
      'image' => 'Image',
      'ppt' => 'Slide',
      _ => 'File',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEC4899).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEC4899).withOpacity(0.06),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file['title'] as String? ?? 'Untitled',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(typeLabel,
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: typeColor)),
                          ),
                          if (ts != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][ts.month]} ${ts.day}',
                              style:
                                  TextStyle(fontSize: 10, color: subColor),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (canManage)
                  IconButton(
                    tooltip: 'Remove from Lyrics',
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.redAccent, size: 20),
                    onPressed: onRemove,
                  ),
              ],
            ),
          ),

          // View button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Icon(
                  fileType == 'image'
                      ? Icons.visibility_outlined
                      : Icons.open_in_new,
                  size: 14,
                  color: subColor,
                ),
                const SizedBox(width: 6),
                Text(
                  fileType == 'image'
                      ? 'Tap to view lyrics in full screen'
                      : 'Tap to open in viewer',
                  style: TextStyle(fontSize: 12, color: subColor),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('View Lyrics',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Full-screen image lyrics viewer ─────────────────────────────────────────

class _ImageLyricsViewer extends StatefulWidget {
  final String imageUrl;
  final String title;

  const _ImageLyricsViewer({required this.imageUrl, required this.title});

  @override
  State<_ImageLyricsViewer> createState() => _ImageLyricsViewerState();
}

class _ImageLyricsViewerState extends State<_ImageLyricsViewer> {
  final TransformationController _ctrl = TransformationController();
  bool _showControls = true;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _ctrl.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _showControls
          ? AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              foregroundColor: Colors.white,
              title: Text(widget.title,
                  style: const TextStyle(fontSize: 15, color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.zoom_out_map, color: Colors.white),
                  onPressed: _resetZoom,
                  tooltip: 'Reset zoom',
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Center(
          child: InteractiveViewer(
            transformationController: _ctrl,
            minScale: 0.5,
            maxScale: 5.0,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFFEC4899),
                      ),
                      const SizedBox(height: 12),
                      const Text('Loading lyrics…',
                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                    ],
                  ),
                );
              },
              errorBuilder: (_, __, ___) => const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image_outlined,
                      color: Colors.white38, size: 48),
                  SizedBox(height: 8),
                  Text('Could not load image',
                      style: TextStyle(color: Colors.white38)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Top-level helpers ────────────────────────────────────────────────────────

String _roleLabel(String role) => switch (role) {
      'secretary' => 'Secretary',
      'treasurer' => 'Treasurer',
      'committee' => 'Committee',
      'worship_leader' => 'Worship Leader',
      'media_team' => 'Media Team',
      'choir' => 'Choir',
      'pastor' => 'Pastor',
      _ => 'Member',
    };
