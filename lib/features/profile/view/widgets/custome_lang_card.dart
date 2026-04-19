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
    color: selected ? const Color(0xFFE8F5E9) : Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: selected ? const Color(0xFF4CAF50) : Colors.grey.shade300, 
      width: selected ? 2 : 1.2,
    ),
    boxShadow: selected
        ? [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
        : [],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (selected)
            Icon(Icons.check_circle, color: Color(0xFF8FD3A8)),
        ],
      ),
    ),
  );
  }
}
