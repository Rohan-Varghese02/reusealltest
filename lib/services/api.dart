import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
  const String apiKey =
      "key";
  final String url =
      "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}";

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null || data["routes"] == null || data["routes"].isEmpty) {
        log(" No routes found in response.");
        return [];
      }
      final List<LatLng> routePoints = [];
      for (var point in data["routes"][0]["geometry"]["coordinates"]) {
        routePoints.add(LatLng(point[1], point[0]));
      }
      return routePoints;
    } else {
      log(" Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (e) {
    log("Exception in getRoute(): $e");
    return [];
  }
}
