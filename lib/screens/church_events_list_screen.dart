import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../core/app_colors.dart';

class ChurchEventsListScreen extends StatefulWidget {
  final String churchName;
  final bool embedded;

  const ChurchEventsListScreen({
    super.key,
    this.churchName = 'Grace Community Church',
    this.embedded = false,
  });

  @override
  State<ChurchEventsListScreen> createState() =>
      _ChurchEventsListScreenState();
}

class _ChurchEventsListScreenState
    extends State<ChurchEventsListScreen> {
  int _filterIndex = 0;
  final Set<int> _registered = {};

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  static const _filters = ['All', 'This Week', 'This Month', 'Free'];

  // Events are created by church leaders — no hardcoded events.
  static const List<_Event> _events = [];

  List<_Event> get _filtered {
    switch (_filterIndex) {
      case 1:
        return _events.where((e) => e.isThisWeek).toList();
      case 2:
        return _events.where((e) => e.isThisMonth).toList();
      case 3:
        return _events.where((e) => e.isFree).toList();
      default:
        return _events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor =
        isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    final content = Column(
      children: [
        if (!widget.embedded) ...[
          // Header
          Container(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => Navigator.maybePop(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Church Events',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      Text(
                        widget.churchName,
                        style: TextStyle(
                            fontSize: 11, color: subColor),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.tune, color: subColor, size: 20),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),
        ],

        // Filter chips
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final active = i == _filterIndex;
              return GestureDetector(
                onTap: () => setState(() => _filterIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : cardBg,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : borderColor,
                    ),
                  ),
                  child: Text(
                    _filters[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : subColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Events list
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_outlined,
                          size: 56, color: subColor.withOpacity(0.3)),
                      const SizedBox(height: 14),
                      Text(
                        'No Events Yet',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Events created by your church\nwill appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: subColor, fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final e = _filtered[i];
                    final registered = _registered.contains(i);
                    return Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Event image placeholder
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: e.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(Icons.event,
                                      size: 36,
                                      color: e.iconColor
                                          .withOpacity(0.3)),
                                ),
                                if (e.isFree)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'FREE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3),
                                      decoration: BoxDecoration(
                                        color: e.categoryColor
                                            .withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        e.category,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: e.categoryColor,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (e.spots != null)
                                      Text(
                                        '${e.spots} spots left',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: e.spots! < 25
                                              ? const Color(0xFFF59E0B)
                                              : subColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined,
                                        size: 12, color: subColor),
                                    const SizedBox(width: 4),
                                    Text(e.date,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor)),
                                    const SizedBox(width: 12),
                                    Icon(Icons.schedule,
                                        size: 12, color: subColor),
                                    const SizedBox(width: 4),
                                    Text(e.time,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor)),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        size: 12, color: subColor),
                                    const SizedBox(width: 4),
                                    Text(e.location,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subColor)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () => setState(
                                              () => _registered.add(i)),
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor: registered
                                                ? const Color(0xFF22C55E)
                                                : AppColors.primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            registered
                                                ? '✓ Registered'
                                                : 'Register Now',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 40,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          final now = DateTime.now();
                                          final event = Event(
                                            title: e.title,
                                            description:
                                                '${e.location} · ${e.time}',
                                            startDate: now.add(
                                                const Duration(days: 3)),
                                            endDate: now.add(
                                                const Duration(
                                                    days: 3, hours: 2)),
                                            location: e.location,
                                            allDay: false,
                                          );
                                          Add2Calendar.addEvent2Cal(event);
                                        },
                                        icon: const Icon(
                                            Icons.calendar_today,
                                            size: 13),
                                        label: const Text('Calendar',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w600)),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primary,
                                          side: BorderSide(
                                              color: AppColors.primary
                                                  .withOpacity(0.5)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(bottom: false, child: content),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Event {
  final String title;
  final String date;
  final String time;
  final String location;
  final String category;
  final Color categoryColor;
  final List<Color> gradientColors;
  final Color iconColor;
  final bool isFree;
  final bool isThisWeek;
  final bool isThisMonth;
  final int? spots;

  const _Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.categoryColor,
    required this.gradientColors,
    required this.iconColor,
    required this.isFree,
    required this.isThisWeek,
    required this.isThisMonth,
    required this.spots,
  });
}
