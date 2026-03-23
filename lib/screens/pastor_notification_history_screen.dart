import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'pastor_send_notification_screen.dart';
import 'pastor_notification_engagement_screen.dart';

class PastorNotificationHistoryScreen extends StatefulWidget {
  const PastorNotificationHistoryScreen({super.key});

  @override
  State<PastorNotificationHistoryScreen> createState() =>
      _PastorNotificationHistoryScreenState();
}

class _PastorNotificationHistoryScreenState
    extends State<PastorNotificationHistoryScreen> {
  int _tabIndex = 0;
  final List<String> _tabs = ['All', 'Sent', 'Scheduled', 'Drafts'];

  static const _items = [
    _NotifItem(
      title: 'Sunday Service Reminder',
      audience: 'All Members',
      date: 'Today, 9:14 AM',
      status: 'sent',
      readRate: 0.78,
      readCount: 1340,
      totalCount: 1718,
    ),
    _NotifItem(
      title: 'Mid-Week Prayer Meeting',
      audience: 'Worship Team',
      date: 'Yesterday, 4:30 PM',
      status: 'sent',
      readRate: 0.91,
      readCount: 87,
      totalCount: 96,
    ),
    _NotifItem(
      title: 'Youth Camp Registration',
      audience: 'Youth Ministry',
      date: 'Mar 18, 11:00 AM',
      status: 'scheduled',
      readRate: 0.0,
      readCount: 0,
      totalCount: 214,
    ),
    _NotifItem(
      title: 'Giving Campaign — Q2',
      audience: 'All Members',
      date: 'Mar 17, 3:45 PM',
      status: 'sent',
      readRate: 0.62,
      readCount: 1065,
      totalCount: 1718,
    ),
    _NotifItem(
      title: 'New Small Group Leaders',
      audience: 'Small Group Leaders',
      date: 'Mar 15, 6:00 PM',
      status: 'sent',
      readRate: 0.85,
      readCount: 34,
      totalCount: 40,
    ),
    _NotifItem(
      title: 'Easter Weekend Schedule',
      audience: 'All Members',
      date: 'Draft saved Mar 14',
      status: 'draft',
      readRate: 0.0,
      readCount: 0,
      totalCount: 0,
    ),
    _NotifItem(
      title: 'Volunteer Orientation',
      audience: 'Volunteers',
      date: 'Mar 12, 8:00 AM',
      status: 'sent',
      readRate: 0.74,
      readCount: 118,
      totalCount: 160,
    ),
  ];

  List<_NotifItem> get _filtered {
    if (_tabIndex == 0) return _items;
    final key = _tabs[_tabIndex].toLowerCase();
    return _items.where((e) => e.status == key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Notification History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.search,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                      size: 22),
                ],
              ),
            ),

            // Tab bar
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final active = i == _tabIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _tabIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _tabs[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF6B7280)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 4),

            // Stats bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _StatPill(
                    label: '24 Sent',
                    color: const Color(0xFF22C55E),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _StatPill(
                    label: '2 Scheduled',
                    color: const Color(0xFF3B82F6),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _StatPill(
                    label: '1 Draft',
                    color: subColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 48, color: subColor),
                          const SizedBox(height: 12),
                          Text('No notifications here',
                              style:
                                  TextStyle(color: subColor, fontSize: 14)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final item = _filtered[i];
                        return GestureDetector(
                          onTap: () {
                            if (item.status == 'sent') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PastorNotificationEngagementScreen(
                                    title: item.title,
                                    audience: item.audience,
                                    readRate: item.readRate,
                                    readCount: item.readCount,
                                    totalCount: item.totalCount,
                                    sentDate: item.date,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _StatusDot(status: item.status),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: subColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.group_outlined,
                                        size: 13, color: subColor),
                                    const SizedBox(width: 4),
                                    Text(item.audience,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor)),
                                    const SizedBox(width: 12),
                                    Icon(Icons.schedule,
                                        size: 13, color: subColor),
                                    const SizedBox(width: 4),
                                    Text(item.date,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor)),
                                  ],
                                ),
                                if (item.status == 'sent') ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: item.readRate,
                                            backgroundColor: isDark
                                                ? const Color(0xFF334155)
                                                : const Color(0xFFE5E7EB),
                                            valueColor:
                                                AlwaysStoppedAnimation(
                                              _rateColor(item.readRate),
                                            ),
                                            minHeight: 5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${(item.readRate * 100).round()}% read',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _rateColor(item.readRate),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.readCount} of ${item.totalCount} recipients',
                                    style: TextStyle(
                                        fontSize: 11, color: subColor),
                                  ),
                                ],
                                if (item.status == 'scheduled')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3B82F6)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Scheduled · Tap to edit',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (item.status == 'draft')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: subColor.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Draft · Unsent',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: subColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const PastorSendNotificationScreen()),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'New Notification',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Color _rateColor(double rate) {
    if (rate >= 0.8) return const Color(0xFF22C55E);
    if (rate >= 0.6) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}

class _NotifItem {
  final String title;
  final String audience;
  final String date;
  final String status;
  final double readRate;
  final int readCount;
  final int totalCount;

  const _NotifItem({
    required this.title,
    required this.audience,
    required this.date,
    required this.status,
    required this.readRate,
    required this.readCount,
    required this.totalCount,
  });
}

class _StatPill extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _StatPill(
      {required this.label, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String status;
  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'sent':
        color = const Color(0xFF22C55E);
        break;
      case 'scheduled':
        color = const Color(0xFF3B82F6);
        break;
      default:
        color = const Color(0xFF94A3B8);
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
