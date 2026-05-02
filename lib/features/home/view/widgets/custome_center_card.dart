import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeCenterCard extends StatelessWidget {
  const CustomeCenterCard({super.key, required this.name, required this.address, required this.distance, required this.imgUrl, required this.distanceLable, required this.h, required this.w});
 final String name;
 final String address;
 final String distance;
 final String distanceLable;
 final String imgUrl;
 final double h;
 final double w;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [

          Row(
            children: [
              CustomeText(text: distance.tr() , fontSize: 14,fontWeight: FontWeight.bold,textColor: AppColors.lightGreen,),
              CustomeText(text: distanceLable.tr() , fontSize: 14,fontWeight: FontWeight.bold,textColor: AppColors.lightGreen,),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomeText(text: name.tr() , fontSize: 16 , fontWeight: FontWeight.bold,textColor: AppColors.textPrimary,maxLines: 1,overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(

                      child: CustomeText(text: address , fontSize: 12,textColor: AppColors.textGrey,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imgUrl,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 75,
                  height: 75,
                  color: AppColors.backgroundLight,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textLight,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
