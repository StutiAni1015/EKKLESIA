import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../service/api_service.dart';

class ChildProfileSetupScreen extends StatefulWidget {
  final Map<String, dynamic>? existing; // non-null = edit mode

  const ChildProfileSetupScreen({super.key, this.existing});

  @override
  State<ChildProfileSetupScreen> createState() => _ChildProfileSetupScreenState();
}

class _ChildProfileSetupScreenState extends State<ChildProfileSetupScreen> {
  static const _primary = Color(0xFF1E3A5F);
  static const _accent  = Color(0xFFFF7947);
  static const _surface = Color(0xFFF5F6F7);

  // ── avatar options ─────────────────────────────────────────────────────────
  static const _emojis = ['🧒','👦','👧','🧑','👶','🐣','🦁','🐬','🦋','🌟','⚡','🎯'];
  static const _colors = [
    '#FF7947', '#FF5D8F', '#4CAF50', '#2196F3',
    '#9C27B0', '#FF9800', '#00BCD4', '#E91E63',
  ];

  late String _emoji;
  late String _color;
  late TextEditingController _nameCtrl;
  late int _age;

  // ID verification
  String _idStatus = 'none'; // 'none' | 'pending' | 'verified'
  bool   _idLoading   = false;
  bool   _idUploading = false;

  // save state
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _emoji   = e?['avatarEmoji'] as String? ?? '🧒';
    _color   = e?['avatarColor'] as String? ?? '#FF7947';
    _nameCtrl = TextEditingController(text: e?['name'] as String? ?? '');
    _age     = (e?['age'] as int?) ?? 8;
    _loadIDStatus();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadIDStatus() async {
    setState(() => _idLoading = true);
    try {
      final data = await ApiService.getParentIDStatus();
      if (mounted) setState(() => _idStatus = data['status'] as String? ?? 'none');
    } catch (_) {
    } finally {
      if (mounted) setState(() => _idLoading = false);
    }
  }

  Future<void> _uploadID() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;

    setState(() => _idUploading = true);
    try {
      final res = await ApiService.uploadParentID(file.path!);
      if (mounted) {
        setState(() => _idStatus = res['status'] as String? ?? 'pending');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ID submitted for review!'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _idUploading = false);
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter the child's name"),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() => _saving = true);
    try {
      if (_isEdit) {
        await ApiService.updateKidsProfile(widget.existing!['_id'] as String, {
          'name': name, 'age': _age, 'avatarEmoji': _emoji, 'avatarColor': _color,
        });
      } else {
        await ApiService.createKidsProfile(
            name: name, age: _age, avatarEmoji: _emoji, avatarColor: _color);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Color _parseColor(String hex) {
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); }
    catch (_) { return _accent; }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(_color);

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _primary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(_isEdit ? 'Edit Profile' : 'New Child Profile',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _primary)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar preview ──────────────────────────────────────
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              color: bgColor.withAlpha(50),
                              shape: BoxShape.circle,
                              border: Border.all(color: bgColor, width: 3),
                            ),
                            child: Center(child: Text(_emoji, style: const TextStyle(fontSize: 50))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Emoji picker ─────────────────────────────────────────
                    _SectionLabel('Choose Avatar'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: _emojis.map((e) {
                        final selected = e == _emoji;
                        return GestureDetector(
                          onTap: () => setState(() => _emoji = e),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: selected ? bgColor.withAlpha(40) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: selected ? bgColor : Colors.transparent, width: 2),
                              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6)],
                            ),
                            child: Center(child: Text(e, style: const TextStyle(fontSize: 26))),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // ── Color picker ─────────────────────────────────────────
                    _SectionLabel('Profile Colour'),
                    const SizedBox(height: 10),
                    Row(
                      children: _colors.map((c) {
                        final col      = _parseColor(c);
                        final selected = c == _color;
                        return GestureDetector(
                          onTap: () => setState(() => _color = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 10),
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: col,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: selected ? _primary : Colors.transparent, width: 2.5),
                              boxShadow: selected
                                  ? [BoxShadow(color: col.withAlpha(100), blurRadius: 8)]
                                  : [],
                            ),
                            child: selected
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // ── Name ─────────────────────────────────────────────────
                    _SectionLabel("Child's Name"),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      decoration: InputDecoration(
                        hintText: 'e.g. Tobi',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: bgColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Age picker ───────────────────────────────────────────
                    _SectionLabel('Age  (5 – 18)'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _age,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _primary),
                          items: List.generate(14, (i) => i + 5).map((a) {
                            return DropdownMenuItem(
                              value: a,
                              child: Text('$a years old',
                                  style: const TextStyle(fontSize: 14, color: _primary, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: (v) { if (v != null) setState(() => _age = v); },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Parent ID verification ───────────────────────────────
                    _SectionLabel('Parent Verification'),
                    const SizedBox(height: 10),
                    _IDVerificationCard(
                      status: _idStatus,
                      loading: _idLoading,
                      uploading: _idUploading,
                      onUpload: _uploadID,
                    ),
                    const SizedBox(height: 32),

                    // ── Save button ──────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _saving
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(_isEdit ? 'Save Changes' : 'Create Profile',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
            letterSpacing: 1.0, color: Color(0xFF64748B)));
  }
}

// ── ID verification card ──────────────────────────────────────────────────────

class _IDVerificationCard extends StatelessWidget {
  final String status;
  final bool loading;
  final bool uploading;
  final VoidCallback onUpload;

  const _IDVerificationCard({
    required this.status,
    required this.loading,
    required this.uploading,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7947)));
    }

    final (color, icon, label, desc) = switch (status) {
      'verified' => (
          const Color(0xFF10B981),
          Icons.verified_rounded,
          'ID Verified ✅',
          'Your identity has been confirmed. You can add children.',
        ),
      'pending' => (
          const Color(0xFFF59E0B),
          Icons.hourglass_top_rounded,
          'Under Review',
          'Your ID was submitted and is being reviewed by our team.',
        ),
      _ => (
          const Color(0xFF1E3A5F),
          Icons.upload_file_rounded,
          'Upload Government ID',
          'Upload a photo or scan of your government-issued ID to add children. This keeps Kids Mode secure.',
        ),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: uploading
                ? Padding(padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(strokeWidth: 2, color: color))
                : Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3)),
              ],
            ),
          ),
          if (status != 'verified') ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: uploading ? null : onUpload,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withAlpha(60)),
                ),
                child: Text(
                  status == 'pending' ? 'Re-upload' : 'Upload',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
