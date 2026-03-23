import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomeText extends StatelessWidget {
  const CustomeText({super.key, required this.text, this.textColor, this.fontSize, this.fontWeight});
   
   final String text;
   final Color? textColor;
   final double? fontSize;
   final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text.tr() , 
    style: TextStyle(
      color: textColor?? AppColors.textPrimary,
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w700,
    ),
    );
  }
}