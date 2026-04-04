// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomeText(text: amount.tr() ,fontSize: 22,fontWeight: FontWeight.bold,textColor: AppColors.textPrimary,),
                CustomeText(text: value.tr() ,fontSize: 22,fontWeight: FontWeight.bold,textColor: AppColors.textPrimary,),
                CustomeText(text: label.tr() ,fontSize: 12,textColor: AppColors.textGrey,),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 26),
          ),
        ],
      ),
    );
  }
}