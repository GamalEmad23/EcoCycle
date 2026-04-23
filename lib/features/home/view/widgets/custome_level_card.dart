import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeLevelCard extends StatelessWidget {
  const CustomeLevelCard({
    super.key,
    required this.points,
    required this.nextLevelPoints,
    required this.rankName,
    required this.rankColor,
  });

  final double points;
  final double nextLevelPoints;
  final String rankName;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [rankColor.withValues(alpha: 0.8), rankColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: rankColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomeText(
                    text: rankName,
                    textColor: AppColors.white,
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomeText(
                text: "home.current_level",
                textColor: AppColors.white,
                fontSize: w * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: CustomeText(
              text: "home.golden_member",
              textColor: AppColors.white,
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CustomeText(
                      text: " ${points.toInt()} ",
                      textColor: AppColors.white,
                      fontSize: w * 0.032,
                      fontWeight: FontWeight.w500,
                    ),
                    Flexible(
                      child: CustomeText(
                        text: "home.points_unit",
                        textColor: AppColors.white,
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomeText(
                      text: " ${nextLevelPoints.toInt()} ",
                      textColor: AppColors.white,
                      fontSize: w * 0.032,
                      fontWeight: FontWeight.w500,
                    ),
                    Flexible(
                      child: CustomeText(
                        text: "home.points_unit",
                        textColor: AppColors.white,
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              FractionallySizedBox(
                alignment: Alignment.centerRight,
                widthFactor: (points / nextLevelPoints).clamp(0.0, 1.0),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomeText(
                text: " ${(nextLevelPoints - points).toInt()} ",
                textColor: AppColors.white,
                fontSize: w * 0.03,
                fontWeight: FontWeight.bold,
              ),
              Flexible(
                child: CustomeText(
                  text: "home.points_left",
                  textColor: AppColors.white,
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
