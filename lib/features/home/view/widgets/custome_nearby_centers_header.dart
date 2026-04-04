import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeNearbyCentersHeader extends StatelessWidget {
  const CustomeNearbyCentersHeader({super.key});

  @override
  Widget build(BuildContext context) {
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: CustomeText(text: "home.view_all", fontSize: 15,fontWeight: FontWeight.bold,textColor: AppColors.lightGreen,),
        ),

        CustomeText(text: "home.nearby_centers" , fontSize: 20,fontWeight: FontWeight.bold,textColor: AppColors.textPrimary,)
      ],
    );
  }
}