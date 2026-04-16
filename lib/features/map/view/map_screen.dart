// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  LatLng? currentLocation;

  @override
void initState() {
  super.initState();

  currentLocation = LatLng(30.0444, 31.2357);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    getLocation();
  });
}

  Future<void> getLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      setState(() {
        currentLocation = LatLng(30.0444, 31.2357);
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 5),
    );

    if (!mounted) return;

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_mapController.camera != null) {
      _mapController.move(currentLocation!, 15);
    }

  } catch (e) {
    if (!mounted) return;

    setState(() {
      currentLocation = LatLng(30.0444, 31.2357);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentLocation!,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.ecocycle.app',
                    ),

                    ///  Marker موقعك
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentLocation!,
                          width: 60,
                          height: 60,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                ///  زر يرجعك لموقعك
                Positioned(
                  bottom: 120,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      _mapController.move(currentLocation!, 15);
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
    );
  }
}