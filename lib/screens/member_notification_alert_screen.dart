import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../service/api_service.dart';

class MemberNotificationAlertScreen extends StatefulWidget {
  const MemberNotificationAlertScreen({super.key});

  @override
  State<MemberNotificationAlertScreen> createState() =>
      _MemberNotificationAlertScreenState();
}

class _MemberNotificationAlertScreenState
    extends State<MemberNotificationAlertScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<Offset>   _slide;
  late final Animation<double>   _fade;

  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
  final Set<String> _readIds = {};
  int _expandedIdx = -1;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn);
    _entryCtrl.forward();
    _load();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getNotifications();
      if (mounted) {
        setState(() => _notifications = list.cast<Map<String, dynamic>>());
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _markRead(String id) async {
    setState(() => _readIds.add(id));
    try { await ApiService.markNotificationRead(id); } catch (_) {}
  }

  Future<void> _markAllRead() async {
    final unread = _notifications.where((n) => !(n['read'] as bool? ?? false) && !_readIds.contains(n['_id'] as String));
    for (final n in unread) { _markRead(n['_id'] as String); }
  }

  // ── Map type to icon / colour ────────────────────────────────────────────────
  static (IconData, Color, String) _typeStyle(String? type) => switch (type) {
    'announcement' => (Icons.campaign_rounded,        AppColors.primary,          'Announcement'),
    'event'        => (Icons.event_rounded,            const Color(0xFF3B82F6),   'Event'),
    'prayer'       => (Icons.favorite_rounded,         const Color(0xFFEC4899),   'Prayer'),
    'like'         => (Icons.thumb_up_rounded,         const Color(0xFF22C55E),   'Like'),
    'comment'      => (Icons.comment_rounded,          const Color(0xFF8B5CF6),   'Comment'),
    'join_request' => (Icons.person_add_rounded,       const Color(0xFFF59E0B),   'Request'),
    'join_approved'=> (Icons.check_circle_rounded,     const Color(0xFF22C55E),   'Approved'),
    'join_rejected'=> (Icons.cancel_rounded,           const Color(0xFFEF4444),   'Rejected'),
    _              => (Icons.notifications_rounded,    AppColors.primary,          'Notice'),
  };

  static String _timeAgo(String? iso) {
    if (iso == null) return '';
    final dt   = DateTime.tryParse(iso);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60)  return 'Just now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    if (diff.inDays    < 7)   return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bg        = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final cardBg    = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    final newCount = _notifications
        .where((n) => !(n['read'] as bool? ?? false) && !_readIds.contains(n['_id'] as String))
        .length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('Notifications',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const Spacer(),
                  if (newCount > 0)
                    GestureDetector(
                      onTap: _markAllRead,
                      child: Text('Mark all read',
                          style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),

            // ── New badge banner ──────────────────────────────────────────
            if (newCount > 0)
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.primary.withAlpha(30),
                        AppColors.primary.withAlpha(10),
                      ]),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withAlpha(50)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: Text('$newCount',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        Text('$newCount new notification${newCount > 1 ? 's' : ''}',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        const Spacer(),
                        Icon(Icons.notifications_active, color: AppColors.primary, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // ── List ──────────────────────────────────────────────────────
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : _notifications.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined, size: 56, color: subColor),
                            const SizedBox(height: 12),
                            Text('No notifications yet',
                                style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text('Church announcements and events\nwill appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: subColor)),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          color: AppColors.primary,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                            itemCount: _notifications.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final n       = _notifications[i];
                              final id      = n['_id'] as String? ?? '';
                              final isNew   = !(n['read'] as bool? ?? false) && !_readIds.contains(id);
                              final isOpen  = i == _expandedIdx;
                              final (icon, color, cat) = _typeStyle(n['type'] as String?);
                              final title   = n['title'] as String? ?? n['type'] ?? 'Notification';
                              final body    = n['message'] as String? ?? '';
                              final timeStr = _timeAgo(n['createdAt'] as String?);

                              return GestureDetector(
                                onTap: () {
                                  setState(() => _expandedIdx = isOpen ? -1 : i);
                                  if (isNew) _markRead(id);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isNew
                                          ? AppColors.primary.withAlpha(64)
                                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                                      width: isNew ? 1.5 : 1,
                                    ),
                                    boxShadow: isNew
                                        ? [BoxShadow(color: AppColors.primary.withAlpha(15), blurRadius: 12, offset: const Offset(0, 4))]
                                        : null,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 44, height: 44,
                                              decoration: BoxDecoration(color: color.withAlpha(30), shape: BoxShape.circle),
                                              child: Icon(icon, color: color, size: 22),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(title,
                                                            style: TextStyle(
                                                                fontSize: 14, fontWeight: FontWeight.w700, color: textColor)),
                                                      ),
                                                      if (isNew)
                                                        Container(
                                                          width: 8, height: 8,
                                                          margin: const EdgeInsets.only(left: 6, top: 3),
                                                          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                                        ),
                                                    ],
                                                  ),
                                                  if (n['church'] != null) ...[
                                                    const SizedBox(height: 2),
                                                    Text('Your Church',
                                                        style: TextStyle(fontSize: 11, color: subColor, fontWeight: FontWeight.w500)),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (body.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                                          child: Text(body,
                                              style: TextStyle(fontSize: 13, height: 1.55,
                                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151)),
                                              maxLines: isOpen ? null : 2,
                                              overflow: isOpen ? TextOverflow.visible : TextOverflow.ellipsis),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: color.withAlpha(25), borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(cat,
                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                                            ),
                                            const Spacer(),
                                            Text(timeStr, style: TextStyle(fontSize: 11, color: subColor)),
                                            if (isNew) ...[
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () => _markRead(id),
                                                child: Text('Dismiss',
                                                    style: TextStyle(fontSize: 11, color: subColor,
                                                        decoration: TextDecoration.underline)),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
