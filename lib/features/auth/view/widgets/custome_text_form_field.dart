// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters, unnecessary_null_in_if_null_operators, must_be_immutable
// ignore_for_file: unused_field

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class CustomeTextFormField extends StatelessWidget {
  CustomeTextFormField({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.hint,
    required this.prefix,
    this.suffix,
    this.validator,
    this.secText,
    this.onFieldSubmitted
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType inputType;
  final String hint;
  final Icon prefix;
  final Widget? suffix;
  final bool? secText;
  String? Function(String?)? validator;
  void Function()? onPressed;
  void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: h * .01),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: secText ?? false,
        keyboardType: inputType,
        onFieldSubmitted:onFieldSubmitted ,

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.border, width: 3),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.lightGreen1, width: 3),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.red, width: 3),
          ),

          disabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.border, width: 3),
          ), 

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.border, width: 3),
          ),

          ///
          hint: CustomeText(
            text: hint,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            textColor: AppColors.textGrey,
          ),

          ///
          prefixIcon: prefix,

          ///
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
