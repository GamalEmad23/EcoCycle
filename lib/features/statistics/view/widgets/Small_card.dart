import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool showUnit;

  const SmallCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.showUnit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      width: 173,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomeText(
              text: title,
              textColor: AppColors.textGrey,
              fontSize: 12,
            ),
            Row(
              children: [
                CustomeText(
                  text: value,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 6),
                if (showUnit)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: const CustomeText(
                      text: "statistics.kg",
                      fontSize: 12,
                      textColor: AppColors.textGrey,
                    ),
                  ),
              ],
            ),
            CustomeText(
              text: subtitle,
              fontSize: 12,
              textColor: AppColors.Textcolor,
            ),
          ],
        ),
      ),
    );
  }
}
