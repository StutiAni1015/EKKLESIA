import 'package:flutter/material.dart';
import '../core/app_colors.dart';

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
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  int _selectedIndex = 0;

  static const _notifications = [
    _NotifData(
      church: 'Grace Global Church',
      icon: Icons.church,
      iconColor: Color(0xFFEC5B13),
      title: 'Sunday Service Reminder',
      body:
          'Join us this Sunday at 9:00 AM for our weekly worship service. Pastor Samuel will be preaching on "Walking in Faith." Bring a friend!',
      time: 'Just now',
      category: 'Service',
      categoryColor: Color(0xFFEC5B13),
      isNew: true,
    ),
    _NotifData(
      church: 'Grace Global Church',
      icon: Icons.favorite,
      iconColor: Color(0xFFEC4899),
      title: 'New Prayer Request',
      body:
          'A member of your community has shared a prayer request. Tap to read and pray along with the community.',
      time: '2 hours ago',
      category: 'Prayer',
      categoryColor: Color(0xFFEC4899),
      isNew: true,
    ),
    _NotifData(
      church: 'Grace Global Church',
      icon: Icons.event,
      iconColor: Color(0xFF3B82F6),
      title: 'Youth Camp Registration Open',
      body:
          'Registration for the Annual Youth Camp is now open! Spaces are limited — sign up before March 25 to secure your spot.',
      time: 'Yesterday',
      category: 'Event',
      categoryColor: Color(0xFF3B82F6),
      isNew: false,
    ),
    _NotifData(
      church: 'Grace Global Church',
      icon: Icons.volunteer_activism,
      iconColor: Color(0xFF22C55E),
      title: 'Giving Campaign — Q2',
      body:
          'Our Q2 giving campaign is live! Your generosity helps us reach more people with the gospel. Every contribution matters.',
      time: '2 days ago',
      category: 'Giving',
      categoryColor: Color(0xFF22C55E),
      isNew: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slide = Tween<Offset>(
            begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entryCtrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn);
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final newCount =
        _notifications.where((n) => n.isNew).length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  if (newCount > 0)
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // New badge banner
            if (newCount > 0)
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.12),
                          AppColors.primary.withOpacity(0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$newCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$newCount new notification${newCount > 1 ? 's' : ''} from your church',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.notifications_active,
                            color: AppColors.primary, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Notification list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final n = _notifications[i];
                  final isSelected = i == _selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: n.isNew
                              ? AppColors.primary.withOpacity(0.25)
                              : (isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE5E7EB)),
                          width: n.isNew ? 1.5 : 1,
                        ),
                        boxShadow: n.isNew
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
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
                                // Icon circle
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color:
                                        n.iconColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(n.icon,
                                      color: n.iconColor, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              n.title,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                          if (n.isNew)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              margin: const EdgeInsets.only(
                                                  left: 6, top: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        n.church,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: subColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(14, 10, 14, 0),
                            child: Text(
                              n.body,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.55,
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF374151),
                              ),
                              maxLines: isSelected ? null : 2,
                              overflow: isSelected
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: n.categoryColor
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    n.category,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: n.categoryColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  n.time,
                                  style: TextStyle(
                                      fontSize: 11, color: subColor),
                                ),
                                if (n.isNew) ...[
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'Dismiss',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: subColor,
                                        decoration:
                                            TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected && n.isNew)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 0, 14, 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF0F172A)
                                              : const Color(0xFFF1F5F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'View Details',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Respond',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }
}

class _NotifData {
  final String church;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final String category;
  final Color categoryColor;
  final bool isNew;

  const _NotifData({
    required this.church,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.category,
    required this.categoryColor,
    required this.isNew,
  });
}
