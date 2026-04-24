import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/home/view/widgets/custome_imapact_card.dart';
import 'package:flutter/material.dart';

class CustomeImpactSummary extends StatelessWidget {
  const CustomeImpactSummary({
    super.key,
    required this.h,
    required this.w,
    required this.totalWeight,
    required this.co2Saved,
    required this.waterSaved,
    required this.energySaved,
  });

  final double h;
  final double w;
  final double totalWeight;
  final double co2Saved;
  final double waterSaved;
  final double energySaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: context.locale.countryCode == "en"
              ? AlignmentGeometry.topLeft
              : AlignmentGeometry.centerRight,
          child: CustomeText(
            text: "home.impact_summary",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            textColor: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: h * .018),
        Row(
          children: [
            Expanded(
              child: CustomeImapactCard(
                value: "home.kg_unit",
                label: "home.co2_saved",
                icon: Icons.cloud_queue_rounded,
                iconBg: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF2196F3),
                amount: co2Saved.toStringAsFixed(1),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomeImapactCard(
                value: "home.kg_unit",
                label: "home.total_recycled",
                icon: Icons.recycling_rounded,
                iconBg: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF4CAF50),
                amount: totalWeight.toStringAsFixed(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomeImapactCard(
                value: "home.liter_unit",
                label: "home.water_saved",
                icon: Icons.water_drop_rounded,
                iconBg: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF00ACC1),
                amount: waterSaved.toStringAsFixed(0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomeImapactCard(
                value: "home.kwh_unit",
                label: "home.energy_saved",
                icon: Icons.bolt_rounded,
                iconBg: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFFB8C00),
                amount: energySaved.toStringAsFixed(1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}