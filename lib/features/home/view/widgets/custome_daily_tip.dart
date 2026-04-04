import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeDailyTip extends StatelessWidget {
  const CustomeDailyTip({super.key, required this.h, required this.w});

final double h;
final double w;
  @override
  Widget build(BuildContext context) {
   return Container(
      padding:  EdgeInsets.all(h*.01),
      decoration: BoxDecoration(
        color: AppColors.lightGreen3,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              CustomeText(text:"home.daily_tip_title",fontSize: 18,fontWeight: FontWeight.bold,textColor: AppColors.lightGreen, ),
               SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF00E676),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
           SizedBox(height: h*.014),

          CustomeText(text: "home.daily_tip_content" , fontSize: 15,fontWeight: FontWeight.w500,textColor: AppColors.levelCardEnd,)
        ],
      ),
    );
  }
}