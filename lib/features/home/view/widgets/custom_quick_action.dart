import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeQuickAction extends StatelessWidget {
  const CustomeQuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.iconColor,
    required this.h,
    required this.w,
  });

  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final double h;
  final double w;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: h * .03, horizontal: w * .02),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (bgColor == Colors.white)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: w * 0.09),
          const SizedBox(height: 10),
          CustomeText(
            text: label,
            textColor: textColor,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.04,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}