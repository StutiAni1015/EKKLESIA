import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../service/api_service.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

class PastorManagementScreen extends StatefulWidget {
  final String churchId;
  final String churchName;
  const PastorManagementScreen({
    super.key,
    required this.churchId,
    required this.churchName,
  });

  @override
  State<PastorManagementScreen> createState() => _PastorManagementScreenState();
}

class _PastorManagementScreenState extends State<PastorManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // Data
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _members = [];
  Map<String, bool> _onlineStatus = {};
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _posts = [];

  // Church plan
  Map<String, dynamic>? _activePlan;
  Map<String, dynamic> _planStats = {};
  int _planTotalMembers = 0;
  bool _loadingPlan = true;

  bool _loadingRequests = true;
  bool _loadingMembers  = true;
  bool _loadingEvents   = true;
  bool _loadingPosts    = true;

  // Live session state
  bool _isLive = false;
  String _streamUrl  = '';
  String _liveTitle  = '';
  bool _liveLoading  = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 7, vsync: this);
    _tab.addListener(() { if (!_tab.indexIsChanging) _loadTab(_tab.index); });
    _loadAll();
    _loadLiveStatus();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadRequests(),
      _loadMembers(),
      _loadEvents(),
      _loadPosts(),
      _loadLiveStatus(),
      _loadPlan(),
    ]);
  }

  Future<void> _loadTab(int i) async {
    switch (i) {
      case 0: await _loadRequests();    break;
      case 1: await _loadMembers();     break;
      case 2: await _loadEvents();      break;
      case 4: await _loadPosts();       break;
      case 5: await _loadLiveStatus();  break;
      case 6: await _loadPlan();        break;
    }
  }

  Future<void> _loadPlan() async {
    setState(() => _loadingPlan = true);
    try {
      final result = await ApiService.getChurchPlanStats(widget.churchId);
      if (mounted) setState(() {
        _activePlan       = result['plan'] as Map<String, dynamic>?;
        _planTotalMembers = (result['totalMembers'] as num?)?.toInt() ?? 0;
        final raw = result['stats'] as Map<String, dynamic>? ?? {};
        _planStats = raw;
      });
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingPlan = false);
    }
  }

  Future<void> _loadLiveStatus() async {
    try {
      final status = await ApiService.getLiveStatus(widget.churchId);
      if (mounted) setState(() {
        _isLive    = status['isLive'] as bool? ?? false;
        _streamUrl = status['streamUrl'] as String? ?? '';
        _liveTitle = status['liveTitle'] as String? ?? '';
      });
    } catch (_) {}
  }

  Future<void> _loadRequests() async {
    setState(() => _loadingRequests = true);
    try {
      final list = await ApiService.getJoinRequests(widget.churchId);
      if (mounted) setState(() => _requests = list.cast<Map<String, dynamic>>());
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingRequests = false);
    }
  }

  Future<void> _loadMembers() async {
    setState(() => _loadingMembers = true);
    try {
      final list = await ApiService.getChurchMembers(widget.churchId);
      final status = await ApiService.getMemberOnlineStatus(widget.churchId);
      if (mounted) {
        setState(() {
          _members = list.cast<Map<String, dynamic>>();
          _onlineStatus = status.map((k, v) => MapEntry(k, v as bool));
        });
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _loadEvents() async {
    setState(() => _loadingEvents = true);
    try {
      final list = await ApiService.getChurchEvents(widget.churchId);
      if (mounted) setState(() => _events = list.cast<Map<String, dynamic>>());
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingEvents = false);
    }
  }

  Future<void> _loadPosts() async {
    setState(() => _loadingPosts = true);
    try {
      final list = await ApiService.getChurchPosts(widget.churchId);
      if (mounted) setState(() => _posts = list.cast<Map<String, dynamic>>());
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingPosts = false);
    }
  }

  void _snack(String msg, {Color color = const Color(0xFF10B981)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ── Requests actions ───────────────────────────────────────────────────────

  Future<void> _approveRequest(Map<String, dynamic> req) async {
    try {
      await ApiService.approveJoinRequest(widget.churchId, req['_id']);
      _snack('${req['name']} approved as member!');
      await _loadRequests();
      await _loadMembers();
    } catch (e) { _snack('$e', color: Colors.redAccent); }
  }

  Future<void> _rejectRequest(Map<String, dynamic> req) async {
    try {
      await ApiService.rejectJoinRequest(widget.churchId, req['_id']);
      _snack('Request from ${req['name']} declined.', color: Colors.orange);
      await _loadRequests();
    } catch (e) { _snack('$e', color: Colors.redAccent); }
  }

  // ── Member role sheet ──────────────────────────────────────────────────────

  void _openRoleSheet(Map<String, dynamic> member) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RoleSheet(
        member: member,
        isDark: isDark,
        committeeCount: _members.where((m) => m['role'] == 'committee').length,
        onSelect: (role) async {
          Navigator.pop(context);
          try {
            await ApiService.setMemberRole(widget.churchId, member['_id'], role);
            _snack('Role updated to ${_roleLabel(role)}');
            await _loadMembers();
          } catch (e) { _snack('$e', color: Colors.redAccent); }
        },
        onRemove: () async {
          Navigator.pop(context);
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Remove Member'),
              content: Text('Remove ${member['name']} from the church?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            try {
              await ApiService.removeMember(widget.churchId, member['_id']);
              _snack('${member['name']} removed.', color: Colors.orange);
              await _loadMembers();
            } catch (e) { _snack('$e', color: Colors.redAccent); }
          }
        },
      ),
    );
  }

  // ── Create event ───────────────────────────────────────────────────────────

  void _openCreateEvent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateEventSheet(
        isDark: isDark,
        onCreate: (title, description, date, location) async {
          try {
            await ApiService.createChurchEvent(
              widget.churchId, title, date.toIso8601String(),
              description: description, location: location,
            );
            if (mounted) Navigator.pop(context);
            _snack('Event created!');
            await _loadEvents();
          } catch (e) { _snack('$e', color: Colors.redAccent); }
        },
      ),
    );
  }

  Future<void> _deleteEvent(Map<String, dynamic> event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Delete "${event['title']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ApiService.deleteChurchEvent(widget.churchId, event['_id']);
        _snack('Event deleted.', color: Colors.orange);
        await _loadEvents();
      } catch (e) { _snack('$e', color: Colors.redAccent); }
    }
  }

  // ── Send announcement ──────────────────────────────────────────────────────

  Future<void> _sendAnnouncement(String title, String message) async {
    try {
      await ApiService.sendAnnouncement(widget.churchId, title, message);
      _snack('Announcement sent to all members!');
    } catch (e) { _snack('$e', color: Colors.redAccent); }
  }

  // ── Live session ───────────────────────────────────────────────────────────

  void _openGoLiveSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final urlCtrl   = TextEditingController(text: _streamUrl);
    final titleCtrl = TextEditingController(text: _liveTitle);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _GoLiveSheet(
          isDark: isDark,
          isLive: _isLive,
          urlCtrl: urlCtrl,
          titleCtrl: titleCtrl,
          loading: _liveLoading,
          onGoLive: () async {
            final url   = urlCtrl.text.trim();
            final title = titleCtrl.text.trim().isEmpty ? 'Live Service' : titleCtrl.text.trim();
            if (url.isEmpty) return;
            Navigator.pop(ctx);
            setState(() => _liveLoading = true);
            try {
              await ApiService.goLive(widget.churchId, url, title);
              setState(() { _isLive = true; _streamUrl = url; _liveTitle = title; });
              _snack('You are now LIVE! Members have been notified.');
            } catch (e) { _snack('$e', color: Colors.redAccent); }
            finally { setState(() => _liveLoading = false); }
          },
          onEndLive: () async {
            Navigator.pop(ctx);
            setState(() => _liveLoading = true);
            try {
              await ApiService.endLive(widget.churchId);
              setState(() { _isLive = false; _streamUrl = ''; _liveTitle = ''; });
              _snack('Live session ended.', color: Colors.orange);
            } catch (e) { _snack('$e', color: Colors.redAccent); }
            finally { setState(() => _liveLoading = false); }
          },
        ),
      ),
    );
  }

  // ── Post moderation ────────────────────────────────────────────────────────

  Future<void> _approvePost(Map<String, dynamic> post) async {
    try {
      await ApiService.approveChurchPost(post['_id']);
      _snack('Post approved — visible in timeline!');
      await _loadPosts();
    } catch (e) { _snack('$e', color: Colors.redAccent); }
  }

  Future<void> _rejectPost(Map<String, dynamic> post) async {
    try {
      await ApiService.rejectChurchPost(post['_id']);
      _snack('Post removed from My Church.', color: Colors.orange);
      await _loadPosts();
    } catch (e) { _snack('$e', color: Colors.redAccent); }
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final headerBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final pendingReqs = _requests.where((r) => r['status'] == 'pending').length;
    final pendingPosts = _posts.where((p) => p['status'] == 'pending').length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
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
                            Text('Church Management',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
                            Text(widget.churchName,
                                style: TextStyle(fontSize: 12, color: subColor)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: subColor),
                        onPressed: _loadAll,
                        tooltip: 'Refresh',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TabBar(
                    controller: _tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: subColor,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      _BadgeTab(label: 'Requests', badge: pendingReqs),
                      const Tab(text: 'Members'),
                      const Tab(text: 'Events'),
                      const Tab(text: 'Announce'),
                      _BadgeTab(label: 'Posts', badge: pendingPosts),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isLive)
                              Container(
                                width: 8, height: 8,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              ),
                            Text(_isLive ? 'LIVE' : 'Go Live'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.menu_book_outlined, size: 14),
                            const SizedBox(width: 4),
                            Text(_activePlan != null ? 'Plan ✓' : 'Plan'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Content ─────────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  // ── Tab 0: Requests ───────────────────────────────────────
                  _RequestsTab(
                    requests: _requests,
                    loading: _loadingRequests,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    onApprove: _approveRequest,
                    onReject: _rejectRequest,
                  ),

                  // ── Tab 1: Members ────────────────────────────────────────
                  _MembersTab(
                    members: _members,
                    onlineStatus: _onlineStatus,
                    loading: _loadingMembers,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    onTap: _openRoleSheet,
                    onRefreshOnline: () async {
                      try {
                        final status = await ApiService.getMemberOnlineStatus(widget.churchId);
                        setState(() => _onlineStatus = status.map((k, v) => MapEntry(k, v as bool)));
                      } catch (_) {}
                    },
                  ),

                  // ── Tab 2: Events ─────────────────────────────────────────
                  _EventsTab(
                    events: _events,
                    loading: _loadingEvents,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    onCreate: _openCreateEvent,
                    onDelete: _deleteEvent,
                  ),

                  // ── Tab 3: Announce ───────────────────────────────────────
                  _AnnounceTab(
                    memberCount: _members.length,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    isDark: isDark,
                    onSend: _sendAnnouncement,
                  ),

                  // ── Tab 4: Posts ──────────────────────────────────────────
                  _PostsTab(
                    posts: _posts,
                    loading: _loadingPosts,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    onApprove: _approvePost,
                    onReject: _rejectPost,
                  ),

                  // ── Tab 5: Go Live ────────────────────────────────────────
                  _LiveTab(
                    isLive: _isLive,
                    streamUrl: _streamUrl,
                    liveTitle: _liveTitle,
                    loading: _liveLoading,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    memberCount: _members.length,
                    onGoLive: _openGoLiveSheet,
                    onEndLive: () async {
                      setState(() => _liveLoading = true);
                      try {
                        await ApiService.endLive(widget.churchId);
                        setState(() { _isLive = false; _streamUrl = ''; _liveTitle = ''; });
                        _snack('Live session ended.', color: Colors.orange);
                      } catch (e) { _snack('$e', color: Colors.redAccent); }
                      finally { setState(() => _liveLoading = false); }
                    },
                  ),

                  // ── Tab 6: Church Plan ────────────────────────────────────
                  _PlanTab(
                    activePlan: _activePlan,
                    planStats: _planStats,
                    totalMembers: _planTotalMembers,
                    loading: _loadingPlan,
                    isDark: isDark,
                    textColor: textColor,
                    subColor: subColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    churchId: widget.churchId,
                    onRefresh: _loadPlan,
                    onSnack: _snack,
                    onPlanUpdated: () async {
                      await _loadPlan();
                      setState(() {});
                    },
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

// ── Badge tab label ───────────────────────────────────────────────────────────

class _BadgeTab extends StatelessWidget {
  final String label;
  final int badge;
  const _BadgeTab({required this.label, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (badge > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '$badge',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Shared empty state ────────────────────────────────────────────────────────

Widget _empty(IconData icon, String title, String sub, Color subColor, Color textColor) =>
    Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: subColor.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(fontSize: 13, color: subColor)),
        ],
      ),
    );

// ══════════════════════════════════════════════════════════════════════════════
// Tab 0 — Requests
// ══════════════════════════════════════════════════════════════════════════════

class _RequestsTab extends StatelessWidget {
  final List<Map<String, dynamic>> requests;
  final bool loading;
  final Color textColor, subColor, cardBg, borderColor;
  final Future<void> Function(Map<String, dynamic>) onApprove;
  final Future<void> Function(Map<String, dynamic>) onReject;

  const _RequestsTab({
    required this.requests,
    required this.loading,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (requests.isEmpty) {
      return _empty(Icons.how_to_reg_outlined, 'No join requests', 'All requests have been reviewed.', subColor, textColor);
    }

    final pending  = requests.where((r) => r['status'] == 'pending').toList();
    final reviewed = requests.where((r) => r['status'] != 'pending').toList();
    final all = [...pending, ...reviewed];

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: all.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final req = all[i];
          final isPending = req['status'] == 'pending';
          final isApproved = req['status'] == 'approved';
          final user = req['user'] as Map<String, dynamic>? ?? {};
          final name = user['name'] as String? ?? req['name'] as String? ?? 'Member';
          final initials = name.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').take(2).join();
          final ts = DateTime.tryParse(req['createdAt'] as String? ?? '');
          final timeAgo = ts == null ? '' : _timeAgo(ts);

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: Text(initials,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                      Text('Applied $timeAgo', style: TextStyle(fontSize: 11, color: subColor)),
                    ],
                  ),
                ),
                if (isPending) ...[
                  _ActionBtn(label: 'Approve', icon: Icons.check, color: const Color(0xFF10B981),
                      onTap: () => onApprove(req)),
                  const SizedBox(width: 8),
                  _ActionBtn(label: 'Decline', icon: Icons.close, color: Colors.orange,
                      onTap: () => onReject(req)),
                ] else
                  _StatusBadge(
                    label: isApproved ? 'APPROVED' : 'DECLINED',
                    color: isApproved ? const Color(0xFF10B981) : Colors.orange,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'just now';
    if (d.inHours < 1) return '${d.inMinutes}m ago';
    if (d.inDays < 1) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 1 — Members
// ══════════════════════════════════════════════════════════════════════════════

class _MembersTab extends StatelessWidget {
  final List<Map<String, dynamic>> members;
  final Map<String, bool> onlineStatus;
  final bool loading;
  final Color textColor, subColor, cardBg, borderColor;
  final void Function(Map<String, dynamic>) onTap;
  final VoidCallback onRefreshOnline;

  const _MembersTab({
    required this.members,
    required this.onlineStatus,
    required this.loading,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onTap,
    required this.onRefreshOnline,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (members.isEmpty) {
      return _empty(Icons.people_outline, 'No members yet', 'Approve join requests to add members.', subColor, textColor);
    }

    final onlineCount = members.where((m) => onlineStatus[m['_id']] == true).length;

    return Column(
      children: [
        // Summary bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatChip(label: 'Total', value: '${members.length}', color: AppColors.primary),
              _StatChip(label: 'Online', value: '$onlineCount', color: const Color(0xFF10B981)),
              _StatChip(label: 'Secretary',
                  value: '${members.where((m) => m['role'] == 'secretary').length}',
                  color: const Color(0xFF8B5CF6)),
              _StatChip(label: 'Committee',
                  value: '${members.where((m) => m['role'] == 'committee').length}/5',
                  color: const Color(0xFFF59E0B)),
              GestureDetector(
                onTap: onRefreshOnline,
                child: const Icon(Icons.wifi_tethering, size: 18, color: AppColors.primary),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            itemCount: members.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final m = members[i];
              final id = m['_id'] as String? ?? '';
              final name = m['name'] as String? ?? 'Member';
              final role = m['role'] as String? ?? 'member';
              final isOnline = onlineStatus[id] == true;
              final initials = name.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').take(2).join();

              return GestureDetector(
                onTap: () => onTap(m),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: _roleColor(role).withOpacity(0.15),
                            child: Text(initials,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _roleColor(role))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: isOnline ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                shape: BoxShape.circle,
                                border: Border.all(color: cardBg, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)),
                            const SizedBox(height: 2),
                            Text(isOnline ? 'Online' : 'Offline',
                                style: TextStyle(fontSize: 11, color: isOnline ? const Color(0xFF10B981) : subColor)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _roleColor(role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_roleLabel(role),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _roleColor(role))),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 16, color: subColor),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 2 — Events
// ══════════════════════════════════════════════════════════════════════════════

class _EventsTab extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final bool loading;
  final Color textColor, subColor, cardBg, borderColor;
  final VoidCallback onCreate;
  final Future<void> Function(Map<String, dynamic>) onDelete;

  const _EventsTab({
    required this.events,
    required this.loading,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onCreate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onCreate,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? _empty(Icons.event_outlined, 'No events yet', 'Tap + to create your first event.', subColor, textColor)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = events[i];
                    final date = DateTime.tryParse(e['date'] as String? ?? '') ?? DateTime.now();
                    final isPast = date.isBefore(DateTime.now());
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date chip
                          Container(
                            width: 52,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: (isPast ? subColor : AppColors.primary).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _monthAbbr(date.month),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isPast ? subColor : AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: isPast ? subColor : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e['title'] as String? ?? '',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                                if ((e['location'] as String? ?? '').isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, size: 12, color: subColor),
                                        const SizedBox(width: 3),
                                        Text(e['location'] as String, style: TextStyle(fontSize: 12, color: subColor)),
                                      ],
                                    ),
                                  ),
                                if ((e['description'] as String? ?? '').isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(e['description'] as String,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: subColor)),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_weekday(date.weekday)}, ${_monthAbbr(date.month)} ${date.day} · '
                                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 11, color: subColor),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () => onDelete(e),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  static const _months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _days   = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static String _monthAbbr(int m) => _months[m.clamp(1, 12)];
  static String _weekday(int d) => _days[d.clamp(1, 7)];
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 3 — Announce
// ══════════════════════════════════════════════════════════════════════════════

class _AnnounceTab extends StatefulWidget {
  final int memberCount;
  final Color textColor, subColor, cardBg, borderColor;
  final bool isDark;
  final Future<void> Function(String title, String message) onSend;

  const _AnnounceTab({
    required this.memberCount,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.isDark,
    required this.onSend,
  });

  @override
  State<_AnnounceTab> createState() => _AnnounceTabState();
}

class _AnnounceTabState extends State<_AnnounceTab> {
  final _titleCtrl = TextEditingController();
  final _msgCtrl   = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = widget.isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    InputDecoration _dec(String hint, IconData icon) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: widget.subColor, fontSize: 14),
      prefixIcon: Icon(icon, color: widget.subColor, size: 20),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.campaign_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This will send a push notification to all ${widget.memberCount} members.',
                    style: const TextStyle(fontSize: 13, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.subColor)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleCtrl,
            style: TextStyle(fontSize: 14, color: widget.textColor),
            decoration: _dec('e.g. Sunday Service Reminder', Icons.title),
          ),
          const SizedBox(height: 16),

          Text('Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.subColor)),
          const SizedBox(height: 6),
          TextField(
            controller: _msgCtrl,
            maxLines: 5,
            style: TextStyle(fontSize: 14, color: widget.textColor),
            decoration: _dec('Write your announcement here…', Icons.message_outlined),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _sending
                  ? null
                  : () async {
                      final title = _titleCtrl.text.trim();
                      final msg   = _msgCtrl.text.trim();
                      if (title.isEmpty || msg.isEmpty) return;
                      setState(() => _sending = true);
                      await widget.onSend(title, msg);
                      if (mounted) {
                        _titleCtrl.clear();
                        _msgCtrl.clear();
                        setState(() => _sending = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(_sending ? 'Sending…' : 'Send to All Members',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 4 — Posts
// ══════════════════════════════════════════════════════════════════════════════

class _PostsTab extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final bool loading;
  final Color textColor, subColor, cardBg, borderColor;
  final Future<void> Function(Map<String, dynamic>) onApprove;
  final Future<void> Function(Map<String, dynamic>) onReject;

  const _PostsTab({
    required this.posts,
    required this.loading,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    final pending  = posts.where((p) => p['status'] == 'pending').toList();
    final approved = posts.where((p) => p['status'] == 'approved').toList();

    if (posts.isEmpty) {
      return _empty(Icons.article_outlined, 'No posts yet', 'Members\' posts will appear here for review.', subColor, textColor);
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: cardBg,
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: subColor,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Pending (${pending.length})'),
                Tab(text: 'Approved (${approved.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _PostList(posts: pending, textColor: textColor, subColor: subColor,
                    cardBg: cardBg, borderColor: borderColor,
                    emptyLabel: 'No pending posts', onApprove: onApprove, onReject: onReject,
                    showActions: true),
                _PostList(posts: approved, textColor: textColor, subColor: subColor,
                    cardBg: cardBg, borderColor: borderColor,
                    emptyLabel: 'No approved posts', onApprove: onApprove, onReject: onReject,
                    showActions: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final Color textColor, subColor, cardBg, borderColor;
  final String emptyLabel;
  final bool showActions;
  final Future<void> Function(Map<String, dynamic>) onApprove;
  final Future<void> Function(Map<String, dynamic>) onReject;

  const _PostList({
    required this.posts,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.emptyLabel,
    required this.showActions,
    required this.onApprove,
    required this.onReject,
  });

  static String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'just now';
    if (d.inHours < 1) return '${d.inMinutes}m ago';
    if (d.inDays < 1) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(child: Text(emptyLabel, style: TextStyle(fontSize: 14, color: subColor)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final post = posts[i];
        final name = post['authorName'] as String? ?? 'Member';
        final initials = name.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').take(2).join();
        final ts = DateTime.tryParse(post['createdAt'] as String? ?? '');
        final isApproved = post['status'] == 'approved';

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: Text(initials, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                        if (ts != null) Text(_timeAgo(ts), style: TextStyle(fontSize: 11, color: subColor)),
                      ],
                    ),
                  ),
                  if (isApproved)
                    _StatusBadge(label: 'LIVE', color: const Color(0xFF10B981)),
                ],
              ),
              const SizedBox(height: 10),
              Text(post['content'] as String? ?? '',
                  style: TextStyle(fontSize: 14, height: 1.5, color: textColor)),
              if (showActions) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ActionBtn(label: 'Approve', icon: Icons.check_circle_outline,
                        color: const Color(0xFF10B981), onTap: () => onApprove(post)),
                    const SizedBox(width: 8),
                    _ActionBtn(label: 'Remove', icon: Icons.delete_outline,
                        color: Colors.redAccent, onTap: () => onReject(post)),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Role bottom sheet
// ══════════════════════════════════════════════════════════════════════════════

class _RoleSheet extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isDark;
  final int committeeCount;
  final void Function(String role) onSelect;
  final VoidCallback onRemove;

  const _RoleSheet({
    required this.member,
    required this.isDark,
    required this.committeeCount,
    required this.onSelect,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final currentRole = member['role'] as String? ?? 'member';

    final roles = [
      ('member',         'Member',         Icons.person_outline,            AppColors.primary,          'Default church member'),
      ('secretary',      'Secretary',      Icons.edit_note_outlined,        const Color(0xFF8B5CF6),    'Manages church records'),
      ('treasurer',      'Treasurer',      Icons.account_balance_outlined,  const Color(0xFF059669),    'Manages finances'),
      ('committee',      'Committee',      Icons.groups_outlined,           const Color(0xFFF59E0B),
          committeeCount >= 5 && currentRole != 'committee' ? 'Max 5 members reached' : 'Leadership committee (max 5)'),
      ('worship_leader', 'Worship Leader', Icons.music_note_outlined,       const Color(0xFFEC4899),    'Leads worship & music'),
      ('media_team',     'Media Team',     Icons.videocam_outlined,         const Color(0xFF0EA5E9),    'Handles media & streaming'),
      ('choir',          'Choir',          Icons.queue_music_outlined,      const Color(0xFFF97316),    'Choir & vocal team member'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)),
            ),
          ),
          Text('Assign Role — ${member['name'] ?? 'Member'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          Text('Tap a role to assign it', style: TextStyle(fontSize: 13, color: subColor)),
          const SizedBox(height: 16),
          ...roles.map((r) {
            final (value, label, icon, color, desc) = r;
            final isActive = value == currentRole;
            final isDisabled = value == 'committee' && committeeCount >= 5 && currentRole != 'committee';

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: isDisabled ? null : () => onSelect(value),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isActive ? color.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? color.withOpacity(0.4) : borderColor,
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: isDisabled ? subColor : color, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDisabled ? subColor : textColor,
                                )),
                            Text(desc, style: TextStyle(fontSize: 11, color: subColor)),
                          ],
                        ),
                      ),
                      if (isActive)
                        Icon(Icons.check_circle, color: color, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.person_remove_outlined, color: Colors.redAccent, size: 18),
            label: const Text('Remove from Church', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Create event sheet
// ══════════════════════════════════════════════════════════════════════════════

class _CreateEventSheet extends StatefulWidget {
  final bool isDark;
  final Future<void> Function(String title, String description, DateTime date, String location) onCreate;

  const _CreateEventSheet({required this.isDark, required this.onCreate});

  @override
  State<_CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<_CreateEventSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _locCtrl   = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d != null && mounted) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _selectedTime);
    if (t != null && mounted) setState(() => _selectedTime = t);
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = widget.isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = widget.isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final fillColor = widget.isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    InputDecoration _dec(String hint, IconData icon) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: subColor, fontSize: 14),
      prefixIcon: Icon(icon, color: subColor, size: 18),
      filled: true, fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(color: bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)),
                ),
              ),
              Text('Create Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 16),

              Text('Title *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
              const SizedBox(height: 6),
              TextField(controller: _titleCtrl, style: TextStyle(color: textColor, fontSize: 14), decoration: _dec('Event name', Icons.title)),
              const SizedBox(height: 12),

              Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
              const SizedBox(height: 6),
              TextField(controller: _descCtrl, maxLines: 2, style: TextStyle(color: textColor, fontSize: 14), decoration: _dec('Optional details', Icons.notes_outlined)),
              const SizedBox(height: 12),

              Text('Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
              const SizedBox(height: 6),
              TextField(controller: _locCtrl, style: TextStyle(color: textColor, fontSize: 14), decoration: _dec('Venue or address', Icons.location_on_outlined)),
              const SizedBox(height: 12),

              Text('Date & Time *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 16, color: subColor),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_outlined, size: 16, color: subColor),
                            const SizedBox(width: 8),
                            Text(
                              _selectedTime.format(context),
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          if (_titleCtrl.text.trim().isEmpty) return;
                          setState(() => _saving = true);
                          final combined = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          );
                          await widget.onCreate(
                            _titleCtrl.text.trim(),
                            _descCtrl.text.trim(),
                            combined,
                            _locCtrl.text.trim(),
                          );
                          if (mounted) setState(() => _saving = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _saving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create Event', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 5 — Go Live
// ══════════════════════════════════════════════════════════════════════════════

class _LiveTab extends StatelessWidget {
  final bool isLive, loading;
  final String streamUrl, liveTitle;
  final Color textColor, subColor, cardBg, borderColor;
  final int memberCount;
  final VoidCallback onGoLive;
  final VoidCallback onEndLive;

  const _LiveTab({
    required this.isLive,
    required this.loading,
    required this.streamUrl,
    required this.liveTitle,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.memberCount,
    required this.onGoLive,
    required this.onEndLive,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLive
                    ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                    : [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Colors.white, size: 8),
                            SizedBox(width: 5),
                            Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                          ],
                        ),
                      ),
                    const Spacer(),
                    Icon(isLive ? Icons.videocam : Icons.videocam_outlined, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isLive ? (liveTitle.isEmpty ? 'Live Service' : liveTitle) : 'Start a Live Session',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  isLive
                      ? 'Broadcasting to $memberCount members'
                      : 'Broadcast live to all $memberCount church members',
                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (isLive && streamUrl.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stream URL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: subColor)),
                  const SizedBox(height: 4),
                  Text(streamUrl, style: TextStyle(fontSize: 13, color: textColor)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(streamUrl);
                      if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text('Preview Stream', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: loading ? null : (isLive ? onEndLive : onGoLive),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLive ? const Color(0xFFEF4444) : AppColors.primary,
                disabledBackgroundColor: (isLive ? const Color(0xFFEF4444) : AppColors.primary).withOpacity(0.5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(isLive ? Icons.stop_circle_outlined : Icons.play_circle_outline, size: 20),
              label: Text(
                loading ? (isLive ? 'Ending…' : 'Starting…') : (isLive ? 'End Live Session' : 'Go Live'),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          if (!isLive) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: subColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'You can stream via YouTube Live, Zoom, or any platform. Paste the viewer link and all members will be notified instantly.',
                style: TextStyle(fontSize: 12, color: subColor, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Go Live sheet ─────────────────────────────────────────────────────────────

class _GoLiveSheet extends StatelessWidget {
  final bool isDark, isLive, loading;
  final TextEditingController urlCtrl, titleCtrl;
  final VoidCallback onGoLive, onEndLive;

  const _GoLiveSheet({
    required this.isDark,
    required this.isLive,
    required this.loading,
    required this.urlCtrl,
    required this.titleCtrl,
    required this.onGoLive,
    required this.onEndLive,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final fillColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    InputDecoration dec(String hint, IconData icon) => InputDecoration(
      hintText: hint, hintStyle: TextStyle(color: subColor, fontSize: 14),
      prefixIcon: Icon(icon, color: subColor, size: 18),
      filled: true, fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );

    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)),
            ),
          ),
          Text('Go Live', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 6),
          Text('Members will receive a live notification immediately.',
              style: TextStyle(fontSize: 13, color: subColor)),
          const SizedBox(height: 20),
          Text('Session Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
          const SizedBox(height: 6),
          TextField(controller: titleCtrl, style: TextStyle(color: textColor, fontSize: 14),
              decoration: dec('e.g. Sunday Morning Service', Icons.title)),
          const SizedBox(height: 14),
          Text('Stream / Watch URL *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
          const SizedBox(height: 6),
          TextField(controller: urlCtrl, style: TextStyle(color: textColor, fontSize: 14),
              keyboardType: TextInputType.url,
              decoration: dec('https://youtube.com/live/... or zoom link', Icons.link)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: loading ? null : onGoLive,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                disabledBackgroundColor: const Color(0xFFEF4444).withOpacity(0.5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.play_circle_outline, size: 20),
              label: const Text('Start Live Session', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Color _roleColor(String role) => switch (role) {
  'secretary'      => const Color(0xFF8B5CF6),
  'treasurer'      => const Color(0xFF059669),
  'committee'      => const Color(0xFFF59E0B),
  'worship_leader' => const Color(0xFFEC4899),
  'media_team'     => const Color(0xFF0EA5E9),
  'choir'          => const Color(0xFFF97316),
  _                => AppColors.primary,
};

String _roleLabel(String role) => switch (role) {
  'secretary'      => 'Secretary',
  'treasurer'      => 'Treasurer',
  'committee'      => 'Committee',
  'worship_leader' => 'Worship Leader',
  'media_team'     => 'Media Team',
  'choir'          => 'Choir',
  _                => 'Member',
};

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(99)),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
  );
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
      Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color.withOpacity(0.8))),
    ],
  );
}

// ── Plan Tab ──────────────────────────────────────────────────────────────────

class _PlanTab extends StatelessWidget {
  final Map<String, dynamic>? activePlan;
  final Map<String, dynamic> planStats;
  final int totalMembers;
  final bool loading;
  final bool isDark;
  final Color textColor, subColor, cardBg, borderColor;
  final String churchId;
  final VoidCallback onRefresh;
  final void Function(String, {Color color}) onSnack;
  final VoidCallback onPlanUpdated;

  const _PlanTab({
    required this.activePlan,
    required this.planStats,
    required this.totalMembers,
    required this.loading,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.churchId,
    required this.onRefresh,
    required this.onSnack,
    required this.onPlanUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    final days = activePlan == null
        ? <Map<String, dynamic>>[]
        : (activePlan!['days'] as List<dynamic>).cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openSetPlanSheet(context),
              icon: Icon(activePlan == null ? Icons.add : Icons.edit_outlined,
                  size: 18),
              label: Text(activePlan == null ? 'Create Church Plan' : 'Edit / Replace Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          if (activePlan == null) ...[
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 56, color: subColor.withOpacity(0.25)),
                  const SizedBox(height: 12),
                  Text('No Active Plan',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 6),
                  Text('Create a reading plan for all church members.',
                      style: TextStyle(fontSize: 13, color: subColor)),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),

            // Plan overview card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFB6C9BB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      const Text('ACTIVE PLAN',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.white70)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Remove Plan'),
                              content: const Text(
                                  'This will remove the current plan and all member progress. Continue?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Remove',
                                      style: TextStyle(color: Colors.redAccent)),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            try {
                              await ApiService.deleteChurchPlan(churchId);
                              onSnack('Plan removed.', color: Colors.orange);
                              onPlanUpdated();
                            } catch (e) {
                              onSnack('$e', color: Colors.redAccent);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text('Remove',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(activePlan!['title'] as String? ?? '',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  if ((activePlan!['description'] as String? ?? '').isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(activePlan!['description'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                  const SizedBox(height: 8),
                  Text('${days.length} days · $totalMembers members tracking',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Per-day completion stats
            Text('Member Progress per Day',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),

            ...days.map((day) {
              final dayNum = (day['dayNumber'] as num).toInt();
              final count = (planStats[dayNum.toString()] as num?)?.toInt() ?? 0;
              final pct = totalMembers > 0 ? count / totalMembers : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('$dayNum',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day['title'] as String? ?? day['scripture'] as String? ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: textColor),
                                ),
                                Text(day['scripture'] as String? ?? '',
                                    style: TextStyle(
                                        fontSize: 10, color: subColor)),
                              ],
                            ),
                          ),
                          Text('$count / $totalMembers',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: count > 0
                                      ? const Color(0xFF10B981)
                                      : subColor)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 4,
                          backgroundColor: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation(
                            pct == 1
                                ? const Color(0xFF10B981)
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _openSetPlanSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SetPlanSheet(
        isDark: isDark,
        existingPlan: activePlan,
        onSave: (payload) async {
          try {
            await ApiService.setChurchPlan(churchId, payload);
            if (context.mounted) Navigator.pop(context);
            onSnack('Church plan updated!');
            onPlanUpdated();
          } catch (e) {
            onSnack('$e', color: Colors.redAccent);
          }
        },
      ),
    );
  }
}

// ── Set Plan bottom sheet ─────────────────────────────────────────────────────

class _SetPlanSheet extends StatefulWidget {
  final bool isDark;
  final Map<String, dynamic>? existingPlan;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const _SetPlanSheet({
    required this.isDark,
    required this.existingPlan,
    required this.onSave,
  });

  @override
  State<_SetPlanSheet> createState() => _SetPlanSheetState();
}

// ── Preset reading plans catalog ──────────────────────────────────────────────
class _PresetPlan {
  final String title;
  final String description;
  final List<Map<String, String>> days; // {title, scripture, reflection}
  const _PresetPlan({required this.title, required this.description, required this.days});
}

const _presetPlans = [
  _PresetPlan(
    title: '7 Days of Psalms',
    description: 'A week of praise, lament, and trust through the Psalms.',
    days: [
      {'title': 'The Blessed Life', 'scripture': 'Psalm 1', 'reflection': 'Meditate on what it means to delight in God\'s law.'},
      {'title': 'The Shepherd\'s Care', 'scripture': 'Psalm 23', 'reflection': 'Rest in the truth that the Lord is your shepherd.'},
      {'title': 'Thirsting for God', 'scripture': 'Psalm 42', 'reflection': 'Bring your deepest longings honestly before God.'},
      {'title': 'God\'s Forgiveness', 'scripture': 'Psalm 51', 'reflection': 'Receive God\'s cleansing and renewing grace.'},
      {'title': 'Praise in Every Season', 'scripture': 'Psalm 103', 'reflection': 'List the blessings you have received from the Lord.'},
      {'title': 'The Word as a Lamp', 'scripture': 'Psalm 119:1-32', 'reflection': 'How does God\'s Word guide your daily decisions?'},
      {'title': 'Praise the Lord!', 'scripture': 'Psalm 150', 'reflection': 'End the week by offering wholehearted praise to God.'},
    ],
  ),
  _PresetPlan(
    title: 'The Beatitudes — 8 Days',
    description: 'Eight days exploring the heart of Jesus\' Sermon on the Mount.',
    days: [
      {'title': 'Poor in Spirit', 'scripture': 'Matthew 5:3', 'reflection': 'Humility is the gateway to the Kingdom of Heaven.'},
      {'title': 'Those Who Mourn', 'scripture': 'Matthew 5:4', 'reflection': 'Bring your grief to God — He promises comfort.'},
      {'title': 'The Meek', 'scripture': 'Matthew 5:5', 'reflection': 'Meekness is strength under God\'s control.'},
      {'title': 'Hunger for Righteousness', 'scripture': 'Matthew 5:6', 'reflection': 'What are you truly longing for today?'},
      {'title': 'The Merciful', 'scripture': 'Matthew 5:7', 'reflection': 'Who needs your mercy this week?'},
      {'title': 'The Pure in Heart', 'scripture': 'Matthew 5:8', 'reflection': 'Ask God to search and purify your heart.'},
      {'title': 'Peacemakers', 'scripture': 'Matthew 5:9', 'reflection': 'Where is God calling you to make peace?'},
      {'title': 'Persecuted for Righteousness', 'scripture': 'Matthew 5:10-12', 'reflection': 'Rejoice — your reward is great in heaven.'},
    ],
  ),
  _PresetPlan(
    title: 'Fruits of the Spirit — 9 Days',
    description: 'A journey through Galatians 5, one fruit per day.',
    days: [
      {'title': 'Walking by the Spirit', 'scripture': 'Galatians 5:16-18', 'reflection': 'What does it mean to keep in step with the Spirit?'},
      {'title': 'Love', 'scripture': 'Galatians 5:22; 1 Corinthians 13:4-7', 'reflection': 'Reflect on one person you can love more intentionally.'},
      {'title': 'Joy', 'scripture': 'Galatians 5:22; Philippians 4:4-7', 'reflection': 'Joy is not circumstantial — where is your source of joy?'},
      {'title': 'Peace', 'scripture': 'Galatians 5:22; John 14:27', 'reflection': 'Surrender your anxieties to God today.'},
      {'title': 'Patience', 'scripture': 'Galatians 5:22; Romans 5:3-5', 'reflection': 'Where is God building patience in your life?'},
      {'title': 'Kindness', 'scripture': 'Galatians 5:22; Ephesians 4:32', 'reflection': 'One act of kindness can change someone\'s day.'},
      {'title': 'Goodness', 'scripture': 'Galatians 5:22; Micah 6:8', 'reflection': 'How can you pursue goodness in your community?'},
      {'title': 'Faithfulness', 'scripture': 'Galatians 5:22; Lamentations 3:22-23', 'reflection': 'God is faithful — how are you reflecting that to others?'},
      {'title': 'Gentleness & Self-Control', 'scripture': 'Galatians 5:22-25', 'reflection': 'Ask the Spirit to help you bear all nine fruits.'},
    ],
  ),
  _PresetPlan(
    title: 'Holy Week — 7 Days',
    description: 'Walk through the final week of Jesus\' earthly ministry.',
    days: [
      {'title': 'The Triumphal Entry', 'scripture': 'Matthew 21:1-11', 'reflection': 'Hosanna! What does it mean to welcome Jesus as King?'},
      {'title': 'Cleansing the Temple', 'scripture': 'Matthew 21:12-17', 'reflection': 'What needs to be cleansed in your own heart?'},
      {'title': 'The Greatest Commandment', 'scripture': 'Matthew 22:34-40', 'reflection': 'Love God and love others — reflect on both today.'},
      {'title': 'The Last Supper', 'scripture': 'Matthew 26:17-30', 'reflection': 'Remember the covenant Jesus made with His blood.'},
      {'title': 'Gethsemane', 'scripture': 'Matthew 26:36-46', 'reflection': 'Not my will but Yours — surrendering in difficult moments.'},
      {'title': 'The Cross', 'scripture': 'Matthew 27:32-56', 'reflection': 'He bore our sins so we could be made righteous.'},
      {'title': 'The Resurrection', 'scripture': 'Matthew 28:1-10', 'reflection': 'He is risen! What difference does the resurrection make in your life?'},
    ],
  ),
  _PresetPlan(
    title: 'Proverbs Wisdom — 14 Days',
    description: 'Two weeks through the wisdom of Proverbs for daily life.',
    days: [
      {'title': 'The Beginning of Wisdom', 'scripture': 'Proverbs 1:1-7', 'reflection': 'Fear of the Lord is where wisdom starts.'},
      {'title': 'Trusting God\'s Direction', 'scripture': 'Proverbs 3:5-6', 'reflection': 'In which area do you need to trust God more fully?'},
      {'title': 'Guard Your Heart', 'scripture': 'Proverbs 4:23-27', 'reflection': 'What are you allowing into your heart and mind?'},
      {'title': 'Words Matter', 'scripture': 'Proverbs 12:17-19', 'reflection': 'How can your words bring healing today?'},
      {'title': 'Hope Deferred', 'scripture': 'Proverbs 13:12', 'reflection': 'Bring your unmet hopes honestly before God.'},
      {'title': 'Pride and Humility', 'scripture': 'Proverbs 16:18-19', 'reflection': 'Where is pride trying to creep into your life?'},
      {'title': 'A Gentle Answer', 'scripture': 'Proverbs 15:1', 'reflection': 'Practice responding gently in one difficult conversation today.'},
      {'title': 'Faithful Friendship', 'scripture': 'Proverbs 17:17', 'reflection': 'Who is a faithful friend to you? Be one to someone else.'},
      {'title': 'Listening Well', 'scripture': 'Proverbs 18:13', 'reflection': 'Pause before responding — seek to understand first.'},
      {'title': 'Generosity', 'scripture': 'Proverbs 19:17', 'reflection': 'Give with an open hand today.'},
      {'title': 'Integrity in Work', 'scripture': 'Proverbs 22:1', 'reflection': 'A good name is better than great riches — live accordingly.'},
      {'title': 'Discipline and Growth', 'scripture': 'Proverbs 25:28', 'reflection': 'Where do you need to strengthen self-control?'},
      {'title': 'Iron Sharpens Iron', 'scripture': 'Proverbs 27:17', 'reflection': 'Invest in a friendship that makes you better.'},
      {'title': 'The Virtuous Life', 'scripture': 'Proverbs 31:25-30', 'reflection': 'Strength and dignity — clothe yourself in these today.'},
    ],
  ),
  _PresetPlan(
    title: 'Lord\'s Prayer — 7 Days',
    description: 'A week unpacking each phrase of the prayer Jesus taught us.',
    days: [
      {'title': 'Our Father in Heaven', 'scripture': 'Matthew 6:9; Romans 8:15-17', 'reflection': 'You are a child of God — approach Him as Father.'},
      {'title': 'Hallowed Be Your Name', 'scripture': 'Matthew 6:9; Isaiah 6:1-3', 'reflection': 'God\'s name is holy — worship Him with reverence.'},
      {'title': 'Your Kingdom Come', 'scripture': 'Matthew 6:10; Luke 17:20-21', 'reflection': 'Pray for God\'s Kingdom to advance in your community.'},
      {'title': 'Give Us Today Our Daily Bread', 'scripture': 'Matthew 6:11; Exodus 16:15-18', 'reflection': 'Trust God for today\'s provision without hoarding tomorrow\'s.'},
      {'title': 'Forgive Us Our Debts', 'scripture': 'Matthew 6:12; Colossians 3:13', 'reflection': 'Receive forgiveness freely; extend it freely.'},
      {'title': 'Lead Us Not into Temptation', 'scripture': 'Matthew 6:13; 1 Corinthians 10:13', 'reflection': 'Ask God to reveal and guard your areas of vulnerability.'},
      {'title': 'Yours Is the Kingdom', 'scripture': 'Matthew 6:13; Revelation 19:6', 'reflection': 'End the week surrendering all things back to God.'},
    ],
  ),
  _PresetPlan(
    title: 'New Believer Foundation — 10 Days',
    description: 'Core truths of faith for those new to following Christ.',
    days: [
      {'title': 'God\'s Love for You', 'scripture': 'John 3:16-17', 'reflection': 'You are loved unconditionally by God.'},
      {'title': 'The Problem of Sin', 'scripture': 'Romans 3:23; 6:23', 'reflection': 'All have sinned and fall short — but there is hope.'},
      {'title': 'The Gift of Salvation', 'scripture': 'Romans 5:8; Ephesians 2:8-9', 'reflection': 'Salvation is a gift, not something you earn.'},
      {'title': 'New Life in Christ', 'scripture': '2 Corinthians 5:17; John 10:10', 'reflection': 'You are a new creation — old things have passed away.'},
      {'title': 'Talking to God', 'scripture': 'Philippians 4:6-7; Matthew 6:6', 'reflection': 'Prayer is simply an honest conversation with your Father.'},
      {'title': 'The Living Word', 'scripture': '2 Timothy 3:16-17; Psalm 119:105', 'reflection': 'The Bible is God\'s voice to you — read it daily.'},
      {'title': 'The Holy Spirit', 'scripture': 'John 14:16-17; Acts 1:8', 'reflection': 'You are not alone — the Spirit lives in you.'},
      {'title': 'Baptism & Identity', 'scripture': 'Romans 6:3-4; Galatians 3:27', 'reflection': 'Baptism is a public declaration of your new life in Christ.'},
      {'title': 'Community & Church', 'scripture': 'Hebrews 10:24-25; Acts 2:42-47', 'reflection': 'Faith was never meant to be lived alone.'},
      {'title': 'Going and Making Disciples', 'scripture': 'Matthew 28:18-20; Acts 1:8', 'reflection': 'Share what God has done in your life with someone today.'},
    ],
  ),
];

class _SetPlanSheetState extends State<_SetPlanSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  // Each entry: {title, scripture, reflection} TextEditingControllers
  final List<_DayEntry> _dayEntries = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final plan = widget.existingPlan;
    if (plan != null) {
      _titleCtrl.text = plan['title'] as String? ?? '';
      _descCtrl.text  = plan['description'] as String? ?? '';
      for (final d in (plan['days'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        _dayEntries.add(_DayEntry(
          title:      TextEditingController(text: d['title'] as String? ?? ''),
          scripture:  TextEditingController(text: d['scripture'] as String? ?? ''),
          reflection: TextEditingController(text: d['reflection'] as String? ?? ''),
        ));
      }
    }
    if (_dayEntries.isEmpty) _addDay();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    for (final e in _dayEntries) e.dispose();
    super.dispose();
  }

  void _addDay() {
    setState(() => _dayEntries.add(_DayEntry(
      title:      TextEditingController(),
      scripture:  TextEditingController(),
      reflection: TextEditingController(),
    )));
  }

  void _applyPreset(_PresetPlan preset) {
    for (final e in _dayEntries) e.dispose();
    _dayEntries.clear();
    _titleCtrl.text = preset.title;
    _descCtrl.text  = preset.description;
    for (final d in preset.days) {
      _dayEntries.add(_DayEntry(
        title:      TextEditingController(text: d['title'] ?? ''),
        scripture:  TextEditingController(text: d['scripture'] ?? ''),
        reflection: TextEditingController(text: d['reflection'] ?? ''),
      ));
    }
    setState(() {});
  }

  void _showPresetPicker(BuildContext context) {
    final isDark = widget.isDark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, ctrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Choose a Preset Plan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                  const SizedBox(height: 4),
                  Text('Select one to auto-fill all readings.',
                      style: TextStyle(fontSize: 12, color: subColor)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                itemCount: _presetPlans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final p = _presetPlans[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _applyPreset(p);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(Icons.menu_book_rounded,
                                  color: AppColors.primary, size: 22),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textColor)),
                                const SizedBox(height: 3),
                                Text(p.description,
                                    style: TextStyle(fontSize: 12, color: subColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text('${p.days.length} days',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeDay(int idx) {
    setState(() {
      _dayEntries[idx].dispose();
      _dayEntries.removeAt(idx);
    });
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    final days = <Map<String, dynamic>>[];
    for (var i = 0; i < _dayEntries.length; i++) {
      final e = _dayEntries[i];
      final scripture = e.scripture.text.trim();
      if (scripture.isEmpty) continue;
      days.add({
        'dayNumber':  i + 1,
        'title':      e.title.text.trim(),
        'scripture':  scripture,
        'reflection': e.reflection.text.trim(),
      });
    }
    if (days.isEmpty) return;
    setState(() => _saving = true);
    await widget.onSave({
      'title':       title,
      'description': _descCtrl.text.trim(),
      'days':        days,
    });
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
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
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Set Church-Wide Plan',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
                            : const Text('Save',
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
                  // Choose preset
                  OutlinedButton.icon(
                    onPressed: () => _showPresetPicker(context),
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('Choose Preset Plan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Divider(color: borderColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or build custom',
                            style: TextStyle(fontSize: 11, color: subColor)),
                      ),
                      Expanded(child: Divider(color: borderColor)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Plan title
                  Text('Plan Title',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleCtrl,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('e.g. 30 Days Through the Psalms',
                        icon: Icons.menu_book_outlined),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text('Description (optional)',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600, color: subColor)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14, color: textColor),
                    decoration: dec('A short description for the congregation…'),
                  ),
                  const SizedBox(height: 20),

                  // Days
                  Row(
                    children: [
                      Text('Daily Readings',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _addDay,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Day'),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ..._dayEntries.asMap().entries.map((entry) {
                    final i = entry.key;
                    final e = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text('${i + 1}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Day ${i + 1}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textColor)),
                              const Spacer(),
                              if (_dayEntries.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.redAccent, size: 18),
                                  onPressed: () => _removeDay(i),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: e.title,
                            style: TextStyle(fontSize: 13, color: textColor),
                            decoration: dec('Day title (e.g. The Beatitudes)',
                                icon: Icons.title),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: e.scripture,
                            style: TextStyle(fontSize: 13, color: textColor),
                            decoration: dec('Scripture (e.g. Matthew 5:1-12) *',
                                icon: Icons.book_outlined),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: e.reflection,
                            maxLines: 2,
                            style: TextStyle(fontSize: 13, color: textColor),
                            decoration: dec('Reflection / note (optional)'),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayEntry {
  final TextEditingController title, scripture, reflection;
  _DayEntry({required this.title, required this.scripture, required this.reflection});
  void dispose() { title.dispose(); scripture.dispose(); reflection.dispose(); }
}
