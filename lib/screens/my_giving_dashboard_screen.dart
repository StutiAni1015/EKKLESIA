import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';
import 'create_giving_request_screen.dart';
import 'location_currency_screen.dart';

class MyGivingDashboardScreen extends StatefulWidget {
  const MyGivingDashboardScreen({super.key});

  @override
  State<MyGivingDashboardScreen> createState() =>
      _MyGivingDashboardScreenState();
}

class _MyGivingDashboardScreenState extends State<MyGivingDashboardScreen> {
  static const _needs = <_FundItem>[];
  static const _history = <_HistoryItem>[];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: userCurrencySymbolNotifier,
      builder: (context, sym, _) => _buildBody(context, sym),
    );
  }

  Widget _buildBody(BuildContext context, String currSym) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: bg.withOpacity(0.8),
                    border: Border(bottom: BorderSide(color: borderColor)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.volunteer_activism,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'My Giving',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      // Currency/location button
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LocationCurrencyScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.language,
                                  color: AppColors.primary, size: 14),
                              const SizedBox(width: 4),
                              ValueListenableBuilder<String>(
                                valueListenable: userCurrencyNotifier,
                                builder: (_, code, __) => Text(
                                  code,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_none,
                            color: textColor),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Giving notifications coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        0, 0, 0, MediaQuery.of(context).padding.bottom + 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats grid
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Given 2024
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Given (2024)',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: subColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${currSym}4,250.00',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: const [
                                          Icon(Icons.trending_up,
                                              color: Color(0xFF10B981),
                                              size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            '+12% vs 2023',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF10B981),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Last Donation
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withOpacity(0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Donation',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: subColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${currSym}150.00',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '2 days ago',
                                        style: TextStyle(
                                          fontSize: 11,
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

                        // Church Needs header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Church Needs',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All giving needs coming soon!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                ),
                                icon: const SizedBox.shrink(),
                                label: Row(
                                  children: const [
                                    Text(
                                      'View all',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Icon(Icons.chevron_right,
                                        color: AppColors.primary, size: 18),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                              ),
                            ],
                          ),
                        ),

                        // Horizontal fund cards
                        SizedBox(
                          height: 290,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            itemCount: _needs.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, i) {
                              final item = _needs[i];
                              final pct = item.raised / item.goal;
                              return _FundCard(
                                item: item,
                                pct: pct,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                subColor: subColor,
                                currSym: currSym,
                              );
                            },
                          ),
                        ),

                        // Recent History
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16, 24, 16, 12),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent History',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Icon(Icons.history,
                                  color: subColor, size: 22),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          child: Column(
                            children: _history
                                .map((h) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10),
                                      child: _HistoryRow(
                                        item: h,
                                        cardBg: cardBg,
                                        borderColor: borderColor,
                                        textColor: textColor,
                                        subColor: subColor,
                                        currSym: currSym,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),

                        // Raise Funds dashed button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CreateGivingRequestScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      AppColors.primary.withOpacity(0.4),
                                  width: 2,
                                  // Note: Flutter doesn't support native dashed borders;
                                  // using solid with low opacity to approximate
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_circle_outline,
                                      color: AppColors.primary),
                                  SizedBox(width: 8),
                                  Text(
                                    'Raise Funds',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
    );
  }
}

class _FundCard extends StatelessWidget {
  final _FundItem item;
  final double pct;
  final Color cardBg;
  final Color borderColor;
  final Color subColor;
  final String currSym;

  const _FundCard({
    required this.item,
    required this.pct,
    required this.cardBg,
    required this.borderColor,
    required this.subColor,
    required this.currSym,
  });

  @override
  Widget build(BuildContext context) {
    final raised = item.raised >= 1000
        ? '$currSym${(item.raised / 1000).toStringAsFixed(0)}k'
        : '$currSym${item.raised}';
    final goal = item.goal >= 1000
        ? '$currSym${(item.goal / 1000).toStringAsFixed(0)}k'
        : '$currSym${item.goal}';

    return Container(
      width: 264,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient image placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [item.gradientStart, item.gradientEnd],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.volunteer_activism,
                    color: Colors.white.withOpacity(0.4),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.subtitle,
            style: TextStyle(fontSize: 12, color: subColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 7,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$raised raised',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Goal: $goal',
                style: TextStyle(fontSize: 11, color: subColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Online giving coming soon! 🙏'),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Support Fund',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final _HistoryItem item;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color subColor;
  final String currSym;

  const _HistoryRow({
    required this.item,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.subColor,
    required this.currSym,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.isGeneral
                  ? const Color(0xFFD1FAE5)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.isGeneral ? Icons.payments : Icons.rocket_launch,
              color: item.isGeneral
                  ? const Color(0xFF059669)
                  : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  item.date,
                  style: TextStyle(fontSize: 11, color: subColor),
                ),
              ],
            ),
          ),
          Text(
            item.amount.replaceFirst('\$', currSym),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}


class _FundItem {
  final String title;
  final String subtitle;
  final int raised;
  final int goal;
  final Color iconColor;
  final Color gradientStart;
  final Color gradientEnd;

  const _FundItem({
    required this.title,
    required this.subtitle,
    required this.raised,
    required this.goal,
    required this.iconColor,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

class _HistoryItem {
  final String label;
  final String date;
  final String amount;
  final bool isGeneral;

  const _HistoryItem({
    required this.label,
    required this.date,
    required this.amount,
    required this.isGeneral,
  });
}
