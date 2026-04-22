import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/services/geocoding_service.dart';
import 'package:eco_cycle/features/map/view/widgets/location_permission_view.dart';
import 'package:eco_cycle/features/map/view/widgets/center_details_bottom_sheet.dart';
import 'package:eco_cycle/core/services/overpass_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  bool _isSearching = false;
  List<GeocodingResult> _searchResults = [];
  final GeocodingService _geocodingService = GeocodingService();

  LatLng? currentLocation;
  bool? hasPermission;
  List<Map<String, dynamic>> _centers = [];
  bool _isLoadingCenters = false;
  final OverpassService _overpassService = OverpassService();
  bool _isSearchExpanded = false;
  Map<String, dynamic>? _selectedCenter;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.trim().isEmpty) {
      if (mounted)
        setState(() {
          _searchResults.clear();
          _isSearching = false;
        });
      return;
    }

    if (mounted) setState(() => _isSearching = true);

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _geocodingService.searchLocations(query);
        if (mounted) {
          setState(() {
            _searchResults = results;
            _isSearching = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فشل في البحث عن الموقع: $e')));
        }
      }
    });
  }

  void _onResultSelected(GeocodingResult result) {
    _searchFocusNode.unfocus();
    _searchController.text = result.displayName.split(',').first;
    setState(() {
      _searchResults.clear();
      currentLocation = result.location;
    });

    _fetchCentersAround(result.location);
    _mapController.move(result.location, 14);
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
      _fetchCentersAround(LatLng(position.latitude, position.longitude));

      _mapController.move(currentLocation!, 15);

      _positionStreamSubscription ??= Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, // Optimized for battery
          distanceFilter: 500, // Update if moved by 500 meters
        ),
      ).listen((Position newPosition) {
        if (mounted) {
          setState(() {
            currentLocation = LatLng(newPosition.latitude, newPosition.longitude);
          });
          _fetchCentersAround(currentLocation!);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        currentLocation = const LatLng(30.0444, 31.2357);
      });
    }
  }

  Future<void> _fetchCentersAround(LatLng location) async {
    if (!mounted) return;
    setState(() {
      _isLoadingCenters = true;
    });

    try {
      final centers = await _overpassService.fetchNearbyRecyclingCenters(
        location.latitude,
        location.longitude,
      );
      if (mounted) {
        setState(() {
          _centers = centers;
          _isLoadingCenters = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCenters = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل في جلب المراكز: $e')));
      }
    }
  }

  void _onCenterTapped(Map<String, dynamic> center) {
    setState(() {
      _selectedCenter = center;
    });
    _mapController.move(center['location'] as LatLng, 15);
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
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: Lottie.asset('assets/lotties/map_search.json')),
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
          ? Center(child: Lottie.asset('assets/lotties/map_search.json'))
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentLocation!,
                    initialZoom: 14,
                    onTap: (tapPosition, point) {
                      if (_selectedCenter != null) {
                        setState(() => _selectedCenter = null);
                      }
                      if (_isSearchExpanded) {
                        setState(() => _isSearchExpanded = false);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.ecocycle.app',
                    ),

                    MarkerLayer(
                      markers: [
                        ..._centers.map((center) {
                          final isSelected = _selectedCenter == center;
                          return Marker(
                            point: center['location'] as LatLng,
                            width: 60,
                            height: 70,
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () => _onCenterTapped(center),
                              child: isSelected 
                                  ? Pulse(
                                      infinite: true,
                                      child: _buildPin(isSelected),
                                    )
                                  : FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      child: _buildPin(isSelected),
                                    ),
                            ),
                          );
                        }).toList(),
                        Marker(
                          point: currentLocation!,
                          width: 80,
                          height: 80,
                          child: Pulse(
                            infinite: true,
                            child: Center(
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: 0.5),
                                      blurRadius: 12,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Zoom & Location Controls (Left Side)
                Positioned(
                  left: 20,
                  top: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Container(
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
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () => _mapController.move(
                                _mapController.camera.center,
                                _mapController.camera.zoom + 1,
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 1,
                              color: AppColors.border,
                            ),
                            IconButton(
                              onPressed: () => _mapController.move(
                                _mapController.camera.center,
                                _mapController.camera.zoom - 1,
                              ),
                              icon: const Icon(
                                Icons.remove,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 4,
                        onPressed: () {
                          if (currentLocation != null) {
                            _mapController.move(currentLocation!, 15);
                          }
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),

                // Top Header / Search
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isSearchExpanded)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.tune,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "خريطة المراكز",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: AppColors.textPrimary,
                                  ),
                                  onPressed: () {
                                    setState(() => _isSearchExpanded = true);
                                    _searchFocusNode.requestFocus();
                                  },
                                ),
                              ),
                            ],
                          )
                        else
                          Container(
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
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isSearchExpanded = false;
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _searchFocusNode,
                                    onChanged: _onSearchChanged,
                                    decoration: const InputDecoration(
                                      hintText: "أدخل موقعك...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                if (_isSearching)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                else if (_searchController.text.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                  ),
                              ],
                            ),
                          ),
                        if (_isSearchExpanded &&
                            !_isSearching &&
                            _searchController.text.isNotEmpty &&
                            _searchResults.isEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.location_off,
                                  color: AppColors.textLight,
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "لم يتم العثور على مواقع مطابقة",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_isSearchExpanded && _searchResults.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: const BoxConstraints(maxHeight: 280),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                  ),
                                  title: Text(
                                    result.displayName.split(',').first,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => _onResultSelected(result),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Selected Center Floating Card
                if (_selectedCenter != null)
                  Positioned(
                    bottom: 110,
                    left: 20,
                    right: 20,
                    child: CenterDetailsBottomSheet(
                      centerData: _selectedCenter!,
                      onGetDirections: () {
                        _launchGoogleMaps(
                          _selectedCenter!['location'] as LatLng,
                        );
                      },
                    ),
                  ),
                if (_isLoadingCenters)
                  Positioned(
                    top: 130,
                    left: 20,
                    right: 20,
                    child: FadeInDown(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "جاري البحث عن مراكز قريبة...",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (_centers.isEmpty && currentLocation != null)
                  Positioned(
                    top: 130,
                    left: 20,
                    right: 20,
                    child: FadeInDown(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            const Text(
                              "لا توجد مراكز إعادة تدوير في هذا النطاق",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildPin(bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.white,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.4) : Colors.black26,
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.recycling_rounded,
            color: isSelected ? AppColors.primary : AppColors.white,
            size: isSelected ? 24 : 20,
          ),
        ),
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
