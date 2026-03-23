// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        forceMaterialTransparency: true,
        title: CustomeText(
          text: "profile.title",
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          height: h,
          child: Stack(
            children: [
              /// User Profile Image
              Positioned(
                top: h * .025,
                right: w * .025,
                left: w * .025,
                child: CircleAvatar(
                  backgroundColor: AppColors.lightGreen4,
                  maxRadius: w * .19,
                ),
              ),
              Positioned(
                top: h * .035,
                right: w * .025,
                left: w * .025,
                child: CircleAvatar(maxRadius: w * .17),
              ),

              /// User Name
              Positioned(
                top: h * .22,
                left: w * .1,
                right: w * .1,
                child: Center(
                  child: CustomeText(
                    text: "profile.name",
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// User Rate
              Positioned(
                top: h * .27,
                right: w * .025,
                left: w * .025,
                child: Center(
                  child: Container(
                    height: h * .04,
                    width: w * .5,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen3,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        CustomeText(
                          text: "profile.badge",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        Icon(Icons.workspace_premium, color: AppColors.green),
                      ],
                    ),
                  ),
                ),
              ),

              /// Amountes Cards
              Positioned(
                top: h * .34,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * .031),
                  child: Row(
                    children: [
                      customeProfileCard(
                        h: h,
                        w: w,
                        text: 'stats.points',
                        rate: '4.8K',
                      ),
                      customeProfileCard(
                        h: h,
                        w: w,
                        text: 'stats.recycled',
                        rate: '15.2',
                      ),
                      customeProfileCard(
                        h: h,
                        w: w,
                        text: 'stats.rank',
                        rate: '124',
                      ),
                    ],
                  ),
                ),
              ),

              ///
              Positioned(
                top: h * .49,
                right: 1,
                left: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// History
                    customeLongProfileCard(
                      h: h,
                      w: w,
                      icon: Icons.history,
                      text: CustomeText(text: "actions.recycling_history"),
                    ),

                    /// Language
                    customeLongProfileCard(
                      h: h,
                      w: w,
                      icon: Icons.language,
                      text: CustomeText(text: "actions.language"),
                    ),
                    customeLongProfileCard(
                      h: h,
                      w: w,
                      icon: Icons.info_outline,
                      text: CustomeText(text: "actions.about"),
                    ),
                    customeLongProfileCard(
                      h: h,
                      w: w,
                      icon: Icons.logout,
                      text: CustomeText(text: "actions.logout"),
                      iconColor: AppColors.red,
                      backGroung: AppColors.lightRed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * .005),
      child: GestureDetector(
        onTap: onTap,

        ///
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
                  (context.locale.languageCode == "en")
                      ? Icons.arrow_forward_ios_sharp
                      : Icons.arrow_back_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
