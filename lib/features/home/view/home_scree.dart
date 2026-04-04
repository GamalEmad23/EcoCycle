import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/features/home/view/widgets/custom_quick_action.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_center_card.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_daily_tip.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_header.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_impact_summary.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_level_card.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_nearby_centers_header.dart';
import 'package:flutter/material.dart';

class HomeScree extends StatefulWidget {
  const HomeScree({super.key});

  @override
  State<HomeScree> createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScree> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              /// User Header
              CustomeHeader(
                h: h,
                w: w,
                imagePath: "https://randomuser.me/api/portraits/men/32.jpg",
              ),
              SizedBox(height: h*.03),
              
              /// User Level Data
              CustomeLevelCard(),
              SizedBox(height: h * .025),
              
              /// Find center and Recycle 
              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  CustomeQuickAction(
                    label: "home.find_center".tr(),
                    icon: Icons.location_on_rounded,
                    bgColor: AppColors.lightWight,
                    textColor: AppColors.textPrimary,
                    iconColor: AppColors.textPrimary,
                    h: h,
                    w: w,
                  ),

                  CustomeQuickAction(
                    label: "home.recycle_now".tr(),
                    icon: Icons.recycling_rounded,
                    bgColor: AppColors.lightGreen,
                    textColor: AppColors.white,
                    iconColor: AppColors.white,
                    h: h,
                    w: w,
                  ),
                ],
              ),
              SizedBox(height: h * .038),

              /// User Usage Summary
              CustomeImpactSummary(h: h, w: w),
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
                    "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&q=80", distanceLable: 'home.kg_unit', h: h, w: w,
              ),
              SizedBox(height: h * .015),
              CustomeCenterCard(
                name: "إيكو بوينت المروج",
                address: "حي المروج، الرياض",
                distance: "1.5 ",
                imgUrl:
                    "https://images.unsplash.com/photo-1591193022650-13f9f8c6507a?w=400&q=80", distanceLable: 'home.kg_unit', h: h, w:w ,
              ),
              SizedBox(height: h * .032),
              
              /// tip for user
              CustomeDailyTip(h: h, w: w,),
              SizedBox(height: h * .1),
            ],
          ),
        ),
      ),
    );
  }



}
