import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomeLangCard extends StatelessWidget {
  const CustomeLangCard({super.key, required this.title, required this.icon, required this.selected, required this.onTap});

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
       duration: const Duration(milliseconds: 200),
  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  decoration: BoxDecoration(
    color: selected ? AppColors.lightGreen1 : AppColors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: selected ? AppColors.primary : AppColors.border, 
      width: selected ? 2 : 1.2,
    ),
    boxShadow: selected
        ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
        : [],
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          if (selected)
            Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    ),
  );
  }
}
