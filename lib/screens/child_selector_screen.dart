import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'child_profile_setup_screen.dart';
import 'kids_home_screen.dart';

class ChildSelectorScreen extends StatefulWidget {
  const ChildSelectorScreen({super.key});

  @override
  State<ChildSelectorScreen> createState() => _ChildSelectorScreenState();
}

class _ChildSelectorScreenState extends State<ChildSelectorScreen> {
  static const _primary = Color(0xFFA53500);
  static const _accent  = Color(0xFFFF7947);
  static const _surface = Color(0xFFF5F6F7);

  List<Map<String, dynamic>> _children = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getKidsProfiles();
      if (mounted) setState(() => _children = data.cast<Map<String, dynamic>>());
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openSetup({Map<String, dynamic>? existing}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChildProfileSetupScreen(existing: existing)),
    );
    _load();
  }

  void _selectChild(Map<String, dynamic> child) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KidsHomeScreen(child: child)),
    );
  }

  Future<void> _deleteChild(Map<String, dynamic> child) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Remove ${child['name']}\'s profile? Their progress will be saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ApiService.deleteKidsProfile(child['_id'] as String);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
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
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Who\'s learning today? 👋',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _primary, letterSpacing: -0.3)),
                        Text('Choose a profile to begin',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Child grid ────────────────────────────────────────────────
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: _accent))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _children.length + 1, // +1 for Add button
                        itemBuilder: (_, i) {
                          if (i == _children.length) return _AddChildCard(onTap: () => _openSetup());
                          return _ChildCard(
                            child: _children[i],
                            onTap: () => _selectChild(_children[i]),
                            onEdit: () => _openSetup(existing: _children[i]),
                            onDelete: () => _deleteChild(_children[i]),
                          );
                        },
                      ),
                    ),
            ),

            // ── Manage footer ─────────────────────────────────────────────
            if (_children.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: GestureDetector(
                  onTap: () => _openSetup(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.manage_accounts_rounded, color: _primary, size: 20),
                        SizedBox(width: 8),
                        Text('Add Another Child',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _primary)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Child profile card ────────────────────────────────────────────────────────

class _ChildCard extends StatelessWidget {
  final Map<String, dynamic> child;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ChildCard({
    required this.child,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(child['avatarColor'] as String? ?? '#FF7947');
    final emoji = child['avatarEmoji'] as String? ?? '🧒';
    final name  = child['name'] as String? ?? '';
    final age   = child['age'] as int? ?? 0;
    final pts   = child['totalPoints'] as int? ?? 0;
    final streak = child['prayerStreak'] as int? ?? 0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: color.withAlpha(40), shape: BoxShape.circle),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 36))),
            ),
            const SizedBox(height: 10),
            Text(name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E3A5F)),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text('$age years old',
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatChip('⭐', '$pts'),
                const SizedBox(width: 6),
                _StatChip('🔥', '$streak'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: Color(0xFF1E3A5F)),
              title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () { Navigator.pop(context); onEdit(); },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              title: const Text('Remove Profile', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent)),
              onTap: () { Navigator.pop(context); onDelete(); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFFFF7947);
    }
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String value;
  const _StatChip(this.emoji, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}

// ── Add child card ────────────────────────────────────────────────────────────

class _AddChildCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddChildCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFF7947).withAlpha(80), width: 2, strokeAlign: BorderSide.strokeAlignInside),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7947).withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: Color(0xFFFF7947), size: 30),
            ),
            const SizedBox(height: 12),
            const Text('Add Child',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E3A5F))),
            const SizedBox(height: 4),
            const Text('New profile',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }
}
