import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/features/home/view/widgets/custom_quick_action.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_center_card.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_daily_tip.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_header.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_impact_summary.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_level_card.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_nearby_centers_header.dart';
import 'package:eco_cycle/features/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:eco_cycle/core/data/centers_data.dart' as static_data;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  List<Map<String, dynamic>> _nearbyCenters = [];

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserStats();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = position;
        _calculateNearbyCenters();
      });
    }
  }

  void _calculateNearbyCenters() {
    if (_currentPosition == null) return;

    List<Map<String, dynamic>> sortedCenters = List.from(static_data.centers);
    for (var center in sortedCenters) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        center['lat'],
        center['lng'],
      );
      center['distance_val'] = distanceInMeters / 1000;
    }

    sortedCenters.sort(
      (a, b) => a['distance_val'].compareTo(b['distance_val']),
    );
    setState(() {
      _nearbyCenters = sortedCenters.take(2).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            double points = 0;
            double totalWeight = 0;
            double co2Saved = 0;
            double waterSaved = 0;
            double energySaved = 0;
            double co2Percentage = 0;
            double nextLevelPoints = 2000;
            String rankName = "beginner";
            Color rankColor = Colors.green;
            String userName = "";
            String userImage = "";

            if (state is ProfileStatsSuccess) {
              points = state.points;
              totalWeight = state.totalWeight;
              co2Saved = state.co2Saved;
              waterSaved = state.waterSaved;
              energySaved = state.energySaved;
              co2Percentage = state.co2Percentage;
              userName = state.userName;
              userImage = state.userImage;
              rankName = context.read<ProfileCubit>().getRank(points);
              rankColor = context.read<ProfileCubit>().getRankColor(points);
              nextLevelPoints = context.read<ProfileCubit>().getNextLevelPoints(
                points,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// User Header
                  CustomeHeader(
                    h: h,
                    w: w,
                    imagePath: userImage,
                    userName: userName,
                  ),
                  SizedBox(height: h * .03),

                  /// User Level Data
                  CustomeLevelCard(
                    points: points,
                    nextLevelPoints: nextLevelPoints,
                    rankName: "home.$rankName",
                    nextRankName:
                        "home.${context.read<ProfileCubit>().getNextRank(points)}",
                    rankColor: rankColor,
                  ),
                  SizedBox(height: h * .025),

                  /// Find center and Recycle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomeQuickAction(
                          label: "home.find_center".tr(),
                          icon: Icons.location_on_rounded,
                          bgColor: AppColors.lightWight,
                          textColor: AppColors.textPrimary,
                          iconColor: AppColors.textPrimary,
                          h: h,
                          w: w,
                          onTap: () =>
                              context.read<NavBarCubit>().changeIndex(1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomeQuickAction(
                          label: "home.recycle_now".tr(),
                          icon: Icons.recycling_rounded,
                          bgColor: AppColors.levelCardEnd,
                          textColor: AppColors.white,
                          iconColor: AppColors.white,
                          h: h,
                          w: w,
                          onTap: () =>
                              context.read<NavBarCubit>().changeIndex(2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * .038),

                  /// User Usage Summary
                  CustomeImpactSummary(
                    h: h,
                    w: w,
                    totalWeight: totalWeight,
                    co2Saved: co2Saved,
                    waterSaved: waterSaved,
                    energySaved: energySaved,
                  ),
                  SizedBox(height: h * .032),

                  /// Near Centers
                  CustomeNearbyCentersHeader(
                    onViewAllTap: () =>
                        context.read<NavBarCubit>().changeIndex(1),
                  ),
                  SizedBox(height: h * .016),

                  /// Centers List Nearest
                  if (_nearbyCenters.isEmpty)
                    Center(
                      child: Lottie.asset(
                        "assets/lotties/Sandy Loading.json",
                        height: h * .18,
                      ),
                    )
                  else
                    ..._nearbyCenters.map(
                      (center) => Padding(
                        padding: EdgeInsets.only(bottom: h * .015),
                        child: CustomeCenterCard(
                          name: center['name'],
                          address: "${center['address']}, ${center['city']}",
                          distance:
                              center['distance_val']?.toStringAsFixed(1) ??
                              "...",
                          imgUrl:
                              "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&q=80",
                          distanceLable: 'map.km',
                          h: h,
                          w: w,
                        ),
                      ),
                    ),

                  SizedBox(height: h * .032),

                  /// tip for user
                  CustomeDailyTip(
                    h: h,
                    w: w,
                    tip: context.read<ProfileCubit>().getDailyTip(),
                  ),
                  SizedBox(height: h * .1),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
