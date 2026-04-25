import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeLevelCard extends StatelessWidget {
  const CustomeLevelCard({
    super.key,
    required this.points,
    required this.nextLevelPoints,
    required this.rankName,
    required this.nextRankName,
    required this.rankColor,
  });

  final double points;
  final double nextLevelPoints;
  final String rankName;
  final String nextRankName;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.levelCardStart, AppColors.levelCardEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.levelCardStart.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Category and Level Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomeText(
                  text: "home.excellent_category",
                  textColor: AppColors.white,
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomeText(
                text: "home.current_level",
                textColor: AppColors.white.withValues(alpha: 0.9),
                fontSize: w * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Main Rank Name
          CustomeText(
            text: rankName,
            textColor: AppColors.white,
            fontSize: w * 0.07,
            fontWeight: FontWeight.bold,
          ),

          const SizedBox(height: 12),

          /// Points Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomeText(
                    text: "${nextLevelPoints.toInt()}",
                    textColor: AppColors.white,
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 4),
                  CustomeText(
                    text: "home.points_unit",
                    textColor: AppColors.white,
                    fontSize: w * 0.035,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomeText(
                    text: "${points.toInt()}",
                    textColor: AppColors.white,
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 4),
                  CustomeText(
                    text: "home.points_unit",
                    textColor: AppColors.white,
                    fontSize: w * 0.035,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Progress Bar
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: (points / nextLevelPoints).clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Remaining Points Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomeText(
                text: "home.points_left_to".tr(args: [
                  (nextLevelPoints - points).toInt().toString(),
                  nextRankName.tr()
                ]),
                textColor: AppColors.white.withValues(alpha: 0.9),
                fontSize: w * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
