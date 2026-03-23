// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomeButton extends StatelessWidget {
  CustomeButton({super.key, this.btnColor, this.onPressed, this.btnHight, this.btnWidth, required this.btnText});

  void Function()? onPressed;
  final Color? btnColor;
  final double? btnHight;
  final double? btnWidth;
  final Widget btnText;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Center(
      child: MaterialButton(
        onPressed: onPressed,
        color: btnColor ?? Colors.transparent,
        height:btnHight ?? h*.07,
        minWidth: btnWidth ?? w*.7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15)),
        child: btnText,
      ),
      
    );
  }
}
