import 'dart:io';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/admin_profile/view/widgets/section_widget.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_lang_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/helper/navigate_helper/navigate_helper.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../admin_orders/view/widget/state_box.dart';
import '../../../profile/cubit/cubit/profile_cubit.dart';
import '../../cubit/admin_cubit.dart';
import '../centers_management_screen.dart';
import '../users_management_screen.dart';

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
    AppColors.isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminError) {
              return Center(child: Text(state.message));
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
                                  await cubit.updateAdminImage(user.uid, url);
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
                                  (admin.image == null || admin.image!.isEmpty)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StatBox(
                                title: "admin_profile.orders".tr(),
                                value: context
                                    .read<AdminCubit>()
                                    .ordersCount
                                    .toString(),
                              ),
                              StatBox(
                                title: "admin_profile.centers".tr(),
                                value: context
                                    .read<AdminCubit>()
                                    .centersCount
                                    .toString(),
                              ),
                              StatBox(
                                title: "admin_profile.users".tr(),
                                value: context
                                    .read<AdminCubit>()
                                    .usersCount
                                    .toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

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
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
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
                                    "admin_profile.select_language".tr(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomeLangCard(
                                    title: "actions.en".tr(),
                                    icon: Icons.language,
                                    selected:
                                        context.locale.languageCode == "en",
                                    onTap: () async {
                                      await context
                                          .read<ProfileCubit>()
                                          .changeLanguage(context, "en");
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  CustomeLangCard(
                                    title: "actions.ar".tr(),
                                    icon: Icons.language,
                                    selected:
                                        context.locale.languageCode == "ar",
                                    onTap: () async {
                                      await context
                                          .read<ProfileCubit>()
                                          .changeLanguage(context, "ar");
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("admin_profile.done".tr()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () async {
                        await context.read<AuthCubit>().Signout();
                        NavigateHelper.pushAndRemoveUntil(
                          context,
                          const LoginScreen(),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.lightRed,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.logout, color: AppColors.red),
                          title: Text(
                            "admin_profile.logout".tr(),
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          subtitle: Text(
                            "admin_profile.logout_desc".tr(),
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
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
  }
}
