// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomeQuickAction extends StatelessWidget {
  const CustomeQuickAction({super.key, required this.label, required this.icon, required this.bgColor, required this.textColor, required this.iconColor, required this.h, required this.w});
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
      padding: EdgeInsets.symmetric(vertical: h*.04 , horizontal: w*.04),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (bgColor == Colors.white)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 36),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}