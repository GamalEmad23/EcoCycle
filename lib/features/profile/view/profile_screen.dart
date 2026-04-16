// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:eco_cycle/features/profile/view/widgets/custom_long_profile_card.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_lang_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_profile_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      text: CustomeText(
                        text: "actions.language",
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, state) {
                                    if (state is ProfileLanguageState) {
                                      return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// Title
                                        Text(
                                          "Select Language",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),

                                        SizedBox(height: 20),

                                        /// English
                                        CustomeLangCard(
                                          title: "English",
                                          icon: Icons.language,
                                          selected: state.langCode=='en',
                                          onTap: () {
                                            context
                                                .read<ProfileCubit>()
                                                .changeLanguage(context, "en");
                                          },
                                        ),

                                        SizedBox(height: 12),

                                        /// Arabic
                                        CustomeLangCard(
                                          title: "العربية",
                                          icon: Icons.language,
                                          selected: state.langCode=='ar' ,
                                          onTap: () {
                                            context
                                                .read<ProfileCubit>()
                                                .changeLanguage(context, "ar");
                                          },
                                        ),

                                        SizedBox(height: 20),

                                        /// Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                0xFF8FD3A8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text("Done"),
                                          ),
                                        ),
                                      ],
                                    );
                                    }

                                    return SizedBox();
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    /// Info
                    customeLongProfileCard(
                      h: h,
                      w: w,
                      icon: Icons.info_outline,
                      text: CustomeText(text: "actions.about"),
                    ),

                    customeLongProfileCard(
                      h: h,
                      w: w,
                      icon: context.locale.languageCode == "en"
                          ? Icons.logout
                          : Icons.login_outlined,
                      text: CustomeText(text: "actions.logout"),
                      iconColor: AppColors.red,
                      backGroung: AppColors.lightRed,
                      onTap: () {
                        context.read<AuthCubit>().Signout();
                        if (FirebaseAuth.instance.currentUser == null) {
                          NavigateHelper.pushAndRemoveUntil(
                            context,
                            LoginScreen(),
                          );
                        }
                      },
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
