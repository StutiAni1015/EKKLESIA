import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/user_session.dart';

/// Global token notifier — set after login/signup, cleared on logout.
final authTokenNotifier  = ValueNotifier<String?>( null);
final authUserIdNotifier = ValueNotifier<String?>( null);

class ApiService {
  // 127.0.0.1 for iOS simulator; use 10.0.2.2 for Android emulator.
  static const String _base = 'http://127.0.0.1:4000/api';

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
  /// Returns the created user map or throws on error.
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
  /// Stores token + userId in global notifiers on success.
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
    // Update display name from server response if available
    if (body['name'] != null) {
      userNameNotifier.value = (body['name'] as String).split(' ').first;
    }
  }

  // ─── prayers ───────────────────────────────────────────────────────────────

  /// GET /api/prayer
  static Future<List<dynamic>> getPrayers() async {
    final r = await http.get(Uri.parse('$_base/prayer'), headers: _headers);
    if (r.statusCode != 200) throw _decode(r)['message'] ?? 'Failed to load prayers';
    return jsonDecode(r.body) as List<dynamic>;
  }

  /// POST /api/prayer
  static Future<Map<String, dynamic>> createPrayer({
    required String title,
    required String content,
  }) async {
    final r = await http.post(
      Uri.parse('$_base/prayer'),
      headers: _headers,
      body: jsonEncode({'title': title, 'content': content}),
    );
    final body = _decode(r);
    if (r.statusCode != 200 && r.statusCode != 201) {
      throw body['message'] ?? 'Failed to create prayer';
    }
    return body;
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
    required String title,
    required String content,
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

  // ─── church ────────────────────────────────────────────────────────────────

  /// POST /api/church — create a new church
  static Future<Map<String, dynamic>> createChurch({
    required String name,
    required String denomination,
    required String address,
    required String city,
    required String country,
    String phone           = '',
    String email           = '',
    String website         = '',
    String youtube         = '',
    String instagram       = '',
    bool   allowTestimonies = true,
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

  // ─── session ───────────────────────────────────────────────────────────────

  static void clearSession() {
    authTokenNotifier.value  = null;
    authUserIdNotifier.value = null;
  }
}
