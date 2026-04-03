import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import 'update_treasury_account_screen.dart';
import 'treasury_monthly_report_screen.dart';

class TreasuryDetailsScreen extends StatefulWidget {
  const TreasuryDetailsScreen({super.key});

  @override
  State<TreasuryDetailsScreen> createState() =>
      _TreasuryDetailsScreenState();
}

class _TreasuryDetailsScreenState
    extends State<TreasuryDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // Session expiry countdown
  Timer? _sessionTimer;
  Duration _remaining = Duration.zero;

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final session = treasuryAccessNotifier.value;
      if (session == null || session.isExpired) {
        _sessionTimer?.cancel();
        treasuryAccessNotifier.value = null;
        // Auto-pop with expired message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.lock_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Treasury access expired — session locked.'),
                ],
              ),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.maybePop(context);
        }
      } else {
        setState(() => _remaining = session.remaining);
      }
    });
  }

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);
  static const dustyRose = Color(0xFFD8A7B1);

  static const _transactions = [
    _Tx(
      type: 'Sunday Collection',
      date: 'Mar 17, 2024',
      amount: '+\$3,240.00',
      isCredit: true,
      note: '10 AM & 12 PM Services',
    ),
    _Tx(
      type: 'Facility Maintenance',
      date: 'Mar 15, 2024',
      amount: '-\$850.00',
      isCredit: false,
      note: 'AC unit repair — Hall B',
    ),
    _Tx(
      type: 'Special Donation',
      date: 'Mar 12, 2024',
      amount: '+\$1,500.00',
      isCredit: true,
      note: 'Anonymous donor — missions',
    ),
    _Tx(
      type: 'Missions Fund',
      date: 'Mar 10, 2024',
      amount: '+\$620.00',
      isCredit: true,
      note: 'Monthly standing order',
    ),
    _Tx(
      type: 'Utilities',
      date: 'Mar 8, 2024',
      amount: '-\$412.50',
      isCredit: false,
      note: 'Electricity — Feb bill',
    ),
    _Tx(
      type: 'Sunday Collection',
      date: 'Mar 3, 2024',
      amount: '+\$2,980.00',
      isCredit: true,
      note: '9 AM & 11 AM Services',
    ),
    _Tx(
      type: 'Outreach Event',
      date: 'Feb 28, 2024',
      amount: '-\$320.00',
      isCredit: false,
      note: 'Community food drive costs',
    ),
  ];

  static const _budget = [
    _Budget('Worship & Events', 0.28, babyBlue, '\$12,000'),
    _Budget('Missions & Outreach', 0.22, sage, '\$9,427'),
    _Budget('Staff & Salaries', 0.30, AppColors.primary, '\$12,900'),
    _Budget('Facilities', 0.12, Color(0xFFF59E0B), '\$5,142'),
    _Budget('Admin & Other', 0.08, dustyRose, '\$3,381'),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    // Initialise remaining from current session
    final session = treasuryAccessNotifier.value;
    if (session != null && !session.isExpired) {
      _remaining = session.remaining;
    }
    _startSessionTimer();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor =
        isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

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
                    child: Text(
                      'Treasury Details',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const UpdateTreasuryAccountScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '+ Log',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            // Session countdown banner
            if (_remaining > Duration.zero)
              _SessionBanner(remaining: _remaining),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 32),
                child: Column(
                  children: [
                    // Balance hero card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E293B),
                            Color(0xFF0F172A)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Icon(
                                    Icons.account_balance_wallet,
                                    color: AppColors.primary,
                                    size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Church Treasury',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E)
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'VERIFIED',
                                  style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '\$42,850.12',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.trending_up,
                                  size: 14,
                                  color: Color(0xFF22C55E)),
                              const SizedBox(width: 4),
                              const Text(
                                '+\$3,240 this month',
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _BalanceChip(
                                label: 'Income',
                                value: '\$8,340',
                                color: const Color(0xFF22C55E),
                              ),
                              const SizedBox(width: 10),
                              _BalanceChip(
                                label: 'Expenses',
                                value: '\$1,582',
                                color: const Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 10),
                              _BalanceChip(
                                label: 'Pending',
                                value: '\$620',
                                color: const Color(0xFFF59E0B),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Monthly Report button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const TreasuryMonthlyReportScreen()),
                        ),
                        icon: const Icon(Icons.bar_chart, size: 18),
                        label: const Text('View Monthly Report'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                              color: AppColors.primary.withOpacity(0.4)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: TabBar(
                        controller: _tabs,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: subColor,
                        indicator: BoxDecoration(
                          color:
                              AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                        tabs: const [
                          Tab(text: 'Transactions'),
                          Tab(text: 'Budget'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        controller: _tabs,
                        children: [
                          // Transactions tab
                          Column(
                            children: _transactions
                                .map(
                                  (tx) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: cardBg,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                            color: borderColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: (tx.isCredit
                                                      ? const Color(
                                                          0xFF22C55E)
                                                      : const Color(
                                                          0xFFEF4444))
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              tx.isCredit
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              color: tx.isCredit
                                                  ? const Color(
                                                      0xFF22C55E)
                                                  : const Color(
                                                      0xFFEF4444),
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  tx.type,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: textColor,
                                                  ),
                                                ),
                                                Text(
                                                  '${tx.date} · ${tx.note}',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: subColor),
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            tx.amount,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: tx.isCredit
                                                  ? const Color(
                                                      0xFF22C55E)
                                                  : const Color(
                                                      0xFFEF4444),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                          // Budget tab
                          Column(
                            children: [
                              ..._budget.map(
                                (b) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: b.color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(b.label,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: textColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text(
                                            '${(b.pct * 100).round()}%  ${b.amount}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: b.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: b.pct,
                                          backgroundColor: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE5E7EB),
                                          valueColor:
                                              AlwaysStoppedAnimation(
                                                  b.color),
                                          minHeight: 7,
                                        ),
                                      ),
                                    ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _BalanceChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white54, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _Tx {
  final String type;
  final String date;
  final String amount;
  final bool isCredit;
  final String note;

  const _Tx({
    required this.type,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.note,
  });
}

class _SessionBanner extends StatelessWidget {
  final Duration remaining;
  const _SessionBanner({required this.remaining});

  String get _label {
    final m = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = remaining.inSeconds < 120;
    final bg = isWarning ? const Color(0xFFFEF3C7) : const Color(0xFFECFDF5);
    final fg = isWarning ? const Color(0xFF92400E) : const Color(0xFF065F46);
    final icon = isWarning ? Icons.warning_amber_rounded : Icons.timer_outlined;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: bg,
      child: Row(
        children: [
          Icon(icon, color: fg, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isWarning
                  ? 'Treasury access expires in $_label — save your work!'
                  : 'Temporary access active · expires in $_label',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: fg.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Budget {
  final String label;
  final double pct;
  final Color color;
  final String amount;

  const _Budget(this.label, this.pct, this.color, this.amount);
}
