
// ignore_for_file: must_be_immutable

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class customeLanguageRow extends StatelessWidget {
  customeLanguageRow({
    super.key,
    required this.language,
    required this.value,
    required this.text,
    this.onChanged,
  });

  String language;
  final String value;
  final String text;
  void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: language,
          onChanged: onChanged,
          activeColor: AppColors.white,
          side: BorderSide(color: AppColors.white),
          toggleable: true,
        ),
        CustomeText(text: text, textColor: AppColors.white),
      ],
    );
  }
}
