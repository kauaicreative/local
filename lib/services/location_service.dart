import 'dart:html' as html;

class LocationService {
  static Future<Map<String, double?>> getLocation() async {
    try {
      final position =
          await html.window.navigator.geolocation.getCurrentPosition();
      return {
        'lat': position.coords!.latitude as double?,
        'lng': position.coords!.longitude as double?,
      };
    } catch (error) {
      print('Error getting location: $error');
      return {
        'lat': null,
        'lng': null,
      };
    }
  }
}
