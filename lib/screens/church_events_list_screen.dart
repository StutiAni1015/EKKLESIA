import 'package:flutter/material.dart';
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

  static const _events = [
    _Event(
      title: 'Sunday Worship Service',
      date: 'Sun, Mar 23',
      time: '9:00 AM – 11:30 AM',
      location: 'Main Sanctuary',
      category: 'Worship',
      categoryColor: sage,
      gradientColors: [Color(0xFFD3E8D7), Color(0xFFB0C4B1)],
      iconColor: Color(0xFF4A7C59),
      isFree: true,
      isThisWeek: true,
      isThisMonth: true,
      spots: null,
    ),
    _Event(
      title: 'Youth Camp Registration',
      date: 'Fri, Mar 28',
      time: '4:00 PM – 6:00 PM',
      location: 'Fellowship Hall',
      category: 'Youth',
      categoryColor: babyBlue,
      gradientColors: [Color(0xFFCFE2EF), Color(0xFFB9CFDF)],
      iconColor: Color(0xFF2B6CB0),
      isFree: false,
      isThisWeek: true,
      isThisMonth: true,
      spots: 48,
    ),
    _Event(
      title: 'Community Prayer Night',
      date: 'Wed, Mar 26',
      time: '7:00 PM – 9:00 PM',
      location: 'Prayer Room',
      category: 'Prayer',
      categoryColor: dustyRose,
      gradientColors: [Color(0xFFEDD6DC), Color(0xFFD4A5A5)],
      iconColor: Color(0xFF9B4D6A),
      isFree: true,
      isThisWeek: true,
      isThisMonth: true,
      spots: null,
    ),
    _Event(
      title: 'Marriage Enrichment Workshop',
      date: 'Sat, Apr 5',
      time: '10:00 AM – 3:00 PM',
      location: 'Conference Room B',
      category: 'Workshop',
      categoryColor: Color(0xFFF59E0B),
      gradientColors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
      iconColor: Color(0xFFB45309),
      isFree: false,
      isThisWeek: false,
      isThisMonth: true,
      spots: 20,
    ),
    _Event(
      title: 'Baptism Sunday',
      date: 'Sun, Apr 13',
      time: '11:00 AM',
      location: 'Main Sanctuary',
      category: 'Sacrament',
      categoryColor: AppColors.primary,
      gradientColors: [Color(0xFFFDE8DF), Color(0xFFF5C5B0)],
      iconColor: Color(0xFFEC5B13),
      isFree: true,
      isThisWeek: false,
      isThisMonth: true,
      spots: null,
    ),
    _Event(
      title: 'Women\'s Retreat',
      date: 'Fri–Sun, Apr 18–20',
      time: 'Full weekend',
      location: 'Serene Valley Retreat',
      category: 'Retreat',
      categoryColor: sage,
      gradientColors: [Color(0xFFD3E8D7), Color(0xFFB0C4B1)],
      iconColor: Color(0xFF4A7C59),
      isFree: false,
      isThisWeek: false,
      isThisMonth: false,
      spots: 30,
    ),
  ];

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
                      Icon(Icons.event_busy,
                          size: 40, color: subColor),
                      const SizedBox(height: 10),
                      Text('No events in this filter',
                          style: TextStyle(
                              color: subColor, fontSize: 13)),
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
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () => setState(() =>
                                        _registered.add(i)),
                                    style: ElevatedButton.styleFrom(
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
