// ignore_for_file: deprecated_member_use

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeImapactCard extends StatelessWidget {
  const CustomeImapactCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.amount,
  });

  final String value;
  final String label;
  final String amount;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    final padding = (w * 0.04).clamp(14, 20).toDouble();
    final iconPadding = (w * 0.025).clamp(8, 12).toDouble();
    final iconSize = (w * 0.06).clamp(22, 30).toDouble();
    final amountSize = (w * 0.045).clamp(16, 22).toDouble();
    final unitSize = (w * 0.035).clamp(12, 16).toDouble();
    final labelSize = (w * 0.028).clamp(11, 13).toDouble();

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomeText(
                      text: amount,
                      fontSize: amountSize,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: CustomeText(
                        text: value,
                        fontSize: unitSize,
                        fontWeight: FontWeight.bold,
                        textColor: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                CustomeText(
                  text: label,
                  fontSize: labelSize,
                  textColor: AppColors.textGrey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
