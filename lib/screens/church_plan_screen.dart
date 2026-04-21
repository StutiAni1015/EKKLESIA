import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../service/api_service.dart';

class ChurchPlanScreen extends StatefulWidget {
  final String churchId;
  final String churchName;

  const ChurchPlanScreen({
    super.key,
    required this.churchId,
    required this.churchName,
  });

  @override
  State<ChurchPlanScreen> createState() => _ChurchPlanScreenState();
}

class _ChurchPlanScreenState extends State<ChurchPlanScreen> {
  Map<String, dynamic>? _plan;
  Set<int> _completedDays = {};
  bool _loading = true;
  Set<int> _toggling = {}; // days currently being toggled (prevents double tap)

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ApiService.getChurchPlan(widget.churchId);
      if (mounted) {
        setState(() {
          _plan = result['plan'] as Map<String, dynamic>?;
          final raw = result['completedDays'] as List<dynamic>? ?? [];
          _completedDays = raw.map((e) => (e as num).toInt()).toSet();
        });
      }
    } catch (e) {
      _snack('$e', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleDay(int dayNumber) async {
    if (_toggling.contains(dayNumber)) return;
    setState(() => _toggling.add(dayNumber));
    try {
      final updated = await ApiService.toggleChurchPlanDay(widget.churchId, dayNumber);
      if (mounted) {
        setState(() => _completedDays = updated.toSet());
      }
    } catch (e) {
      _snack('$e', error: true);
    } finally {
      if (mounted) setState(() => _toggling.remove(dayNumber));
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Which day is "today" based on startDate
  int? get _todayDayNumber {
    if (_plan == null) return null;
    final raw = _plan!['startDate'] as String?;
    if (raw == null) return null;
    final start = DateTime.tryParse(raw);
    if (start == null) return null;
    final diff = DateTime.now().difference(start).inDays + 1;
    final total = (_plan!['days'] as List<dynamic>).length;
    if (diff < 1 || diff > total) return null;
    return diff;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final headerBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final days = _plan == null
        ? <Map<String, dynamic>>[]
        : (_plan!['days'] as List<dynamic>).cast<Map<String, dynamic>>();
    final total = days.length;
    final completed = _completedDays.length;
    final todayDay = _todayDayNumber;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: headerBg,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('Church Plan',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            Text(widget.churchName,
                                style: TextStyle(fontSize: 12, color: subColor)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: subColor),
                        onPressed: _load,
                      ),
                    ],
                  ),
                  if (_plan != null && total > 0) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$completed / $total days completed',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                              Text('${total > 0 ? (completed * 100 ~/ total) : 0}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: total > 0 ? completed / total : 0,
                              minHeight: 6,
                              backgroundColor: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Body
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _plan == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.menu_book_outlined,
                                  size: 56, color: subColor.withOpacity(0.3)),
                              const SizedBox(height: 16),
                              Text('No Plan Set',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor)),
                              const SizedBox(height: 6),
                              Text('Your pastor hasn\'t set a church plan yet.',
                                  style: TextStyle(fontSize: 13, color: subColor)),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: CustomScrollView(
                            slivers: [
                              // Plan title card
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
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
                                            const Icon(Icons.menu_book,
                                                color: Colors.white, size: 18),
                                            const SizedBox(width: 8),
                                            const Text('CHURCH-WIDE PLAN',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.5,
                                                    color: Colors.white70)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _plan!['title'] as String? ?? '',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        if ((_plan!['description'] as String? ?? '').isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            _plan!['description'] as String,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white70,
                                                height: 1.4),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        Text('$total days · $completed completed',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Today's reading highlight
                              if (todayDay != null)
                                SliverToBoxAdapter(
                                  child: _TodayBanner(
                                    day: days.firstWhere(
                                        (d) => (d['dayNumber'] as num).toInt() == todayDay,
                                        orElse: () => {}),
                                    isDark: isDark,
                                    isCompleted: _completedDays.contains(todayDay),
                                    isToggling: _toggling.contains(todayDay),
                                    onToggle: () => _toggleDay(todayDay),
                                  ),
                                ),

                              // Day list
                              SliverPadding(
                                padding: EdgeInsets.fromLTRB(
                                    16, 8, 16,
                                    MediaQuery.of(context).padding.bottom + 24),
                                sliver: SliverList.separated(
                                  itemCount: days.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (_, i) {
                                    final day = days[i];
                                    final dayNum =
                                        (day['dayNumber'] as num).toInt();
                                    final done = _completedDays.contains(dayNum);
                                    final isToday = dayNum == todayDay;
                                    final isToggling = _toggling.contains(dayNum);

                                    return _DayCard(
                                      day: day,
                                      dayNum: dayNum,
                                      isDone: done,
                                      isToday: isToday,
                                      isToggling: isToggling,
                                      isDark: isDark,
                                      textColor: textColor,
                                      subColor: subColor,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      onToggle: () => _toggleDay(dayNum),
                                    );
                                  },
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

// ── Today's reading banner ────────────────────────────────────────────────────

class _TodayBanner extends StatelessWidget {
  final Map<String, dynamic> day;
  final bool isDark;
  final bool isCompleted;
  final bool isToggling;
  final VoidCallback onToggle;

  const _TodayBanner({
    required this.day,
    required this.isDark,
    required this.isCompleted,
    required this.isToggling,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (day.isEmpty) return const SizedBox.shrink();
    final accent = const Color(0xFFF59E0B);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accent.withOpacity(isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny_outlined,
                    size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                const Text("TODAY'S READING",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFFF59E0B))),
                const Spacer(),
                GestureDetector(
                  onTap: isToggling ? null : onToggle,
                  child: isToggling
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFF10B981)))
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: isCompleted
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFF59E0B),
                            ),
                          ),
                          child: Text(
                            isCompleted ? '✓ Done' : 'Mark Done',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? Colors.white
                                    : const Color(0xFFF59E0B)),
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              day['title'] as String? ?? '',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B)),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.book_outlined,
                    size: 13, color: Color(0xFFF59E0B)),
                const SizedBox(width: 5),
                Text(
                  day['scripture'] as String? ?? '',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF59E0B)),
                ),
              ],
            ),
            if ((day['reflection'] as String? ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                day['reflection'] as String,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    height: 1.4,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Individual day card ───────────────────────────────────────────────────────

class _DayCard extends StatelessWidget {
  final Map<String, dynamic> day;
  final int dayNum;
  final bool isDone;
  final bool isToday;
  final bool isToggling;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final Color cardBg;
  final Color borderColor;
  final VoidCallback onToggle;

  const _DayCard({
    required this.day,
    required this.dayNum,
    required this.isDone,
    required this.isToday,
    required this.isToggling,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final title = day['title'] as String? ?? '';
    final scripture = day['scripture'] as String? ?? '';
    final reflection = day['reflection'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFF10B981).withOpacity(isDark ? 0.08 : 0.05)
            : cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? const Color(0xFF10B981).withOpacity(0.3)
              : isToday
                  ? const Color(0xFFF59E0B).withOpacity(0.4)
                  : borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day number circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFF10B981)
                  : isToday
                      ? const Color(0xFFF59E0B).withOpacity(0.12)
                      : AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Center(
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isToday
                            ? const Color(0xFFF59E0B)
                            : AppColors.primary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDone
                              ? const Color(0xFF10B981)
                              : textColor,
                          decoration: isDone
                              ? TextDecoration.none
                              : TextDecoration.none)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.book_outlined,
                        size: 12,
                        color: isDone
                            ? const Color(0xFF10B981)
                            : AppColors.primary),
                    const SizedBox(width: 4),
                    Text(scripture,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDone
                                ? const Color(0xFF10B981)
                                : AppColors.primary)),
                  ],
                ),
                if (reflection.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(reflection,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11,
                          color: subColor,
                          height: 1.4,
                          fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),
          // Checkbox
          GestureDetector(
            onTap: isToggling ? null : onToggle,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: isToggling
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFF10B981)))
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFF10B981)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDone
                              ? const Color(0xFF10B981)
                              : const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
