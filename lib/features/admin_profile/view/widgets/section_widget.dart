import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/custome_text.dart';

class sectionWidget extends StatelessWidget {
  const sectionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
     this.onTap
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color:AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.green),
          title: CustomeText(text:title),
          subtitle: CustomeText(text:subtitle,fontSize: 12,textColor: AppColors.textGrey,),
          trailing:  Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
