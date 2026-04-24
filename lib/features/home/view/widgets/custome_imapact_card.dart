// ignore_for_file: deprecated_member_use

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeImapactCard extends StatelessWidget {
  const CustomeImapactCard({super.key, required this.value, required this.label, required this.icon, required this.iconBg, required this.iconColor, required this.amount});
  
  final String value;
  final String label;
  final String amount;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomeText(
                      text: amount,
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: CustomeText(
                        text: value,
                        fontSize: w * 0.035,
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
                  fontSize: w * 0.028,
                  textColor: AppColors.textGrey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.02),
          Container(
            padding: EdgeInsets.all(w * 0.025),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: w * 0.06),
          ),
        ],
      ),
    );
  }
}