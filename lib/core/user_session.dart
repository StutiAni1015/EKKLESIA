import 'package:flutter/material.dart';

/// Holds the currently logged-in user's details across the whole app.
/// Set these notifiers from signup / login screens and read them anywhere.

final userNameNotifier = ValueNotifier<String>('');
final userCountryNotifier = ValueNotifier<String>('US');
final userCurrencyNotifier = ValueNotifier<String>('USD');
final userCurrencySymbolNotifier = ValueNotifier<String>('\$');

final selectedPlanNotifier = ValueNotifier<BiblePlan>(
  const BiblePlan(
    title: 'Bible in a Year',
    totalDays: 365,
    daysCompleted: 0,
    todayReading: 'Genesis 1–3',
  ),
);

class BiblePlan {
  final String title;
  final int totalDays;
  final int daysCompleted;
  /// The specific Bible passage to read today.
  final String todayReading;

  const BiblePlan({
    required this.title,
    required this.totalDays,
    required this.daysCompleted,
    this.todayReading = '',
  });

  double get progress =>
      totalDays == 0 ? 0.0 : (daysCompleted / totalDays).clamp(0.0, 1.0);

  String get progressLabel =>
      '${(progress * 100).round()}% DONE';

  String get dayLabel => 'Day $daysCompleted of $totalDays';

  BiblePlan copyWith({
    String? title,
    int? totalDays,
    int? daysCompleted,
    String? todayReading,
  }) =>
      BiblePlan(
        title: title ?? this.title,
        totalDays: totalDays ?? this.totalDays,
        daysCompleted: daysCompleted ?? this.daysCompleted,
        todayReading: todayReading ?? this.todayReading,
      );
}
