import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';

class PastorChurchFeedScreen extends StatefulWidget {
  const PastorChurchFeedScreen({super.key});

  @override
  State<PastorChurchFeedScreen> createState() => _PastorChurchFeedScreenState();
}

class _PastorChurchFeedScreenState extends State<PastorChurchFeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
    // Feed starts empty — posts come in from member submissions
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _approve(ChurchPost post) {
    final updated = List<ChurchPost>.from(churchPostsNotifier.value);
    final idx = updated.indexWhere((p) => p.id == post.id);
    if (idx == -1) return;
    updated[idx].status = PostStatus.approved;
    churchPostsNotifier.value = List.from(updated);
    _showSnack('Post approved and published to the feed.', Colors.green);
  }

  void _reject(ChurchPost post) {
    final updated = List<ChurchPost>.from(churchPostsNotifier.value);
    final idx = updated.indexWhere((p) => p.id == post.id);
    if (idx == -1) return;
    updated[idx].status = PostStatus.rejected;
    churchPostsNotifier.value = List.from(updated);
    _showSnack('Post rejected.', Colors.orange);
  }

  void _delete(ChurchPost post) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
            'Are you sure you want to permanently delete this post? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final updated = List<ChurchPost>.from(churchPostsNotifier.value)
                ..removeWhere((p) => p.id == post.id);
              churchPostsNotifier.value = updated;
              _showSnack('Post deleted.', Colors.red);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<ChurchProfile?>(
                          valueListenable: myChurchNotifier,
                          builder: (_, church, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Feed Moderation',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              if (church != null)
                                Text(
                                  church.name,
                                  style: TextStyle(
                                      fontSize: 12, color: subColor),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Badge on pending count (posts + member requests)
                      ValueListenableBuilder<List<ChurchPost>>(
                        valueListenable: churchPostsNotifier,
                        builder: (_, posts, __) =>
                            ValueListenableBuilder<List<MembershipRequest>>(
                          valueListenable: membershipRequestsNotifier,
                          builder: (_, reqs, __) {
                            final pending =
                                posts.where((p) => p.status == PostStatus.pending).length +
                                reqs.where((r) => r.status == MembershipStatus.pending).length;
                            if (pending == 0) return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                '$pending pending',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TabBar(
                    controller: _tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: subColor,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    tabs: const [
                      Tab(text: 'Pending'),
                      Tab(text: 'Approved'),
                      Tab(text: 'Rejected'),
                      Tab(text: 'Members'),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ValueListenableBuilder<List<ChurchPost>>(
                valueListenable: churchPostsNotifier,
                builder: (_, posts, __) {
                  final pending = posts
                      .where((p) => p.status == PostStatus.pending)
                      .toList();
                  final approved = posts
                      .where((p) => p.status == PostStatus.approved)
                      .toList();
                  final rejected = posts
                      .where((p) => p.status == PostStatus.rejected)
                      .toList();

                  return TabBarView(
                    controller: _tab,
                    children: [
                      _PostList(
                        posts: pending,
                        emptyIcon: Icons.hourglass_empty,
                        emptyLabel: 'No pending posts',
                        emptySubLabel:
                            'All submissions have been reviewed.',
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subColor: subColor,
                        isDark: isDark,
                        actions: (post) => [
                          _PostAction(
                            label: 'Approve',
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF10B981),
                            onTap: () => _approve(post),
                          ),
                          _PostAction(
                            label: 'Reject',
                            icon: Icons.cancel_outlined,
                            color: Colors.orange,
                            onTap: () => _reject(post),
                          ),
                          _PostAction(
                            label: 'Delete',
                            icon: Icons.delete_outline,
                            color: Colors.redAccent,
                            onTap: () => _delete(post),
                          ),
                        ],
                      ),
                      _PostList(
                        posts: approved,
                        emptyIcon: Icons.check_circle_outline,
                        emptyLabel: 'No approved posts yet',
                        emptySubLabel: 'Approved posts appear here.',
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subColor: subColor,
                        isDark: isDark,
                        statusBadgeColor: const Color(0xFF10B981),
                        statusBadgeLabel: 'LIVE',
                        actions: (post) => [
                          _PostAction(
                            label: 'Delete',
                            icon: Icons.delete_outline,
                            color: Colors.redAccent,
                            onTap: () => _delete(post),
                          ),
                        ],
                      ),
                      _PostList(
                        posts: rejected,
                        emptyIcon: Icons.block,
                        emptyLabel: 'No rejected posts',
                        emptySubLabel: 'Rejected posts appear here.',
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textColor: textColor,
                        subColor: subColor,
                        isDark: isDark,
                        statusBadgeColor: Colors.orange,
                        statusBadgeLabel: 'REJECTED',
                        actions: (post) => [
                          _PostAction(
                            label: 'Approve',
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF10B981),
                            onTap: () => _approve(post),
                          ),
                          _PostAction(
                            label: 'Delete',
                            icon: Icons.delete_outline,
                            color: Colors.redAccent,
                            onTap: () => _delete(post),
                          ),
                        ],
                      ),
                      // Members tab
                      ValueListenableBuilder<List<MembershipRequest>>(
                        valueListenable: membershipRequestsNotifier,
                        builder: (_, requests, __) => _MembersTab(
                          requests: requests,
                          textColor: textColor,
                          subColor: subColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          isDark: isDark,
                          onApprove: (req) {
                            final updated = List<MembershipRequest>.from(
                                membershipRequestsNotifier.value);
                            updated
                                .firstWhere((r) => r.id == req.id)
                                .status = MembershipStatus.approved;
                            membershipRequestsNotifier.value =
                                List.from(updated);
                            _showSnack(
                                '${req.applicantName} approved as member!',
                                const Color(0xFF10B981));
                          },
                          onReject: (req) {
                            final updated = List<MembershipRequest>.from(
                                membershipRequestsNotifier.value);
                            updated
                                .firstWhere((r) => r.id == req.id)
                                .status = MembershipStatus.rejected;
                            membershipRequestsNotifier.value =
                                List.from(updated);
                            _showSnack(
                                '${req.applicantName}\'s request rejected.',
                                Colors.orange);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Supporting data types ─────────────────────────────────────────────────────

class _PostAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _PostAction(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});
}

// ── Post list widget ──────────────────────────────────────────────────────────

class _PostList extends StatelessWidget {
  final List<ChurchPost> posts;
  final IconData emptyIcon;
  final String emptyLabel;
  final String emptySubLabel;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final bool isDark;
  final Color? statusBadgeColor;
  final String? statusBadgeLabel;
  final List<_PostAction> Function(ChurchPost) actions;

  const _PostList({
    required this.posts,
    required this.emptyIcon,
    required this.emptyLabel,
    required this.emptySubLabel,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.isDark,
    required this.actions,
    this.statusBadgeColor,
    this.statusBadgeLabel,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 48, color: subColor.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(emptyLabel,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(emptySubLabel,
                style: TextStyle(fontSize: 13, color: subColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final post = posts[i];
        final postActions = actions(post);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author row
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: post.authorColor,
                    child: Text(
                      post.authorInitials,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.authorName,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        Text(_timeAgo(post.postedAt),
                            style:
                                TextStyle(fontSize: 11, color: subColor)),
                      ],
                    ),
                  ),
                  if (statusBadgeColor != null && statusBadgeLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBadgeColor!.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                            color: statusBadgeColor!.withOpacity(0.4)),
                      ),
                      child: Text(
                        statusBadgeLabel!,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusBadgeColor),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Content
              Text(
                post.content,
                style: TextStyle(
                    fontSize: 14, height: 1.5, color: textColor),
              ),
              const SizedBox(height: 14),

              // Action buttons
              Row(
                children: postActions
                    .map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: a.onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: a.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: a.color.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(a.icon, size: 14, color: a.color),
                                const SizedBox(width: 5),
                                Text(
                                  a.label,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: a.color),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Members tab ───────────────────────────────────────────────────────────────

class _MembersTab extends StatelessWidget {
  final List<MembershipRequest> requests;
  final Color textColor;
  final Color subColor;
  final Color cardBg;
  final Color borderColor;
  final bool isDark;
  final void Function(MembershipRequest) onApprove;
  final void Function(MembershipRequest) onReject;

  const _MembersTab({
    required this.requests,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.isDark,
    required this.onApprove,
    required this.onReject,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline,
                size: 48, color: subColor.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('No membership requests',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 4),
            Text('Applications will appear here.',
                style: TextStyle(fontSize: 13, color: subColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final req = requests[i];
        final isPending = req.status == MembershipStatus.pending;
        final isApproved = req.status == MembershipStatus.approved;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: req.applicantColor,
                child: Text(
                  req.applicantInitials,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req.applicantName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Text('Applied ${_timeAgo(req.submittedAt)}',
                        style: TextStyle(fontSize: 11, color: subColor)),
                  ],
                ),
              ),
              if (isPending) ...[
                GestureDetector(
                  onTap: () => onApprove(req),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check,
                            size: 14, color: Color(0xFF10B981)),
                        SizedBox(width: 4),
                        Text('Approve',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF10B981))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => onReject(req),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text('Reject',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange)),
                      ],
                    ),
                  ),
                ),
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (isApproved
                            ? const Color(0xFF10B981)
                            : Colors.orange)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    isApproved ? 'MEMBER' : 'REJECTED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isApproved
                          ? const Color(0xFF10B981)
                          : Colors.orange,
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
