import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingResult {
  final String displayName;
  final LatLng location;

  GeocodingResult({required this.displayName, required this.location});

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    return GeocodingResult(
      displayName: json['display_name'],
      location: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
    );
  }
}

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<GeocodingResult>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse('$_baseUrl?q=$query&format=json&addressdetails=1&limit=5');
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'com.ecocycle.app', // Required by Nominatim Terms of Use
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GeocodingResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching locations: $e');
    }
  }
}
