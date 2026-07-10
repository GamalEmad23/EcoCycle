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
import 'package:eco_cycle/core/responsive/responsive_layout.dart';

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
  bool _isUploadingImage = false;

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

                  return ResponsiveContent(
                    maxWidth: 700,
                    child: RefreshIndicator(
                      color: AppColors.green,
                      backgroundColor: AppColors.backgroundLight,
                      onRefresh: () async {
                        if (user != null) {
                          await context
                              .read<AdminCubit>()
                              .getAdminData(user.uid);
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Avatar + camera badge
                                GestureDetector(
                                  onTap: _isUploadingImage
                                      ? null
                                      : () async {
                                          if (user == null) return;
                                          final picker = ImagePicker();
                                          final picked =
                                              await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 70,
                                            maxWidth: 800,
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _isUploadingImage = true;
                                            });
                                            final file = File(picked.path);
                                            final url =
                                                await cubit.uploadImage(
                                              file,
                                              user.uid,
                                            );
                                            if (url != null) {
                                              await cubit.updateAdminImage(
                                                  user.uid, url);
                                            }
                                            if (mounted) {
                                              setState(() {
                                                _isUploadingImage = false;
                                              });
                                            }
                                          }
                                        },
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 42,
                                        backgroundColor: AppColors.lightGreen3,
                                        backgroundImage: (admin.image != null &&
                                                admin.image!.isNotEmpty)
                                            ? NetworkImage(admin.image!)
                                            : null,
                                        child: (admin.image == null ||
                                                admin.image!.isEmpty)
                                            ? Icon(Icons.person,
                                                size: 40,
                                                color: AppColors.primary)
                                            : null,
                                      ),
                                      if (_isUploadingImage)
                                        const CircleAvatar(
                                          radius: 42,
                                          backgroundColor: Colors.black45,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      if (!_isUploadingImage)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    AppColors.backgroundLight,
                                                width: 2,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_rounded,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Name
                                CustomeText(
                                  text: admin.name.isEmpty
                                      ? "admin_profile.admin".tr()
                                      : admin.name,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),

                                const SizedBox(height: 6),

                                // Role badge
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
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Stats Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatBox(
                                        icon: Icons.receipt_long,
                                        title:
                                            "admin_profile.orders".tr(),
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
                                        title:
                                            "admin_profile.centers".tr(),
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
                                        title:
                                            "admin_profile.users".tr(),
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
                                icon: isDark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                title: isDark
                                    ? "app_mode.dark_mode".tr()
                                    : "app_mode.light_mode".tr(),
                                subtitle: isDark
                                    ? "app_mode.light".tr()
                                    : "app_mode.dark".tr(),
                                onTap: () {
                                  context.read<ThemeCubit>().toggleTheme();
                                },
                              );
                            },
                          ),

                          sectionWidget(
                            onTap: () {
                              NavigateHelper.push(
                                  context, const UsersScreen());
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
                            title:
                                "admin_profile.recycling_centers".tr(),
                            subtitle: "admin_profile.centers_desc".tr(),
                          ),

                          sectionWidget(
                            icon: Icons.language,
                            title: "admin_profile.language".tr(),
                            subtitle:
                                "admin_profile.change_language".tr(),
                            onTap: () {
                              final profileCubit =
                                  context.read<ProfileCubit>();
                              showDialog(
                                context: context,
                                builder: (dialogContext) =>
                                    StatefulBuilder(
                                  builder:
                                      (dialogContext, setDialogState) =>
                                          Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    backgroundColor: AppColors.white,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 400,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
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
                                              selected: context
                                                      .locale.languageCode ==
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
                                              selected: context
                                                      .locale.languageCode ==
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
                                                  text:
                                                      'admin_profile.done'
                                                          .tr(),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      dialogContext);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "admin_profile.daily_tip".tr(),
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "admin_profile.tip_content".tr(),
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
