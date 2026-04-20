import 'package:flutter/material.dart';
import '../data/bible_plan_readings.dart';

/// Resets every in-memory notifier to its clean default.
/// Call this at app launch to guarantee a fresh state every time.
void resetAllAppState() {
  isPastorNotifier.value           = false;
  myChurchNotifier.value           = null;
  churchPostsNotifier.value        = [];
  membershipRequestsNotifier.value = [];
  hasJoinedChurchNotifier.value    = false;
  myPrayerRequestsNotifier.value   = [];
  globalPrayerLightsNotifier.value = [];
  savedSermonsNotifier.value       = [];
  churchPaymentMethodsNotifier.value = [];
  treasuryUnlockCodeNotifier.value = null;
  treasuryAccessNotifier.value     = null;
  todayPlanCompletedNotifier.value = false;
  selectedPlanNotifier.value       = null;
  userProfileEmojiNotifier.value   = '🙏';
  emailVerifiedNotifier.value      = false;
  phoneVerifiedNotifier.value      = false;
  faceVerifiedNotifier.value       = false;
  accountVerifiedNotifier.value    = false;
  userNameNotifier.value           = '';
  userCountryNotifier.value        = 'US';
  userCountryIsoNotifier.value     = 'US';
  userStateNotifier.value          = '';
  userStateIsoNotifier.value       = '';
  userCityNotifier.value           = '';
  userCurrencyNotifier.value       = 'USD';
  userCurrencySymbolNotifier.value = '\$';
  signupFullNameNotifier.value     = '';
  signupEmailNotifier.value        = '';
  userLatNotifier.value            = null;   // GPS for church proximity only
  userLngNotifier.value            = null;
  registeredEmailsNotifier.value   = {};
  churchDraftNotifier.value.clear();
}

// ── Pastor / Church management ────────────────────────────────────────────────

/// Whether the current user is a pastor (set when they create a church).
final isPastorNotifier = ValueNotifier<bool>(false);

/// The church this pastor created. null = not created yet.
final myChurchNotifier = ValueNotifier<ChurchProfile?>(null);

/// All posts submitted to the pastor's church feed.
final churchPostsNotifier = ValueNotifier<List<ChurchPost>>([]);

/// Membership join requests awaiting pastor approval.
final membershipRequestsNotifier = ValueNotifier<List<MembershipRequest>>([]);

enum MembershipStatus { pending, approved, rejected }

class MembershipRequest {
  final String id;
  final String applicantName;
  final String applicantInitials;
  final Color applicantColor;
  final DateTime submittedAt;
  MembershipStatus status;

  MembershipRequest({
    required this.id,
    required this.applicantName,
    required this.applicantInitials,
    required this.applicantColor,
    required this.submittedAt,
    this.status = MembershipStatus.pending,
  });
}

class ChurchProfile {
  final String name;
  final String denomination;
  final String location;
  final String description;
  final DateTime createdAt;

  const ChurchProfile({
    required this.name,
    required this.denomination,
    required this.location,
    required this.description,
    required this.createdAt,
  });
}

enum PostStatus { pending, approved, rejected }

class ChurchPost {
  final String id;
  final String authorName;
  final String authorInitials;
  final Color authorColor;
  final String content;
  final DateTime postedAt;
  PostStatus status;

  ChurchPost({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.authorColor,
    required this.content,
    required this.postedAt,
    this.status = PostStatus.pending,
  });
}

// ── Content word filter ───────────────────────────────────────────────────────

/// Returns true if [text] contains any word from the banned list.
/// Case-insensitive, matches whole substrings.
bool containsBannedWords(String text) {
  final lower = text.toLowerCase();
  return _bannedWords.any((w) => lower.contains(w));
}

/// Returns the first detected banned word, or null if clean.
String? firstBannedWord(String text) {
  final lower = text.toLowerCase();
  for (final w in _bannedWords) {
    if (lower.contains(w)) return w;
  }
  return null;
}

const _bannedWords = <String>[
  // Profanity
  'fuck', 'fck', 'f**k', 'f*ck',
  'shit', 'sh*t', 'sht',
  'ass', 'arse',
  'bitch', 'b*tch',
  'bastard',
  'damn', 'damnit',
  'hell', // context-sensitive — kept to flag misuse
  'crap',
  'piss',
  'dick', 'cock', 'cunt',
  'whore', 'slut',
  'motherfucker', 'mf',
  'bullshit',
  // Hate speech / slurs (abbreviated to avoid being explicit)
  'nigger', 'nigga',
  'faggot', 'fag',
  'retard',
  'spic', 'chink', 'kike',
  // Blasphemy
  'goddamn', 'godforsaken',
  // Violence
  'kill yourself', 'kys',
  'suicide',
  'murder',
];

/// User's current device location — set after location permission is granted.
/// null = location not yet obtained or permission denied.
final userLatNotifier = ValueNotifier<double?>(null);
final userLngNotifier = ValueNotifier<double?>(null);

/// Temporary storage for the in-progress signup flow (cleared after account creation).
final signupFullNameNotifier = ValueNotifier<String>('');
final signupEmailNotifier    = ValueNotifier<String>('');

/// In-progress church creation draft — shared across the 4-step creation flow.
final churchDraftNotifier = ValueNotifier<ChurchDraft>(ChurchDraft());

class ChurchDraft {
  String name         = '';
  String denomination = '';
  String address      = '';
  String city         = '';
  String country      = '';
  String phone        = '';
  String email        = '';
  String website      = '';
  String youtube      = '';
  String instagram    = '';
  bool   allowTestimonies = true;

  void clear() {
    name = denomination = address = city = country = '';
    phone = email = website = youtube = instagram = '';
    allowTestimonies = true;
  }
}

/// Profile picture state: null = no photo, emoji string = chosen emoji,
/// otherwise = file path from gallery (not yet implemented).
final userProfileEmojiNotifier = ValueNotifier<String?>('🙏');

// ── Identity verification status ─────────────────────────────────────────
final emailVerifiedNotifier    = ValueNotifier<bool>(false);
final phoneVerifiedNotifier    = ValueNotifier<bool>(false);
final faceVerifiedNotifier     = ValueNotifier<bool>(false);
final accountVerifiedNotifier  = ValueNotifier<bool>(false);

// ── Church payment methods (treasurer / admin) ────────────────────────────
final churchPaymentMethodsNotifier =
    ValueNotifier<List<ChurchPaymentMethod>>([]);

enum PaymentMethodType { upi, card, applePay, paypal, netBanking }

class ChurchPaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String label;   // e.g. "Visa •••• 4242"
  final String detail;  // e.g. "church@okaxis", "paypal@grace.com"
  final bool isPrimary;

  const ChurchPaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.detail,
    this.isPrimary = false,
  });

  String get typeLabel => switch (type) {
        PaymentMethodType.upi        => 'UPI',
        PaymentMethodType.card       => 'Card',
        PaymentMethodType.applePay   => 'Apple Pay',
        PaymentMethodType.paypal     => 'PayPal',
        PaymentMethodType.netBanking => 'Net Banking',
      };

  IconData get typeIcon => switch (type) {
        PaymentMethodType.upi        => Icons.qr_code_2,
        PaymentMethodType.card       => Icons.credit_card,
        PaymentMethodType.applePay   => Icons.phone_iphone,
        PaymentMethodType.paypal     => Icons.account_balance_wallet,
        PaymentMethodType.netBanking => Icons.account_balance,
      };

  Color get typeColor => switch (type) {
        PaymentMethodType.upi        => const Color(0xFF8B5CF6),
        PaymentMethodType.card       => const Color(0xFF2563EB),
        PaymentMethodType.applePay   => const Color(0xFF1C1C1E),
        PaymentMethodType.paypal     => const Color(0xFF003087),
        PaymentMethodType.netBanking => const Color(0xFF059669),
      };
}

// ─────────────────────────────────────────────────────────────────────────────

/// Registry of all emails that have been used to create an account.
/// Used to prevent duplicate email sign-ups client-side.
final registeredEmailsNotifier = ValueNotifier<Set<String>>({});

/// Holds the currently logged-in user's details across the whole app.
/// Set these notifiers from signup / login screens and read them anywhere.

final userNameNotifier = ValueNotifier<String>('');
final userCountryNotifier = ValueNotifier<String>('US');
final userCountryIsoNotifier = ValueNotifier<String>('US');  // ISO-3166-1 alpha-2
final userStateNotifier    = ValueNotifier<String>('');      // state/province name
final userStateIsoNotifier = ValueNotifier<String>('');      // state ISO code
final userCityNotifier     = ValueNotifier<String>('');      // city name
final userCurrencyNotifier = ValueNotifier<String>('USD');
final userCurrencySymbolNotifier = ValueNotifier<String>('\$');

/// Shared list of prayer requests the current user has posted.
final myPrayerRequestsNotifier = ValueNotifier<List<UserPrayer>>([]);

// ── Treasury access control ───────────────────────────────────────────────

/// An active unlock code generated by a pastor or treasurer.
/// null = no code has been generated yet (or it expired / was revoked).
final treasuryUnlockCodeNotifier = ValueNotifier<TreasuryUnlockCode?>(null);

/// The current member's active treasury session.
/// null = locked.  Non-null = unlocked until [TreasuryAccessSession.expiresAt].
final treasuryAccessNotifier = ValueNotifier<TreasuryAccessSession?>(null);

class TreasuryUnlockCode {
  final String code;          // 6-char alphanumeric, e.g. "TRS4K9"
  final int durationMinutes;  // 10 or 15
  final DateTime createdAt;
  final String generatedBy;   // 'Pastor' | 'Treasurer'

  const TreasuryUnlockCode({
    required this.code,
    required this.durationMinutes,
    required this.createdAt,
    required this.generatedBy,
  });

  bool get isExpired =>
      DateTime.now().isAfter(createdAt.add(Duration(minutes: durationMinutes)));

  DateTime get expiresAt =>
      createdAt.add(Duration(minutes: durationMinutes));
}

class TreasuryAccessSession {
  final DateTime expiresAt;

  TreasuryAccessSession({required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration get remaining =>
      isExpired ? Duration.zero : expiresAt.difference(DateTime.now());
}

// ─────────────────────────────────────────────────────────────────────────────

/// True once the user has joined/registered with a church.
final hasJoinedChurchNotifier = ValueNotifier<bool>(false);

// ── Global Prayer Map lights ──────────────────────────────────────────────────

/// A single prayer light placed on the global map.
/// Only the country is stored — never exact coordinates — to protect privacy.
class GlobalPrayerLight {
  final String countryIso;   // ISO 3166-1 alpha-2, e.g. 'US', 'NG'
  final String countryName;  // Display name, e.g. 'United States'
  final DateTime addedAt;
  int prayCount; // increments each time someone prays for it

  GlobalPrayerLight({
    required this.countryIso,
    required this.countryName,
    required this.addedAt,
    this.prayCount = 1,
  });
}

/// Live prayer lights submitted by users (user's own + received from network).
final globalPrayerLightsNotifier = ValueNotifier<List<GlobalPrayerLight>>([]);

/// User's saved/downloaded sermons (empty on first launch).
final savedSermonsNotifier = ValueNotifier<List<SavedSermon>>([]);

class SavedSermon {
  final String title;
  final String pastor;
  final String date;
  final String duration;
  final String category;

  const SavedSermon({
    required this.title,
    required this.pastor,
    required this.date,
    required this.duration,
    required this.category,
  });
}

class UserPrayer {
  final String body;
  final bool isAnonymous;
  final DateTime addedAt;
  bool isAnswered;

  UserPrayer({
    required this.body,
    required this.isAnonymous,
    required this.addedAt,
    this.isAnswered = false,
  });
}

/// True when the user has completed today's reading checklist.
/// Reset to false when a new day starts (or on app restart — in-memory only).
final todayPlanCompletedNotifier = ValueNotifier<bool>(false);

/// null = no plan selected yet (clean first-launch state).
final selectedPlanNotifier = ValueNotifier<BiblePlan?>(null);

class BiblePlan {
  final String title;
  final int totalDays;
  final int daysCompleted;
  /// Optional override readings (used by non-Bible-in-a-Year plans).
  final List<String> _overrideReadings;

  BiblePlan({
    required this.title,
    required this.totalDays,
    required this.daysCompleted,
    List<String> todayReadings = const [],
  }) : _overrideReadings = todayReadings;

  /// Today's readings — auto-computed from the 365-day schedule for the
  /// default "Bible in a Year" plan; uses the override list for all others.
  List<String> get todayReadings {
    if (totalDays == 365 && _overrideReadings.isEmpty) {
      final day = (daysCompleted + 1).clamp(1, 365);
      return getReadingsForDay(day);
    }
    return _overrideReadings;
  }

  /// Convenience: first reading label (used by legacy widgets).
  String get todayReading =>
      todayReadings.isNotEmpty ? todayReadings.first : '';

  double get progress =>
      totalDays == 0 ? 0.0 : (daysCompleted / totalDays).clamp(0.0, 1.0);

  String get progressLabel => '${(progress * 100).round()}% DONE';

  String get dayLabel => 'Day $daysCompleted of $totalDays';

  BiblePlan copyWith({
    String? title,
    int? totalDays,
    int? daysCompleted,
    List<String>? todayReadings,
  }) =>
      BiblePlan(
        title: title ?? this.title,
        totalDays: totalDays ?? this.totalDays,
        daysCompleted: daysCompleted ?? this.daysCompleted,
        todayReadings: todayReadings ?? _overrideReadings,
      );
}
