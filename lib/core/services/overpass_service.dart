import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OverpassService {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<Map<String, dynamic>>> fetchNearbyRecyclingCenters(
      double lat, double lon, {double radius = 5000}) async {
    final query = """
      [out:json];
      (
        node["amenity"="recycling"](around:$radius,$lat,$lon);
        way["amenity"="recycling"](around:$radius,$lat,$lon);
        relation["amenity"="recycling"](around:$radius,$lat,$lon);
      );
      out center;
    """;

    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        body: {'data': query},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List elements = data['elements'] ?? [];
        List<Map<String, dynamic>> centers = [];

        for (var element in elements) {
          final tags = element['tags'] ?? {};
          final elementLat = element['lat'] ?? element['center']?['lat'];
          final elementLon = element['lon'] ?? element['center']?['lon'];
          
          if (elementLat == null || elementLon == null) continue;

          final location = LatLng(elementLat, elementLon);
          final distanceInMeters = Geolocator.distanceBetween(
              lat, lon, elementLat, elementLon);

          // Build a mock-like structure for the UI to consume seamlessly
          centers.add({
            "id": element['id'].toString(),
            "name": tags['name'] ?? tags['operator'] ?? "مركز إعادة تدوير",
            "materials": tags['recycling_type'] ?? "مواد قابلة للتدوير",
            "hours": tags['opening_hours'] ?? "غير محدد",
            "distance": (distanceInMeters / 1000).toStringAsFixed(1),
            "imgUrl": "https://images.unsplash.com/photo-1532996122724-e3c354a0b15f?w=400&q=80",
            "location": location,
          });
        }
        
        // Sort by closest distance
        centers.sort((a, b) => double.parse(a['distance']).compareTo(double.parse(b['distance'])));

        return centers;
      } else {
        throw Exception('Failed to load centers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recycling centers: $e');
    }
  }
}
