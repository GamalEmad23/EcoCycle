import 'dart:io';

import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'package:eco_cycle/core/widgets/custome_button.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/admin_profile/view/centers_management_screen.dart';
import 'package:eco_cycle/features/admin_profile/view/users_management_screen.dart';
import 'package:eco_cycle/features/admin_profile/view/widgets/section_widget.dart';
import 'package:eco_cycle/features/admin_orders/view/widget/state_box.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_lang_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/helper/navigate_helper/navigate_helper.dart';
import '../../../core/themes/app_colors.dart';
import '../../profile/cubit/cubit/profile_cubit.dart';
import '../cubit/admin_cubit.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.read<AdminCubit>().getAdminData(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        AppColors.isDarkMode = themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return Center(
                    child: SizedBox(
                      height: 58,
                      width: 58,
                      child: CircularProgressIndicator(
                        color: AppColors.green,
                        strokeWidth: 5,
                      ),
                    ),
                  );
                }

                if (state is AdminError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  );
                }

                if (state is AdminSuccess) {
                  final admin = state.admin;
                  final cubit = context.read<AdminCubit>();
                  final user = FirebaseAuth.instance.currentUser;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),

                              GestureDetector(
                                onTap: () async {
                                  if (user == null) return;

                                  final picker = ImagePicker();
                                  final picked = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );

                                  if (picked != null) {
                                    final file = File(picked.path);

                                    final url = await cubit.uploadImage(
                                      file,
                                      user.uid,
                                    );

                                    if (url != null) {
                                      await cubit.updateAdminImage(
                                        user.uid,
                                        url,
                                      );
                                    }
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      (admin.image != null &&
                                          admin.image!.isNotEmpty)
                                      ? NetworkImage(admin.image!)
                                      : null,
                                  child:
                                      (admin.image == null ||
                                          admin.image!.isEmpty)
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 10),

                              CustomeText(
                                text: admin.name.isEmpty
                                    ? "admin_profile.admin".tr()
                                    : admin.name,
                                fontWeight: FontWeight.bold,
                              ),

                              const SizedBox(height: 5),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen3,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomeText(
                                  text: "admin_profile.system_admin".tr(),
                                  textColor: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Expanded(
                                    child: StatBox(
                                      icon: Icons.receipt_long,
                                      title: "admin_profile.orders".tr(),
                                      value: context
                                          .read<AdminCubit>()
                                          .ordersCount
                                          .toString(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: StatBox(
                                      icon: Icons.recycling,
                                      title: "admin_profile.centers".tr(),
                                      value: context
                                          .read<AdminCubit>()
                                          .centersCount
                                          .toString(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: StatBox(
                                      icon: Icons.people_alt,
                                      title: "admin_profile.users".tr(),
                                      value: context
                                          .read<AdminCubit>()
                                          .usersCount
                                          .toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, themeMode) {
                            bool isDark = themeMode == ThemeMode.dark;
                            return sectionWidget(
                              icon: isDark ? Icons.dark_mode : Icons.light_mode,
                              title: isDark ? "Dark Mode" : "Light Mode",
                              subtitle: isDark
                                  ? "Switch to light appearance"
                                  : "Switch to dark appearance",
                              onTap: () {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            );
                          },
                        ),

                        sectionWidget(
                          onTap: () {
                            NavigateHelper.push(context, const UsersScreen());
                          },
                          icon: Icons.people,
                          title: "admin_profile.manage_users".tr(),
                          subtitle: "admin_profile.users_desc".tr(),
                        ),

                        sectionWidget(
                          onTap: () {
                            NavigateHelper.push(
                              context,
                              const RecyclingCentersScreen(),
                            );
                          },
                          icon: Icons.recycling,
                          title: "admin_profile.recycling_centers".tr(),
                          subtitle: "admin_profile.centers_desc".tr(),
                        ),

                        sectionWidget(
                          icon: Icons.language,
                          title: "admin_profile.language".tr(),
                          subtitle: "admin_profile.change_language".tr(),
                          onTap: () {
                            final profileCubit = context.read<ProfileCubit>();
                            showDialog(
                              context: context,
                              builder: (dialogContext) => StatefulBuilder(
                                builder: (dialogContext, setDialogState) =>
                                    Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: AppColors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'admin_profile.select_language'
                                                  .tr(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.black,
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            /// English
                                            CustomeLangCard(
                                              title: 'actions.en'.tr(),
                                              icon: Icons.language,
                                              selected:
                                                  context.locale.languageCode ==
                                                  'en',
                                              onTap: () async {
                                                await profileCubit
                                                    .changeLanguage(
                                                      context,
                                                      "en",
                                                    );
                                                setDialogState(() {});
                                              },
                                            ),

                                            const SizedBox(height: 12),

                                            /// Arabic
                                            CustomeLangCard(
                                              title: 'actions.ar'.tr(),
                                              icon: Icons.language,
                                              selected:
                                                  context.locale.languageCode ==
                                                  'ar',
                                              onTap: () async {
                                                await profileCubit
                                                    .changeLanguage(
                                                      context,
                                                      "ar",
                                                    );
                                                setDialogState(() {});
                                              },
                                            ),

                                            const SizedBox(height: 20),

                                            SizedBox(
                                              width: double.infinity,
                                              child: CustomeButton(
                                                btnColor: AppColors.green,
                                                btnText: CustomeText(
                                                  textColor: AppColors.white,
                                                  text: 'admin_profile.done'
                                                      .tr(),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
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

                        const SizedBox(height: 10),

                        sectionWidget(
                          icon: Icons.logout,
                          title: "admin_profile.logout".tr(),
                          subtitle: "admin_profile.logout_desc".tr(),
                          iconColor: AppColors.red,
                          iconBackgroundColor: AppColors.lightRed,
                          onTap: () async {
                            await context.read<AuthCubit>().Signout();
                            NavigateHelper.pushAndRemoveUntil(
                              context,
                              const LoginScreen(),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "admin_profile.daily_tip".tr(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "admin_profile.tip_content".tr(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}
