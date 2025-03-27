import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickup_app/services/api.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;
  List<LatLng> routeCoordinates = [];

  final LatLng warehouseLocation = LatLng(12.961115, 77.600000);
  final List<LatLng> pickupLocations = [
    LatLng(12.971598, 77.594566),
    LatLng(12.972819, 77.595212),
    LatLng(12.963842, 77.609043),
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print(" Location services are disabled.");
      return LatLng(0, 0); 
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return LatLng(0, 0);
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> _getUserLocation() async {
    LatLng location = await getCurrentLocation();
    setState(() {
      currentLocation = location;
    });
  }

  Future<void> _showRoute() async {
    if (currentLocation == null) return;

    List<LatLng> fullRoute = [currentLocation!];

    for (LatLng pickup in pickupLocations) {
      List<LatLng> routeToPickup = await getRoute(fullRoute.last, pickup);
      fullRoute.addAll(routeToPickup);
    }
    List<LatLng> routeToWarehouse = await getRoute(
      fullRoute.last,
      warehouseLocation,
    );
    fullRoute.addAll(routeToWarehouse);

    setState(() {
      routeCoordinates = fullRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route to Pickups")),
      body:
          currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : FlutterMap(
                options: MapOptions(
                  initialCenter: currentLocation!,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation!,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      Marker(
                        point: warehouseLocation,
                        child: Icon(Icons.home, color: Colors.red, size: 30),
                      ),
                      for (LatLng pickup in pickupLocations)
                        Marker(
                          point: pickup,
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                  if (routeCoordinates.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routeCoordinates,
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRoute,
        child: Icon(Icons.directions),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
