import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custome_text.dart';

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const StatBox({
    super.key,
    required this.title,
    required this.value,
     this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.isDarkMode
                ? Colors.black.withValues(alpha: 0.24)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppColors.lightGreen3,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.green, size: 19),
          ),
          const SizedBox(height: 6),
          CustomeText(
            text: value,
            textColor: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
