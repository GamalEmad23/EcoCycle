import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/features/map/view/widgets/location_permission_view.dart';
import 'package:eco_cycle/features/map/view/widgets/center_details_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  LatLng? currentLocation;
  bool? hasPermission;
  final List<Map<String, dynamic>> _mockCenters = [
    {
      "id": "1",
      "name": "إيكوهوب داون تاون",
      "materials": "بلاستيك، ورق، معدن، زجاج",
      "hours": "08:00 ص - 09:00 م",
      "distance": "1.2",
      "imgUrl":
          "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&q=80",
      "location": const LatLng(30.0445, 31.2360),
    },
    {
      "id": "2",
      "name": "مركز تدوير الخليج",
      "materials": "بلاستيك، ورق، إلكترونيات",
      "hours": "09:00 ص - 05:00 م",
      "distance": "0.8",
      "imgUrl":
          "https://images.unsplash.com/photo-1591193022650-13f9f8c6507a?w=400&q=80",
      "location": const LatLng(30.0450, 31.2320),
    },
    {
      "id": "3",
      "name": "إيكو بوينت المروج",
      "materials": "ورق، معدن",
      "hours": "مفتوح 24 ساعة",
      "distance": "1.5",
      "imgUrl":
          "https://images.unsplash.com/photo-1532996122724-e3c354a0b15f?w=400&q=80",
      "location": const LatLng(30.0410, 31.2380),
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

  Future<void> _checkInitialPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => hasPermission = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      if (mounted) setState(() => hasPermission = true);
      _fetchCurrentLocation();
    } else {
      if (mounted) setState(() => hasPermission = false);
    }
  }

  Future<void> _requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      if (mounted) setState(() => hasPermission = true);
      _fetchCurrentLocation();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      if (!mounted) return;

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      _updateMockLocationsAroundUser(position.latitude, position.longitude);

      _mapController.move(currentLocation!, 15);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        currentLocation = const LatLng(30.0444, 31.2357);
      });
    }
  }

  void _updateMockLocationsAroundUser(double lat, double lng) {
    setState(() {
      _mockCenters[0]['location'] = LatLng(lat + 0.005, lng + 0.005);
      _mockCenters[1]['location'] = LatLng(lat - 0.004, lng + 0.002);
      _mockCenters[2]['location'] = LatLng(lat + 0.002, lng - 0.006);
    });
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CenterDetailsBottomSheet(
          centerData: center,
          onGetDirections: () {
            Navigator.pop(context);
            _launchGoogleMaps(center['location'] as LatLng);
          },
        );
      },
    );
  }

  Future<void> _launchGoogleMaps(LatLng destination) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${destination.latitude},${destination.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('لا يمكن فتح الخرائط.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasPermission == null) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (hasPermission == false) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: LocationPermissionView(
          onAllowPressed: _requestPermission,
          onNotNowPressed: () {
            setState(() {
              hasPermission = true;
              currentLocation = const LatLng(30.0444, 31.2357);
            });
          },
        ),
      );
    }
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentLocation!,
                    initialZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.ecocycle.app',
                    ),

                    MarkerLayer(
                      markers: [
                        ..._mockCenters.map((center) {
                          return Marker(
                            point: center['location'] as LatLng,
                            width: 50,
                            height: 50,
                            child: GestureDetector(
                              onTap: () => _showCenterDetails(center),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.recycling_rounded,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        Marker(
                          point: currentLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "خريطة المراكز",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.lightGreen3,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    onPressed: () {
                      if (currentLocation != null) {
                        _mapController.move(currentLocation!, 15);
                      }
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
    );
  }
}
