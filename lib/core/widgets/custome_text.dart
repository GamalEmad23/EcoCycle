import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // لو انت مستخدم tr()

class CustomeText extends StatelessWidget {
  const CustomeText({
    super.key,
    required this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines; // جديد
  final TextOverflow? overflow; // جديد

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(), // تأكدت من وجود comma هنا
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: textColor ?? AppColors.textPrimary,
        fontSize: fontSize ?? 18,
        fontWeight: fontWeight ?? FontWeight.w700,
      ),
    );
  }
}
