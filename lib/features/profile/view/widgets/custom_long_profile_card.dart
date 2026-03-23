
// ignore_for_file: must_be_immutable

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class customeLongProfileCard extends StatelessWidget {
  customeLongProfileCard({
    Key? key,
    required this.h,
    required this.w,
    required this.icon,
    this.iconColor,
    required this.text,
    this.backGroung,
    this.onTap,
  }) : super(key: key);

  final double h;
  final double w;
  final IconData icon;
  final Color? iconColor;
  final Widget text;
  final Color? backGroung;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: h * .005),
        child: Container(
          height: h * .09,
          width: w * .89,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 1.5,
                color: Colors.black38,
                offset: Offset(2, .5),
                spreadRadius: .2,
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
        
          /// Container Content
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * .03),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  children: [
                    /// Icon
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: backGroung ?? AppColors.textLight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          icon,
                          color: iconColor ?? AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: w * .025),
        
                    ///Text
                    text,
                  ],
                ),
        
                // SizedBox(width: w*.025,),
                Icon(
                  Icons.arrow_forward_ios
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
