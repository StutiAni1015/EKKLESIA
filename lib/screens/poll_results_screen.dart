import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PollResultsScreen extends StatefulWidget {
  final String question;
  final List<_PollOption> options;
  final int totalVotes;
  final String closesAt;
  final bool isActive;

  const PollResultsScreen({
    super.key,
    this.question =
        'What time should Sunday service start?',
    this.options = const [
      _PollOption(label: '8:00 AM', votes: 48),
      _PollOption(label: '9:00 AM', votes: 142),
      _PollOption(label: '10:30 AM', votes: 87),
      _PollOption(label: '11:00 AM', votes: 34),
    ],
    this.totalVotes = 311,
    this.closesAt = 'Mar 25, 2024',
    this.isActive = true,
  });

  @override
  State<PollResultsScreen> createState() =>
      _PollResultsScreenState();
}

class _PollResultsScreenState extends State<PollResultsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final List<Animation<double>> _barAnims;
  int? _myVote;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  final _barColors = const [
    Color(0xFF22C55E),
    AppColors.primary,
    Color(0xFF3B82F6),
    Color(0xFFF59E0B),
    Color(0xFFD8A7B1),
    Color(0xFFB6C9BB),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _barAnims = widget.options.map((o) {
      final pct = o.votes / widget.totalVotes;
      return Tween<double>(begin: 0, end: pct).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic),
      );
    }).toList();
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  int get _winnerIndex {
    int maxIdx = 0;
    for (int i = 1; i < widget.options.length; i++) {
      if (widget.options[i].votes > widget.options[maxIdx].votes) {
        maxIdx = i;
      }
    }
    return maxIdx;
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
    final winner = _winnerIndex;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                        Text('Poll Results',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        Text(
                          '${widget.totalVotes} votes · closes ${widget.closesAt}',
                          style: TextStyle(
                              fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? const Color(0xFF22C55E).withOpacity(0.1)
                          : subColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.isActive
                                ? const Color(0xFF22C55E)
                                : subColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.isActive ? 'Active' : 'Closed',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.isActive
                                ? const Color(0xFF22C55E)
                                : subColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: sage.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: sage.withOpacity(0.25)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.how_to_vote_outlined,
                              color: sage, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.question,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Summary stats
                    Row(
                      children: [
                        _SummaryPill(
                          label: 'Total Votes',
                          value: '${widget.totalVotes}',
                          color: AppColors.primary,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 10),
                        _SummaryPill(
                          label: 'Options',
                          value: '${widget.options.length}',
                          color: babyBlue,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 10),
                        _SummaryPill(
                          label: 'Leading',
                          value: widget.options[winner].label,
                          color: const Color(0xFF22C55E),
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Results bars
                    Text(
                      'Results Breakdown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(widget.options.length, (i) {
                      final opt = widget.options[i];
                      final pct = opt.votes / widget.totalVotes;
                      final color = _barColors[
                          i % _barColors.length];
                      final isWinner = i == winner;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: AnimatedBuilder(
                          animation: _barAnims[i],
                          builder: (_, __) => Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius:
                                  BorderRadius.circular(14),
                              border: Border.all(
                                color: isWinner
                                    ? color.withOpacity(0.4)
                                    : borderColor,
                                width: isWinner ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color:
                                            color.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(
                                              65 + i),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        opt.label,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    if (isWinner)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(
                                              0.1),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.emoji_events,
                                                size: 11,
                                                color: color),
                                            const SizedBox(width: 3),
                                            Text(
                                              'Leading',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color: color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(pct * 100).round()}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _barAnims[i].value,
                                    backgroundColor: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE5E7EB),
                                    valueColor:
                                        AlwaysStoppedAnimation(color),
                                    minHeight: 8,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${opt.votes} votes',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: subColor),
                                    ),
                                    if (_myVote == i)
                                      Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              size: 12,
                                              color: color),
                                          const SizedBox(width: 3),
                                          Text(
                                            'Your vote',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: color,
                                                fontWeight:
                                                    FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    if (widget.isActive && _myVote == null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: babyBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: babyBlue.withOpacity(0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.how_to_vote,
                                    color: babyBlue, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Cast Your Vote',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List.generate(
                                widget.options.length,
                                (i) => GestureDetector(
                                  onTap: () =>
                                      setState(() => _myVote = i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: babyBlue.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                          color:
                                              babyBlue.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      widget.options[i].label,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    // Share results
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share results coming soon!'), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating)),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_outlined,
                                color: subColor, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Share Results',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: subColor,
                              ),
                            ),
                          ],
                        ),
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

class _SummaryPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _SummaryPill({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(label,
                style: TextStyle(fontSize: 10, color: subColor)),
          ],
        ),
      ),
    );
  }
}

class _PollOption {
  final String label;
  final int votes;
  const _PollOption({required this.label, required this.votes});
}
