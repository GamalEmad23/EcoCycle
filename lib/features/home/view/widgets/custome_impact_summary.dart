import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_imapact_card.dart';
import 'package:flutter/material.dart';

class CustomeImpactSummary extends StatelessWidget {
  const CustomeImpactSummary({super.key, required this.h, required this.w});

final double h;
final double w;
  @override
  Widget build(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Align(
          alignment:context.locale.countryCode=="en" ?AlignmentGeometry.topLeft : AlignmentGeometry.centerRight ,
          child: CustomeText(text: "home.impact_summary" , fontSize: 20, fontWeight: FontWeight.bold,textColor: AppColors.textPrimary,)),
        SizedBox(height: h*.018),
        Row(
          children: [
            Expanded(
              child: CustomeImapactCard(
                value: "home.kg_unit",
                label: "home.co2_saved",
                icon: Icons.cloud_queue_rounded,
                iconBg: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF2196F3), amount: '4.5',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomeImapactCard(
                value:"home.kg_unit",
                label: "home.total_recycled",
                icon: Icons.hourglass_top_rounded,
                iconBg: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF4CAF50), amount: '12',
              ),
            ),
          ],
        ),
      ],
    );
  }
}