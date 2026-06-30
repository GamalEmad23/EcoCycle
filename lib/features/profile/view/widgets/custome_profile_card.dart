import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class customeProfileCard extends StatelessWidget {
  customeProfileCard({
    super.key,
    required this.h,
    required this.w,
    required this.text,
    required this.rate,
  });

  final double h;
  final double w;
  final String text;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .012),
      child: Container(
        height: (h * .11).clamp(92, 116).toDouble(),
        width: (w * .28).clamp(96, 160).toDouble(),
        decoration: BoxDecoration(
          color: AppColors.white,
          //  boxShadow: [
          //    BoxShadow(
          //      blurRadius: 2,
          //      color: Colors.black38,
          //      offset: Offset(2, 3),
          //      spreadRadius: 1
          //    ),
          //  ],
          border: Border.all(color: AppColors.lightGrey, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => Column(
            mainAxisAlignment: .center,
            children: [
              CustomeText(
                text: text,
                fontSize: 14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                centerAlign: true,
              ),
              CustomeText(
                text: rate,
                fontSize: 16,
                textColor: AppColors.primaryDark,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
