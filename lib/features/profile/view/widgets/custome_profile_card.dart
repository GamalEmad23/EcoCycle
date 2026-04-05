
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class customeProfileCard extends StatelessWidget {
  const customeProfileCard({
    super.key,
    required this.h,
    required this.w, required this.text, required this.rate,
  });

  final double h;
  final double w;
  final String text;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: w*.012),
      child: Container(
       height: h*.11,
       width: w*.28,
       decoration: BoxDecoration(
         color: Colors.white,
        //  boxShadow: [
        //    BoxShadow(
        //      blurRadius: 2,
        //      color: Colors.black38,
        //      offset: Offset(2, 3),
        //      spreadRadius: 1
        //    ),
        //  ],
        border: Border.all(color: AppColors.lightGrey , width: 3),
         borderRadius: BorderRadius.circular(20),
       ),
       child: Column(
        mainAxisAlignment: .center,
        children: [
          CustomeText(text: text, fontSize: 19,),
          CustomeText(text: rate, fontSize: 18, textColor: AppColors.primaryDark,),
        ],
       ),
      ),
    );
  }
}