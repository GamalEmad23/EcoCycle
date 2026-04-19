import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String weight;
  final String points;
  final String imagePath;
  final Color iconBg;
  final Color iconColor;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.weight,
    required this.points,
    required this.imagePath,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(width: 12),

          /// النص
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomeText(
                  text: title,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                const SizedBox(height: 4),
                CustomeText(
                  text: subtitle,
                  textColor: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomeText(
                    text: weight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    textColor: AppColors.black,
                  ),

                  const SizedBox(width: 4),

                  const CustomeText(
                    text: "statistics.kg",

                    fontSize: 16,
                    textColor: AppColors.black,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CustomeText(
                text: points,
                fontSize: 10,
                textColor: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
