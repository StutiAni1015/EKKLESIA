import 'dart:math';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Request permission and return the current position.
  /// Returns null if permission is denied or location is unavailable.
  static Future<Position?> requestAndGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Haversine distance in miles between two lat/lng points.
  static double distanceMiles(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const r = 3958.8; // Earth radius in miles
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  static double _deg2rad(double deg) => deg * (pi / 180);

  /// Format a mile distance into a readable label, e.g. "1.2 mi" or "0.5 mi".
  static String formatDistance(double miles) {
    if (miles < 0.1) return '< 0.1 mi';
    return '${miles.toStringAsFixed(1)} mi';
  }
}
