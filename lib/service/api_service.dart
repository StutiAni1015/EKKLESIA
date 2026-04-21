import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/user_session.dart';

/// Global token notifier — set after login/signup, cleared on logout.
final authTokenNotifier  = ValueNotifier<String?>( null);
final authUserIdNotifier = ValueNotifier<String?>( null);

class ApiService {
  // 127.0.0.1 for iOS simulator; use 10.0.2.2 for Android emulator.
  static const String _base = 'http://127.0.0.1:4000/api';
  static const String baseUrl = 'http://127.0.0.1:4000';

  // ─── helpers ───────────────────────────────────────────────────────────────

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authTokenNotifier.value != null)
          'Authorization': 'Bearer ${authTokenNotifier.value}',
      };

  static Map<String, dynamic> _decode(http.Response r) =>
      jsonDecode(r.body) as Map<String, dynamic>;

  // ─── auth ──────────────────────────────────────────────────────────────────

  /// POST /api/auth/signup
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/auth/signup'),
      headers: _headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Signup failed';
    }
    return body;
  }

  /// POST /api/auth/login
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = _decode(r);
    if (r.statusCode != 200) {
      throw body['message'] ?? 'Login failed';
    }
    authTokenNotifier.value  = body['token']  as String?;
    authUserIdNotifier.value = body['userId'] as String?;
    if (body['name'] != null) {
      userNameNotifier.value = (body['name'] as String).split(' ').first;
    }
    // Load full profile so isPastor, bio, country etc. are available immediately.
    try {
      await fetchAndApplyProfile();
    } catch (e) {
      // Non-fatal — profile will be refreshed when DashboardScreen / ProfileScreen opens.
      debugPrint('[ApiService] fetchAndApplyProfile after login failed: $e');
    }
  }

  /// Fetches /api/user/profile and writes every field into the session notifiers.
  /// Safe to call at login and on session restore.
  static Future<void> fetchAndApplyProfile() async {
    final data = await getProfile();
    _applyProfile(data);
    // If this user is a pastor, load their church ID
    if (isPastorNotifier.value) {
      try {
        final churches = await getMyChurches();
        final pastored = churches['pastored'] as List<dynamic>? ?? [];
        if (pastored.isNotEmpty) {
          final church = pastored.first as Map<String, dynamic>;
          myChurchIdNotifier.value = church['_id'] as String?;
          myChurchNotifier.value = ChurchProfile(
            name: church['name'] as String? ?? '',
            denomination: church['denomination'] as String? ?? '',
            location: '${church['city'] ?? ''}, ${church['country'] ?? ''}'.trim().replaceAll(RegExp(r'^,\s*|,\s*$'), ''),
            description: '',
            createdAt: DateTime.tryParse(church['createdAt'] as String? ?? '') ?? DateTime.now(),
          );
        }
      } catch (_) {}
    }
  }

  /// Writes a profile map (from GET /api/user/profile) into all session notifiers.
  static void _applyProfile(Map<String, dynamic> data) {
    final name = data['name'] as String? ?? '';
    userNameNotifier.value           = name.split(' ').first;
    userBioNotifier.value            = data['bio'] as String? ?? '';
    userCountryNotifier.value        = data['country'] as String? ?? 'US';
    userCountryIsoNotifier.value     = data['countryIso'] as String? ?? 'US';
    userCityNotifier.value           = data['city'] as String? ?? '';
    userCurrencyNotifier.value       = data['currency'] as String? ?? 'USD';
    userCurrencySymbolNotifier.value = data['currencySymbol'] as String? ?? '\$';
    isPastorNotifier.value           = data['isPastor'] as bool? ?? false;
  }

  // ─── user profile ──────────────────────────────────────────────────────────

  /// GET /api/user/profile
  static Future<Map<String, dynamic>> getProfile() async {
    final r = await http.get(Uri.parse('$_base/user/profile'), headers: _headers);
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to load profile';
    return body;
  }

  /// PUT /api/user/profile
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? bio,
    String? country,
    String? countryIso,
    String? city,
    String? currency,
    String? currencySymbol,
    String? avatarUrl,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) payload['name'] = name;
    if (bio != null) payload['bio'] = bio;
    if (country != null) payload['country'] = country;
    if (countryIso != null) payload['countryIso'] = countryIso;
    if (city != null) payload['city'] = city;
    if (currency != null) payload['currency'] = currency;
    if (currencySymbol != null) payload['currencySymbol'] = currencySymbol;
    if (avatarUrl != null) payload['avatarUrl'] = avatarUrl;

    final r = await http.put(
      Uri.parse('$_base/user/profile'),
      headers: _headers,
      body: jsonEncode(payload),
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to update profile';
    return body;
  }

  /// PUT /api/user/change-password
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final r = await http.put(
      Uri.parse('$_base/user/change-password'),
      headers: _headers,
      body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
    );
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to change password';
  }

  /// GET /api/user/privacy — fetch privacy settings
  static Future<Map<String, dynamic>> getPrivacySettings() async {
    final r = await http.get(Uri.parse('$_base/user/privacy'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load privacy settings';
    return _decode(r);
  }

  /// PUT /api/user/privacy — update privacy settings
  static Future<Map<String, dynamic>> updatePrivacySettings(Map<String, bool> settings) async {
    final r = await http.put(
      Uri.parse('$_base/user/privacy'),
      headers: _headers,
      body: jsonEncode(settings),
    );
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to update privacy settings';
    return _decode(r);
  }

  /// GET /api/user/:id — public profile
  static Future<Map<String, dynamic>> getUserById(String userId) async {
    final r = await http.get(Uri.parse('$_base/user/$userId'), headers: _headers);
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to load user';
    return body;
  }

  // ─── prayers ───────────────────────────────────────────────────────────────

  /// GET /api/prayer — community prayers
  static Future<List<dynamic>> getPrayers({String? scope}) async {
    final uri = Uri.parse('$_base/prayer').replace(
      queryParameters: scope != null ? {'scope': scope} : null,
    );
    final r = await http.get(uri, headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load prayers';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// GET /api/prayer/my — current user's prayers
  static Future<List<dynamic>> getMyPrayers() async {
    final r = await http.get(Uri.parse('$_base/prayer/my'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load prayers';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// POST /api/prayer
  static Future<Map<String, dynamic>> createPrayer({
    required String content,
    String title = '',
    String category = 'Other',
    bool isAnonymous = false,
    String scope = 'personal',
  }) async {
    final r = await http.post(
      Uri.parse('$_base/prayer'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
        'isAnonymous': isAnonymous,
        'scope': scope,
      }),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Failed to create prayer';
    }
    return body;
  }

  /// PATCH /api/prayer/:id/answered
  static Future<Map<String, dynamic>> markPrayerAnswered(String prayerId) async {
    final r = await http.patch(
      Uri.parse('$_base/prayer/$prayerId/answered'),
      headers: _headers,
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to mark as answered';
    return body;
  }

  /// DELETE /api/prayer/:id
  static Future<void> deletePrayer(String prayerId) async {
    final r = await http.delete(
      Uri.parse('$_base/prayer/$prayerId'),
      headers: _headers,
    );
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to delete prayer';
  }

  /// POST /api/prayer/:id/like
  static Future<Map<String, dynamic>> likePrayer(String prayerId) async {
    final r = await http.post(
      Uri.parse('$_base/prayer/$prayerId/like'),
      headers: _headers,
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to like prayer';
    return body;
  }

  /// POST /api/prayer/:id/comment
  static Future<Map<String, dynamic>> addComment({
    required String prayerId,
    required String text,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/prayer/$prayerId/comment'),
      headers: _headers,
      body: jsonEncode({'text': text}),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Failed to add comment';
    }
    return body;
  }

  /// DELETE /api/prayer/:prayerId/comment/:commentId
  static Future<void> deleteComment({
    required String prayerId,
    required String commentId,
  }) async {
    final r = await http.delete(
      Uri.parse('$_base/prayer/$prayerId/comment/$commentId'),
      headers: _headers,
    );
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to delete comment';
    }
  }

  // ─── global prayer map ─────────────────────────────────────────────────────

  /// POST /api/global-prayer — submit a prayer to the global map
  static Future<Map<String, dynamic>> submitGlobalPrayer({
    required String title,
    required String body,
    String category = 'Other',
    String location = '',
    String countryIso = '',
    String countryName = '',
    bool isAnonymous = false,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/global-prayer'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'body': body,
        'category': category,
        'location': location,
        'countryIso': countryIso,
        'countryName': countryName,
        'isAnonymous': isAnonymous,
      }),
    );
    final res = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw res['message'] ?? 'Failed to submit global prayer';
    }
    return res;
  }

  /// GET /api/global-prayer — recent global prayers
  static Future<List<dynamic>> getGlobalPrayers({int limit = 20}) async {
    final uri = Uri.parse('$_base/global-prayer')
        .replace(queryParameters: {'limit': '$limit'});
    final r = await http.get(uri, headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load global prayers';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// GET /api/global-prayer/stats
  static Future<Map<String, dynamic>> getGlobalPrayerStats() async {
    final r = await http.get(
      Uri.parse('$_base/global-prayer/stats'),
      headers: _headers,
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to load stats';
    return body;
  }

  /// GET /api/global-prayer/map — country prayer counts
  static Future<List<dynamic>> getGlobalPrayerMap() async {
    final r = await http.get(
      Uri.parse('$_base/global-prayer/map'),
      headers: _headers,
    );
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load map data';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// POST /api/global-prayer/:id/pray
  static Future<Map<String, dynamic>> prayForGlobal(String prayerId) async {
    final r = await http.post(
      Uri.parse('$_base/global-prayer/$prayerId/pray'),
      headers: _headers,
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed';
    return body;
  }

  // ─── notifications ─────────────────────────────────────────────────────────

  /// GET /api/notifications
  static Future<List<dynamic>> getNotifications() async {
    final r = await http.get(
        Uri.parse('$_base/notifications'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load notifications';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// GET /api/notifications/unread/count
  static Future<int> getUnreadCount() async {
    final r = await http.get(
        Uri.parse('$_base/notifications/unread/count'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load unread count';
    }
    return (_decode(r)['unreadCount'] as num).toInt();
  }

  /// PUT /api/notifications/:id/read
  static Future<void> markNotificationRead(String id) async {
    final r = await http.put(
        Uri.parse('$_base/notifications/$id/read'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to mark notification read';
    }
  }

  /// DELETE /api/notifications/:id
  static Future<void> deleteNotification(String id) async {
    final r = await http.delete(
        Uri.parse('$_base/notifications/$id'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to delete notification';
    }
  }

  // ─── journal ───────────────────────────────────────────────────────────────

  /// POST /api/journal
  static Future<Map<String, dynamic>> createJournal({
    required String content,
    String title = '',
  }) async {
    final r = await http.post(
      Uri.parse('$_base/journal'),
      headers: _headers,
      body: jsonEncode({'title': title, 'content': content}),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Failed to create journal entry';
    }
    return body;
  }

  /// GET /api/journal
  static Future<List<dynamic>> getJournals() async {
    final r = await http.get(Uri.parse('$_base/journal'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load journal entries';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// PUT /api/journal/:id
  static Future<Map<String, dynamic>> updateJournal({
    required String id,
    required String title,
    required String content,
  }) async {
    final r = await http.put(
      Uri.parse('$_base/journal/$id'),
      headers: _headers,
      body: jsonEncode({'title': title, 'content': content}),
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to update journal entry';
    return body;
  }

  /// DELETE /api/journal/:id
  static Future<void> deleteJournal(String id) async {
    final r = await http.delete(
      Uri.parse('$_base/journal/$id'),
      headers: _headers,
    );
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to delete journal entry';
    }
  }

  // ─── church ────────────────────────────────────────────────────────────────

  /// POST /api/church — create a new church
  static Future<Map<String, dynamic>> createChurch({
    required String name,
    required String denomination,
    required String address,
    required String city,
    required String country,
    String  phone           = '',
    String  email           = '',
    String  website         = '',
    String  youtube         = '',
    String  instagram       = '',
    bool    allowTestimonies = true,
    double? lat,
    double? lng,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/church'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'denomination': denomination,
        'address': address,
        'city': city,
        'country': country,
        'phone': phone,
        'email': email,
        'website': website,
        'youtube': youtube,
        'instagram': instagram,
        'allowTestimonies': allowTestimonies,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      }),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Failed to create church';
    }
    return body;
  }

  /// GET /api/church?q=query — search churches
  static Future<List<dynamic>> getChurches({String query = ''}) async {
    final uri = Uri.parse('$_base/church').replace(
      queryParameters: query.isNotEmpty ? {'q': query} : null,
    );
    final r = await http.get(uri, headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load churches';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// GET /api/church/my — joined + pastored churches for current user
  static Future<Map<String, dynamic>> getMyChurches() async {
    final r = await http.get(Uri.parse('$_base/church/my'), headers: _headers);
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to load your churches';
    return body;
  }

  /// POST /api/church/:id/join
  static Future<Map<String, dynamic>> joinChurch(String churchId) async {
    final r = await http.post(
      Uri.parse('$_base/church/$churchId/join'),
      headers: _headers,
    );
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to join church';
    return body;
  }

  /// DELETE /api/church/:id/leave
  static Future<void> leaveChurch(String churchId) async {
    final r = await http.delete(
      Uri.parse('$_base/church/$churchId/leave'),
      headers: _headers,
    );
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to leave church';
    }
  }

  // ─── giving ────────────────────────────────────────────────────────────────

  /// POST /api/giving
  static Future<Map<String, dynamic>> createGiving({
    required String title,
    required double amount,
    String currency = 'USD',
    String currencySymbol = '\$',
    String category = 'other',
    String note = '',
    String? churchId,
    DateTime? givenAt,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/giving'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'amount': amount,
        'currency': currency,
        'currencySymbol': currencySymbol,
        'category': category,
        'note': note,
        if (churchId != null) 'church': churchId,
        if (givenAt != null) 'givenAt': givenAt.toIso8601String(),
      }),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Failed to record giving';
    }
    return body;
  }

  /// GET /api/giving
  static Future<List<dynamic>> getGivingHistory() async {
    final r = await http.get(Uri.parse('$_base/giving'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load giving history';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// GET /api/giving/stats
  static Future<List<dynamic>> getGivingStats() async {
    final r = await http.get(Uri.parse('$_base/giving/stats'), headers: _headers);
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to load giving stats';
    }
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// DELETE /api/giving/:id
  static Future<void> deleteGiving(String id) async {
    final r = await http.delete(
      Uri.parse('$_base/giving/$id'),
      headers: _headers,
    );
    if (r.statusCode != 200) {
      throw _decode(r)['message'] ?? 'Failed to delete giving record';
    }
  }

  // ─── session ───────────────────────────────────────────────────────────────

  /// Persist a "remember me" session so the user is auto-logged-in on restart.
  static Future<void> saveSession({
    required String token,
    required String userId,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('auth_user_id', userId);
    await prefs.setString('auth_name', name);
  }

  /// Returns the saved session map, or null if none / not remembered.
  static Future<Map<String, String>?> loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token  = prefs.getString('auth_token');
    final userId = prefs.getString('auth_user_id');
    if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
      return null;
    }
    return {
      'token':  token,
      'userId': userId,
      'name':   prefs.getString('auth_name') ?? '',
    };
  }

  /// Erase the persisted "remember me" session (call on logout).
  static Future<void> clearSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_name');
  }

  /// Clear the in-memory session tokens (call on logout alongside [clearSavedSession]).
  static void clearSession() {
    authTokenNotifier.value  = null;
    authUserIdNotifier.value = null;
  }

  // ─── church management (pastor) ───────────────────────────────────────────

  /// POST /api/church/:id/request-join
  static Future<void> requestJoinChurch(String churchId) async {
    final r = await http.post(Uri.parse('$_base/church/$churchId/request-join'), headers: _headers);
    final body = _decode(r);
    if (r.statusCode != 200) throw body['message'] ?? 'Failed to submit request';
  }

  /// GET /api/church/:id/requests
  static Future<List<dynamic>> getJoinRequests(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church/$churchId/requests'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load requests';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// PATCH /api/church/:id/requests/:reqId/approve
  static Future<void> approveJoinRequest(String churchId, String reqId) async {
    final r = await http.patch(Uri.parse('$_base/church/$churchId/requests/$reqId/approve'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to approve';
  }

  /// PATCH /api/church/:id/requests/:reqId/reject
  static Future<void> rejectJoinRequest(String churchId, String reqId) async {
    final r = await http.patch(Uri.parse('$_base/church/$churchId/requests/$reqId/reject'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to reject';
  }

  /// GET /api/church/:id/members — members with roles
  static Future<List<dynamic>> getChurchMembers(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church/$churchId/members'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load members';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// GET /api/church/:id/online-status
  static Future<Map<String, dynamic>> getMemberOnlineStatus(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church/$churchId/online-status'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load status';
    return _decode(r);
  }

  /// PATCH /api/church/:id/members/:userId/role
  static Future<void> setMemberRole(String churchId, String userId, String role) async {
    final r = await http.patch(
      Uri.parse('$_base/church/$churchId/members/$userId/role'),
      headers: _headers,
      body: jsonEncode({'role': role}),
    );
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to update role';
  }

  /// DELETE /api/church/:id/members/:userId
  static Future<void> removeMember(String churchId, String userId) async {
    final r = await http.delete(Uri.parse('$_base/church/$churchId/members/$userId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to remove member';
  }

  /// GET /api/church/:id/events
  static Future<List<dynamic>> getChurchEvents(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church/$churchId/events'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load events';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// POST /api/church/:id/events
  static Future<Map<String, dynamic>> createChurchEvent(
      String churchId, String title, String date,
      {String description = '', String location = ''}) async {
    final r = await http.post(
      Uri.parse('$_base/church/$churchId/events'),
      headers: _headers,
      body: jsonEncode({'title': title, 'date': date, 'description': description, 'location': location}),
    );
    final body = _decode(r);
    if (r.statusCode != 201) throw body['message'] ?? 'Failed to create event';
    return body;
  }

  /// DELETE /api/church/:id/events/:eventId
  static Future<void> deleteChurchEvent(String churchId, String eventId) async {
    final r = await http.delete(Uri.parse('$_base/church/$churchId/events/$eventId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to delete event';
  }

  /// POST /api/church/:id/announce
  static Future<void> sendAnnouncement(String churchId, String title, String message) async {
    final r = await http.post(
      Uri.parse('$_base/church/$churchId/announce'),
      headers: _headers,
      body: jsonEncode({'title': title, 'message': message}),
    );
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to send announcement';
  }

  // ─── church posts ──────────────────────────────────────────────────────────

  /// POST /api/church-posts
  static Future<Map<String, dynamic>> submitChurchPost(String churchId, String content) async {
    final r = await http.post(
      Uri.parse('$_base/church-posts'),
      headers: _headers,
      body: jsonEncode({'churchId': churchId, 'content': content}),
    );
    final body = _decode(r);
    if (r.statusCode != 201) throw body['message'] ?? 'Failed to submit post';
    return body;
  }

  /// GET /api/church-posts/:churchId
  static Future<List<dynamic>> getChurchPosts(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church-posts/$churchId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load posts';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// PATCH /api/church-posts/:postId/approve
  static Future<void> approveChurchPost(String postId) async {
    final r = await http.patch(Uri.parse('$_base/church-posts/$postId/approve'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to approve post';
  }

  /// PATCH /api/church-posts/:postId/reject (hard delete)
  static Future<void> rejectChurchPost(String postId) async {
    final r = await http.patch(Uri.parse('$_base/church-posts/$postId/reject'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to reject post';
  }

  /// DELETE /api/church-posts/:postId
  static Future<void> deleteChurchPost(String postId) async {
    final r = await http.delete(Uri.parse('$_base/church-posts/$postId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to delete post';
  }

  // ─── church live ───────────────────────────────────────────────────────────

  /// POST /api/church/:id/go-live
  static Future<void> goLive(String churchId, String streamUrl, String liveTitle) async {
    final r = await http.post(
      Uri.parse('$_base/church/$churchId/go-live'),
      headers: _headers,
      body: jsonEncode({'streamUrl': streamUrl, 'liveTitle': liveTitle}),
    );
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to go live';
  }

  /// DELETE /api/church/:id/go-live
  static Future<void> endLive(String churchId) async {
    final r = await http.delete(Uri.parse('$_base/church/$churchId/go-live'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to end live';
  }

  /// GET /api/church/:id/live-status
  static Future<Map<String, dynamic>> getLiveStatus(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church/$churchId/live-status'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to get live status';
    return _decode(r);
  }

  // ─── church lyrics ──────────────────────────────────────────────────────────

  static Future<List<dynamic>> getChurchLyrics(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church-lyrics/$churchId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load lyrics';
    return jsonDecode(r.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> submitChurchLyrics(
      String churchId, {required String title, String artist = '', required String textContent}) async {
    final r = await http.post(Uri.parse('$_base/church-lyrics/$churchId'),
        headers: _headers,
        body: jsonEncode({'title': title, 'artist': artist, 'textContent': textContent}));
    if (r.statusCode != 201) throw _decode(r)['message'] ?? 'Failed to submit lyrics';
    return _decode(r);
  }

  static Future<Map<String, dynamic>> approveChurchLyrics(String churchId, String lyricsId) async {
    final r = await http.patch(
        Uri.parse('$_base/church-lyrics/$churchId/$lyricsId/approve'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to approve';
    return _decode(r);
  }

  static Future<void> rejectChurchLyrics(String churchId, String lyricsId) async {
    final r = await http.patch(
        Uri.parse('$_base/church-lyrics/$churchId/$lyricsId/reject'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to reject';
  }

  static Future<void> deleteChurchLyrics(String churchId, String lyricsId) async {
    final r = await http.delete(
        Uri.parse('$_base/church-lyrics/$churchId/$lyricsId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to delete';
  }

  // ─── church-wide Bible plan ────────────────────────────────────────────────

  /// GET /api/church-plan/:churchId — active plan + caller's completedDays
  static Future<Map<String, dynamic>> getChurchPlan(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church-plan/$churchId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load plan';
    return _decode(r);
  }

  /// POST /api/church-plan/:churchId — pastor creates/replaces the plan
  static Future<Map<String, dynamic>> setChurchPlan(
      String churchId, Map<String, dynamic> payload) async {
    final r = await http.post(Uri.parse('$_base/church-plan/$churchId'),
        headers: _headers, body: jsonEncode(payload));
    if (r.statusCode != 201) throw _decode(r)['message'] ?? 'Failed to set plan';
    return _decode(r);
  }

  /// PATCH /api/church-plan/:churchId/toggle-day — toggle a day's completion
  static Future<List<int>> toggleChurchPlanDay(String churchId, int dayNumber) async {
    final r = await http.patch(Uri.parse('$_base/church-plan/$churchId/toggle-day'),
        headers: _headers, body: jsonEncode({'dayNumber': dayNumber}));
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to toggle day';
    final days = (_decode(r)['completedDays'] as List<dynamic>)
        .map((e) => (e as num).toInt())
        .toList();
    return days;
  }

  /// GET /api/church-plan/:churchId/stats — pastor aggregate stats
  static Future<Map<String, dynamic>> getChurchPlanStats(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church-plan/$churchId/stats'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load stats';
    return _decode(r);
  }

  /// DELETE /api/church-plan/:churchId — pastor removes the active plan
  static Future<void> deleteChurchPlan(String churchId) async {
    final r = await http.delete(Uri.parse('$_base/church-plan/$churchId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to delete plan';
  }

  // ─── church media (worship hub) ────────────────────────────────────────────

  /// GET /api/church-media/:churchId
  static Future<List<dynamic>> getChurchMedia(String churchId) async {
    final r = await http.get(Uri.parse('$_base/church-media/$churchId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load media';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// POST /api/church-media/:churchId — multipart file upload
  /// [fileTypeOverride] is the explicit type chosen by the user: pdf | image | ppt
  static Future<Map<String, dynamic>> uploadChurchMedia(
      String churchId, String filePath, String title, String mimeType,
      {String? fileTypeOverride}) async {
    final uri = Uri.parse('$_base/church-media/$churchId');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        if (authTokenNotifier.value != null)
          'Authorization': 'Bearer ${authTokenNotifier.value}',
      })
      ..fields['title'] = title;
    if (fileTypeOverride != null) request.fields['fileType'] = fileTypeOverride;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    if (streamed.statusCode != 201) throw decoded['message'] ?? 'Upload failed';
    return decoded;
  }

  /// PATCH /api/church-media/:churchId/:mediaId/lyrics — toggle isLyrics
  static Future<Map<String, dynamic>> toggleChurchMediaLyrics(
      String churchId, String mediaId) async {
    final r = await http.patch(
        Uri.parse('$_base/church-media/$churchId/$mediaId/lyrics'),
        headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to update';
    return _decode(r);
  }

  /// DELETE /api/church-media/:churchId/:mediaId
  static Future<void> deleteChurchMedia(String churchId, String mediaId) async {
    final r = await http.delete(
        Uri.parse('$_base/church-media/$churchId/$mediaId'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to delete file';
  }
}
