import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/features/home/view/widgets/custom_quick_action.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_center_card.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_daily_tip.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_header.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_impact_summary.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_level_card.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_nearby_centers_header.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScree extends StatefulWidget {
  const HomeScree({super.key});

  @override
  State<HomeScree> createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScree> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserStats();
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
              nextLevelPoints =
                  context.read<ProfileCubit>().getNextLevelPoints(points);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    rankName: "home.$rankName".tr(),
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomeQuickAction(
                          label: "home.recycle_now".tr(),
                          icon: Icons.recycling_rounded,
                          bgColor: AppColors.lightGreen,
                          textColor: AppColors.white,
                          iconColor: AppColors.white,
                          h: h,
                          w: w,
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
                  CustomeNearbyCentersHeader(),
                  SizedBox(height: h * .016),

                  /// Centers List Nearest
                  CustomeCenterCard(
                    name: "مركز تدوير الخليج",
                    address: "شارع العليا، الرياض",
                    distance: "0.8",
                    imgUrl:
                        "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&q=80",
                    distanceLable: 'home.kg_unit',
                    h: h,
                    w: w,
                  ),
                  SizedBox(height: h * .015),
                  CustomeCenterCard(
                    name: "إيكو بوينت المروج",
                    address: "حي المروج، الرياض",
                    distance: "1.5 ",
                    imgUrl:
                        "https://images.unsplash.com/photo-1591193022650-13f9f8c6507a?w=400&q=80",
                    distanceLable: 'home.kg_unit',
                    h: h,
                    w: w,
                  ),
                  SizedBox(height: h * .032),

                  /// tip for user
                  CustomeDailyTip(
                    h: h,
                    w: w,
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
