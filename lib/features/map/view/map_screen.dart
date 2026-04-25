// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/services/geocoding_service.dart';
import 'package:eco_cycle/features/map/view/widgets/location_permission_view.dart';
import 'package:eco_cycle/features/map/view/widgets/center_details_bottom_sheet.dart';
import 'package:eco_cycle/core/services/overpass_service.dart';
import 'package:eco_cycle/core/services/favorites_service.dart';
import 'package:eco_cycle/core/data/centers_data.dart' as static_data;

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
  Timer? _emptyStateTimer;
  bool _showEmptyStateMessage = false;
  bool _isTrackingLocation = true;
  bool _isInitialLoad = true;

  String _selectedFilter = 'map.filter_all';
  final List<String> _filters = [
    'map.filter_all',
    'map.filter_plastic',
    'map.filter_paper',
    'map.filter_glass',
    'map.filter_metal',
  ];

  List<String> _favoriteIds = [];
  final FavoritesService _favoritesService = FavoritesService();
  StreamSubscription<List<String>>? _favoritesSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
    _favoritesSubscription = _favoritesService.getFavoritesStream().listen((
      favs,
    ) {
      if (mounted) setState(() => _favoriteIds = favs);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _emptyStateTimer?.cancel();
    _positionStreamSubscription?.cancel();
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCenters {
    if (_selectedFilter == 'map.filter_all') return _centers;
    return _centers.where((center) {
      final materials = (center['materials'] as String?)?.toLowerCase() ?? '';
      String searchKeyword = '';
      if (_selectedFilter == 'map.filter_plastic') searchKeyword = 'plastic';
      if (_selectedFilter == 'map.filter_paper') searchKeyword = 'paper';
      if (_selectedFilter == 'map.filter_glass') searchKeyword = 'glass';
      if (_selectedFilter == 'map.filter_metal') searchKeyword = 'metal';

      return materials.contains(searchKeyword);
    }).toList();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('map.search_failed'.tr(args: [e.toString()])),
            ),
          );
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
      _isTrackingLocation = false;
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

      _positionStreamSubscription ??=
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              distanceFilter: 500,
            ),
          ).listen((Position newPosition) {
            if (mounted && _isTrackingLocation) {
              setState(() {
                currentLocation = LatLng(
                  newPosition.latitude,
                  newPosition.longitude,
                );
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

  List<Map<String, dynamic>> _getStaticCenters(LatLng? currentLoc) {
    return static_data.centers.map((c) {
      final lat = c['lat'] as double;
      final lng = c['lng'] as double;
      final location = LatLng(lat, lng);

      double distanceInMeters = 0.0;
      if (currentLoc != null) {
        distanceInMeters = Geolocator.distanceBetween(
          currentLoc.latitude,
          currentLoc.longitude,
          lat,
          lng,
        );
      }

      return {
        "id": "static_${c['name']}",
        "name": c['name'],
        "materials": "بلاستيك، ورق، معدن، زجاج",
        "hours": "08:00 ص - 09:00 م",
        "distance": (distanceInMeters / 1000).toStringAsFixed(1),
        "imgUrl":
            "https://images.unsplash.com/photo-1532996122724-e3c354a0b15f?w=400&q=80",
        "location": location,
        "city": c['city'],
      };
    }).toList();
  }

  void _fitBoundsToCenters() {
    if (_filteredCenters.isEmpty) return;

    final points = _filteredCenters
        .map((c) => c['location'] as LatLng)
        .toList();
    if (currentLocation != null) {
      points.add(currentLocation!);
    }

    if (points.length > 1) {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
      );
    } else if (points.isNotEmpty) {
      _mapController.move(points.first, 14);
    }
  }

  Future<void> _fetchCentersAround(LatLng location) async {
    if (!mounted) return;
    setState(() {
      _isLoadingCenters = true;
      _showEmptyStateMessage = false;
    });

    try {
      final overpassCenters = await _overpassService
          .fetchNearbyRecyclingCenters(location.latitude, location.longitude);

      final staticCenters = _getStaticCenters(currentLocation);
      final List<Map<String, dynamic>> allCenters = [...staticCenters];
      for (var oc in overpassCenters) {
        if (!allCenters.any((sc) => sc['name'] == oc['name'])) {
          allCenters.add(oc);
        }
      }
      allCenters.sort(
        (a, b) =>
            double.parse(a['distance']).compareTo(double.parse(b['distance'])),
      );

      if (mounted) {
        setState(() {
          _centers = allCenters;
          _isLoadingCenters = false;
        });
        if (_isInitialLoad) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _fitBoundsToCenters();
              setState(() {
                _isInitialLoad = false;
              });
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCenters = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('map.fetch_centers_failed'.tr(args: [e.toString()])),
          ),
        );
      }
    }
  }

  void _onCenterTapped(Map<String, dynamic> center) {
    setState(() {
      _selectedCenter = center;
    });
    _mapController.move(center['location'] as LatLng, 15);
  }

  Future<void> _launchNavigation(LatLng? destination, String mode) async {
    if (destination == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('map.destination_coords_unavailable'.tr())),
        );
      }
      return;
    }

    String urlString =
        'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}&travelmode=$mode';
    if (currentLocation != null) {
      urlString +=
          '&origin=${currentLocation!.latitude},${currentLocation!.longitude}';
    }

    debugPrint('Final Navigation URL: $urlString');
    final url = Uri.parse(urlString);

    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        launched = await launchUrl(url, mode: LaunchMode.platformDefault);
        if (!launched) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('map.cannot_open_maps'.tr())),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error launching map URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('map.error_opening_maps'.tr())));
      }
    }
  }

  void _showNavigationOptions(LatLng? destination) {
    if (destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('map.center_coords_unavailable'.tr())),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        final bsW = MediaQuery.sizeOf(sheetCtx).width;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: bsW * 0.06,
              vertical: bsW * 0.05,
            ),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: bsW * 0.10,
                  height: 4,
                  margin: EdgeInsets.only(bottom: bsW * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'map.choose_transport_mode'.tr(),
                  style: TextStyle(
                    fontSize: bsW * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: bsW * 0.05),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(bsW * 0.025),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGreen2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    'map.driving'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: bsW * 0.04,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _launchNavigation(destination, 'driving');
                  },
                ),
                SizedBox(height: bsW * 0.025),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(bsW * 0.025),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGreen2,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_walk,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    'map.walking'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: bsW * 0.04,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _launchNavigation(destination, 'walking');
                  },
                ),
                SizedBox(height: bsW * 0.05),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double h = size.height;
    final double w = size.width;
    final double topPad = MediaQuery.of(context).padding.top;

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

                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        maxClusterRadius: 45,
                        size: const Size(40, 40),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(50),
                        maxZoom: 15,
                        markers: _filteredCenters.map((center) {
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
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      child: _buildPin(isSelected),
                                    ),
                            ),
                          );
                        }).toList(),
                        builder: (context, markers) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.primary,
                            ),
                            child: Center(
                              child: Text(
                                markers.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    MarkerLayer(
                      markers: [
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
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 4,
                                  ),
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

                Positioned(
                  left: w * 0.05,
                  top: h * 0.38,
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
                          setState(() {
                            _isTrackingLocation = true;
                            _searchController.clear();
                          });
                          _fetchCurrentLocation();
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: topPad + 12,
                  left: w * 0.05,
                  right: w * 0.05,
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
                                child: Text(
                                  'map.centers_map'.tr(),
                                  style: TextStyle(
                                    fontSize: w * 0.045,
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
                            height: h * 0.065,
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
                                    decoration: InputDecoration(
                                      hintText: 'map.enter_your_location'.tr(),
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

                        if (_isSearchExpanded && _searchResults.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: BoxConstraints(maxHeight: h * 0.35),
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
                if (_selectedCenter != null)
                  Positioned(
                    bottom: h * 0.13,
                    left: w * 0.05,
                    right: w * 0.05,
                    child: CenterDetailsBottomSheet(
                      centerData: _selectedCenter!,
                      isFavorite: _favoriteIds.contains(_selectedCenter!['id']),
                      onFavoriteToggle: () {
                        final isFav = _favoriteIds.contains(
                          _selectedCenter!['id'],
                        );
                        _favoritesService.toggleFavorite(
                          _selectedCenter!['id'],
                          isFav,
                        );
                      },
                      onGetDirections: () {
                        _showNavigationOptions(
                          _selectedCenter!['location'] as LatLng,
                        );
                      },
                    ),
                  ),
                if (_isLoadingCenters)
                  Positioned(
                    top: h * 0.16,
                    left: w * 0.05,
                    right: w * 0.05,
                    child: FadeInDown(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.95),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2.5,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'map.searching_nearby_centers'.tr(),
                              style: const TextStyle(
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
                else if (_showEmptyStateMessage && currentLocation != null)
                  Positioned(
                    top: h * 0.16,
                    left: w * 0.05,
                    right: w * 0.05,
                    child: FadeInDown(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.95),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'map.no_centers_in_range'.tr(),
                              style: const TextStyle(
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
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : Colors.black26,
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
