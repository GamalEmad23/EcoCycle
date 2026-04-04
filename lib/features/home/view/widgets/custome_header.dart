import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeHeader extends StatelessWidget {
  const CustomeHeader({super.key, required this.h, required this.w, required this.imagePath});

final double h;
final double w;
final String imagePath;
  @override
  Widget build(BuildContext context) {
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 CustomeText(
                  text: "home.welcome",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                 CustomeText(
                  text: "home.happy_day",
                  fontSize: 15,
                  textColor: AppColors.textGrey,
                ),
              ],
            ),
            const SizedBox(width: 14),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: w*.07,
                backgroundImage: NetworkImage(
                  imagePath
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}