import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custome_text.dart';

class StatBox extends StatelessWidget {
  final String title;
  final String value;

  const StatBox({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomeText(
            text: value,
            textColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
