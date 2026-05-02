// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/core/widgets/custome_button.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:eco_cycle/features/profile/cubit/cubit/profile_cubit.dart';
import 'package:eco_cycle/features/profile/view/widgets/custom_long_profile_card.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_lang_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/profile/view/widgets/about_bottom_sheet.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_profile_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserName();
    context.read<ProfileCubit>().getUserStats();
  }

  var instance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomeText(
          text: "profile.title",
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProfileCubit>().getUserStats();
        },

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: h * 0.05),
            child: Column(
              children: [
                SizedBox(height: h * 0.04),

                /// User Profile Image
                BlocConsumer<ProfileCubit, ProfileState>(
                  listenWhen: (_, current) =>
                      current is ProfileImageUploadSuccess ||
                      current is ProfileImageUploadFailure,
                  listener: (context, state) {
                    if (state is ProfileImageUploadFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'profile.upload_failed'.tr(args: [state.message]),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (state is ProfileImageUploadSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('profile.upload_success'.tr()),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  buildWhen: (_, current) =>
                      current is ProfileStatsSuccess ||
                      current is ProfileImageUploadLoading ||
                      current is ProfileImageUploadSuccess ||
                      current is ProfileImageUploadFailure,
                  builder: (context, state) {
                    // Determine current image URL
                    String? imageUrl;
                    if (state is ProfileStatsSuccess) {
                      imageUrl = state.userImage.isNotEmpty
                          ? state.userImage
                          : null;
                    }

                    final bool isUploading = state is ProfileImageUploadLoading;

                    return GestureDetector(
                      onTap: isUploading
                          ? null
                          : () => context
                                .read<ProfileCubit>()
                                .uploadProfileImage(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring
                          CircleAvatar(
                            backgroundColor: AppColors.lightGreen4,
                            maxRadius: w * .19,
                          ),
                          // Photo or placeholder
                          CircleAvatar(
                            maxRadius: w * .17,
                            backgroundColor: AppColors.white,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl)
                                : null,
                            child: imageUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: w * 0.15,
                                    color: Colors.grey.shade400,
                                  )
                                : null,
                          ),
                          // Upload spinner overlay
                          if (isUploading)
                            CircleAvatar(
                              maxRadius: w * .17,
                              backgroundColor: Colors.black38,
                              child:  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          // Edit pencil badge
                          if (!isUploading)
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen4,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                child:  Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: h * 0.02),

                /// User Name
                BlocBuilder<ProfileCubit, ProfileState>(
                  buildWhen: (previous, current) =>
                      current is userNameFailuer ||
                      current is userNameLoading ||
                      current is userNameSuccess,
                  builder: (context, state) {
                    if (state is userNameLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is userNameSuccess) {
                      return CustomeText(
                        text: state.userName,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      );
                    }

                    if (state is userNameFailuer) {
                      return Text("error");
                    }

                    return SizedBox();
                  },
                ),
                SizedBox(height: h * 0.01),

                /// User Rate
                Container(
                  height: h * .04,
                  width: w * .5,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen3,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomeText(
                        text: "home.${context.watch<ProfileCubit>().getRank(
                          context.watch<ProfileCubit>().Tpoints,
                        )}".tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        context.watch<ProfileCubit>().getRankIcon(
                          context.watch<ProfileCubit>().Tpoints,
                        ),
                        color: context.watch<ProfileCubit>().getRankColor(
                          context.watch<ProfileCubit>().Tpoints,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.03),

                /// Amountes Cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * .031),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    buildWhen: (previous, current) =>
                        current is ProfileStatsFailuer ||
                        current is ProfileStatsLoading ||
                        current is ProfileStatsSuccess,
                    builder: (context, state) {
                      if (state is ProfileStatsLoading) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            customeProfileCard(
                              h: h,
                              w: w,
                              text: '...',
                              rate: '...',
                            ),
                            customeProfileCard(
                              h: h,
                              w: w,
                              text: '...',
                              rate: '...',
                            ),
                            customeProfileCard(
                              h: h,
                              w: w,
                              text: '...',
                              rate: '...',
                            ),
                          ],
                        );
                      }

                      if (state is ProfileStatsSuccess) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            customeProfileCard(
                              h: h,
                              w: w,
                              text: 'stats.points',
                              rate: state.points.toString(),
                            ),
                            customeProfileCard(
                              h: h,
                              w: w,
                              text: 'stats.recycled',
                              rate: state.totalWeight.toString(),
                            ),
                            customeProfileCard(
                              h: h,
                              w: w,
                              text: 'stats.rank',
                              rate: state.totalRequests.toString(),
                            ),
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customeProfileCard(
                            h: h,
                            w: w,
                            text: 'stats.points',
                            rate: '0',
                          ),
                          customeProfileCard(
                            h: h,
                            w: w,
                            text: 'stats.recycled',
                            rate: '0',
                          ),
                          customeProfileCard(
                            h: h,
                            w: w,
                            text: 'stats.rank',
                            rate: '0',
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: h * 0.03),

                /// Actions
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Theme
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        bool isDark = themeMode == ThemeMode.dark;
                        return customeLongProfileCard(
                          h: h,
                          w: w,
                          icon: isDark ? Icons.dark_mode : Icons.light_mode,
                          text: CustomeText(
                            text: isDark ? "Dark Mode" : "Light Mode",
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        );
                      },
                    ),

                    // Language
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
                              backgroundColor: AppColors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// Title
                                    Text(
                                      'profile.select_language'.tr(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    /// English
                                    CustomeLangCard(
                                      title: 'actions.en'.tr(),
                                      icon: Icons.language,
                                      selected:
                                          context.locale.languageCode == 'en',
                                      onTap: () {
                                        context
                                            .read<ProfileCubit>()
                                            .changeLanguage(context, "en");
                                      },
                                    ),

                                    SizedBox(height: 12),

                                    /// Arabic
                                    CustomeLangCard(
                                      title: 'actions.ar'.tr(),
                                      icon: Icons.language,
                                      selected:
                                          context.locale.languageCode == 'ar',
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
                                      child: CustomeButton(
                                        btnColor: AppColors.green,
                                        btnText: CustomeText(
                                          textColor: Colors.white,
                                          text: 'profile.done'.tr(),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context
                                              .read<ProfileCubit>()
                                              .getUserStats();
                                        },
                                      ),
                                    ),
                                  ],
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const AboutBottomSheet(),
                        );
                      },
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
                      onTap: () async {
                        if (FirebaseAuth.instance.currentUser != null) {
                          await context.read<AuthCubit>().Signout();
                          if (context.mounted) {
                            NavigateHelper.pushAndRemoveUntil(
                              context,
                              LoginScreen(),
                            );
                          }
                        }
                      },
                    ),

                    SizedBox(height: h * .07),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



