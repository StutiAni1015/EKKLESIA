import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TreasuryMonthlyReportScreen extends StatefulWidget {
  const TreasuryMonthlyReportScreen({super.key});

  @override
  State<TreasuryMonthlyReportScreen> createState() =>
      _TreasuryMonthlyReportScreenState();
}

class _TreasuryMonthlyReportScreenState
    extends State<TreasuryMonthlyReportScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  String _selectedPeriod = 'March 2024';
  bool _exporting = false;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  static const _periods = [
    'March 2024',
    'February 2024',
    'January 2024',
    'December 2023',
    'November 2023',
  ];

  static const _incomeCategories = [
    _Category('Sunday Collections', 8340, 0.62, Color(0xFF22C55E)),
    _Category('Special Donations', 2980, 0.22, sage),
    _Category('Missions Giving', 1240, 0.09, babyBlue),
    _Category('Other Income', 480, 0.04, Color(0xFFF59E0B)),
  ];

  static const _expenseCategories = [
    _Category('Staff & Salaries', 4800, 0.49, AppColors.primary),
    _Category('Facility & Utilities', 2100, 0.22, babyBlue),
    _Category('Worship & Events', 1580, 0.16, sage),
    _Category('Missions & Outreach', 890, 0.09, dustyRose),
    _Category('Admin & Other', 392, 0.04, Color(0xFFF59E0B)),
  ];

  static const _monthlyTrend = [
    _MonthData('Oct', 5200, 7100),
    _MonthData('Nov', 6100, 8800),
    _MonthData('Dec', 9200, 11200),
    _MonthData('Jan', 5800, 7600),
    _MonthData('Feb', 7400, 9800),
    _MonthData('Mar', 9762, 13040),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    const totalIncome = 13040;
    const totalExpense = 9762;
    const netBalance = totalIncome - totalExpense;

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
                        Text(
                          'Monthly Report',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _selectedPeriod,
                          style:
                              TextStyle(fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() => _exporting = true);
                      await Future.delayed(
                          const Duration(milliseconds: 1200));
                      if (!mounted) return;
                      setState(() => _exporting = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Report exported as PDF'),
                          backgroundColor: const Color(0xFF22C55E),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: _exporting
                            ? subColor.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _exporting
                              ? borderColor
                              : AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: _exporting
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.download_outlined,
                                    size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'Export',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
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
                    // Period picker
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _periods.length,
                        itemBuilder: (_, i) {
                          final p = _periods[i];
                          final active = p == _selectedPeriod;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPeriod = p),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.primary
                                      : cardBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: active
                                        ? AppColors.primary
                                        : borderColor,
                                  ),
                                ),
                                child: Text(
                                  p,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? Colors.white
                                        : subColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Summary cards
                    Row(
                      children: [
                        _SummaryCard(
                          label: 'Total Income',
                          value: '\$${_fmt(totalIncome)}',
                          color: const Color(0xFF22C55E),
                          icon: Icons.trending_up,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                        const SizedBox(width: 10),
                        _SummaryCard(
                          label: 'Total Expenses',
                          value: '\$${_fmt(totalExpense)}',
                          color: const Color(0xFFEF4444),
                          icon: Icons.trending_down,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.account_balance_wallet,
                                color: Color(0xFF22C55E), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Net Balance',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '+\$${_fmt(netBalance)}',
                                  style: const TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Savings Rate',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 10),
                              ),
                              Text(
                                '${((netBalance / totalIncome) * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6-month trend chart
                    Text(
                      '6-Month Trend',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          _TrendChart(
                            months: _monthlyTrend,
                            animCtrl: _animCtrl,
                            subColor: subColor,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _Legend(
                                  color: const Color(0xFF22C55E),
                                  label: 'Income'),
                              const SizedBox(width: 20),
                              _Legend(
                                  color: const Color(0xFFEF4444),
                                  label: 'Expenses'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Income breakdown
                    Text(
                      'Income Breakdown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children:
                            _incomeCategories.asMap().entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _CategoryBar(
                              category: e.value,
                              total: totalIncome,
                              animCtrl: _animCtrl,
                              textColor: textColor,
                              subColor: subColor,
                              isDark: isDark,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Expense breakdown
                    Text(
                      'Expense Breakdown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children:
                            _expenseCategories.asMap().entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _CategoryBar(
                              category: e.value,
                              total: totalExpense,
                              animCtrl: _animCtrl,
                              textColor: textColor,
                              subColor: subColor,
                              isDark: isDark,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Budget vs Actuals comparison
                    Text(
                      'Budget vs Actuals',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...[
                      ('Sunday Collections', 12000, 8340, const Color(0xFF22C55E)),
                      ('Missions & Outreach', 9427, 890, babyBlue),
                      ('Staff & Salaries', 12900, 4800, AppColors.primary),
                      ('Facilities', 5142, 2100, const Color(0xFFF59E0B)),
                    ].map((item) {
                      final (label, budget, actual, color) = item;
                      final ratio = actual / budget;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
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
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(label,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        )),
                                  ),
                                  Text(
                                    '${(ratio * 100).round()}% used',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: ratio > 0.9
                                          ? const Color(0xFFEF4444)
                                          : ratio > 0.7
                                              ? const Color(0xFFF59E0B)
                                              : color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: ratio.clamp(0.0, 1.0),
                                  backgroundColor: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE5E7EB),
                                  valueColor:
                                      AlwaysStoppedAnimation(color),
                                  minHeight: 7,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$$actual actual',
                                      style: TextStyle(
                                          fontSize: 11, color: subColor)),
                                  Text('\$$budget budget',
                                      style: TextStyle(
                                          fontSize: 11, color: subColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 12),
                    // Footnote
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: sage.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: sage.withOpacity(0.25)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: sage, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This report is generated from recorded transactions only. '
                              'Always cross-reference with your bank statement.',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: subColor,
                                  height: 1.4),
                            ),
                          ),
                        ],
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

  String _fmt(int v) {
    if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(1)}k'
          .replaceAll('.0k', 'k');
    }
    return v.toString();
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(label,
                    style: TextStyle(fontSize: 11, color: subColor)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final _Category category;
  final int total;
  final AnimationController animCtrl;
  final Color textColor;
  final Color subColor;
  final bool isDark;

  const _CategoryBar({
    required this.category,
    required this.total,
    required this.animCtrl,
    required this.textColor,
    required this.subColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animCtrl,
      builder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(category.name,
                    style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                        fontWeight: FontWeight.w500)),
              ),
              Text(
                '\$${(category.amount / 1000).toStringAsFixed(1)}k  '
                '${(category.pct * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: category.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: category.pct * animCtrl.value,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation(category.color),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  final List<_MonthData> months;
  final AnimationController animCtrl;
  final Color subColor;

  const _TrendChart({
    required this.months,
    required this.animCtrl,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    const maxVal = 14000.0;
    const chartHeight = 90.0;

    return AnimatedBuilder(
      animation: animCtrl,
      builder: (_, __) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: months.map((m) {
          final incomeH =
              (m.income / maxVal) * chartHeight * animCtrl.value;
          final expenseH =
              (m.expense / maxVal) * chartHeight * animCtrl.value;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: chartHeight,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Income bar (back)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 6,
                          child: Container(
                            height: incomeH,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E)
                                  .withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ),
                        ),
                        // Expense bar (front)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 6,
                          child: Container(
                            height: expenseH,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFEF4444).withOpacity(0.7),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(m.month,
                      style: TextStyle(fontSize: 10, color: subColor)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
      ],
    );
  }
}

class _Category {
  final String name;
  final int amount;
  final double pct;
  final Color color;
  const _Category(this.name, this.amount, this.pct, this.color);
}

class _MonthData {
  final String month;
  final int expense;
  final int income;
  const _MonthData(this.month, this.expense, this.income);
}
