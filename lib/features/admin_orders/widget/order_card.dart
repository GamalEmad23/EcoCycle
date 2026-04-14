import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/widgets/custome_text.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(bottom: 15),
      padding:  EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/images/Image+Background.png",
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

           SizedBox(height: 10),

          Row(
            children: [
               Expanded(
                child: CustomeText(text:
                "أحمد محمد علي",
                  fontWeight: FontWeight.bold,
                ),
              ),

              Container(
                padding:
                 EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  CustomeText(text:
                "معلق",
                  textColor: AppColors.orange,
                ),
              )
            ],
          ),

           SizedBox(height: 5),

           CustomeText(text: "بلاستيك"),
           SizedBox(height: 5),
           CustomeText(text: "15.5 كجم"),
           SizedBox(height: 5),
           CustomeText(text: "تاريخ الطلب: 27 أكتوبر 2023"),

           SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Center(
                    child: CustomeText(text:
                    "رفض الطلب",
                      textColor:AppColors.white,
                    ),
                  ),
                ),
              ),
               SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Center(
                    child: CustomeText(text:
                    "قبول الطلب",
                      textColor: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}