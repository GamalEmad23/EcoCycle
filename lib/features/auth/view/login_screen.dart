// ignore_for_file: unused_local_variable, unused_field, prefer_final_fields, body_might_complete_normally_nullable

import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_button.dart';
import 'package:eco_cycle/core/widgets/custome_snak_bar.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/admin_orders/view/orders_screen.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/sign_up_screen.dart';
import 'package:eco_cycle/features/auth/view/widgets/custome_text_form_field.dart';
import 'package:eco_cycle/features/auth/view/forget_password_screen.dart';
import 'package:eco_cycle/features/nav_bar/view/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool obsec = true;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await context.setLocale(
                context.locale.languageCode == 'en'
                    ? const Locale('ar')
                    : const Locale('en'),
              );
            },
            icon: Icon(Icons.language),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _globalKey,
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    ///Image
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .03,
                        vertical: h * .03,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        child: Image.asset("assets/authImages/login.png"),
                      ),
                    ),

                    /// Login Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .04),
                      child: CustomeText(
                        text: "login.title",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Login Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .04,
                        vertical: h * .01,
                      ),
                      child: CustomeText(
                        text: "login.subtitle",
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    /// Email Text
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .04,
                        vertical: h * .01,
                      ),
                      child: CustomeText(
                        text: "login.email",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Email TextFormField
                    CustomeTextFormField(
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "login_validation.email_required".tr();
                        }
                        if (!(value.contains("@gmail.com"))) {
                          return "login_validation.email_invalid".tr();
                        }
                      },
                      inputType: TextInputType.emailAddress,
                      hint: "example@mail.com",
                      prefix: Icon(Icons.email_outlined),
                      suffix: null,
                      onFieldSubmitted: (gamal) {
                        FocusScope.of(context).nextFocus();
                      },
                    ),

                    /// Password Text
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .04,
                        vertical: h * .01,
                      ),
                      child: CustomeText(
                        text: "login.password",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Password lTextFormField
                    CustomeTextFormField(
                      controller: _password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "login_validation.password_required".tr();
                        }
                        if (value.length < 6) {
                          return "login_validation.password_short".tr();
                        }
                      },
                      inputType: TextInputType.text,
                      hint: "************",
                      prefix: Icon(Icons.lock_open_outlined),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            obsec = !obsec;
                          });
                        },
                        icon: Icon(
                          obsec
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                      secText: obsec,
                      onFieldSubmitted: (gamal) {
                        FocusScope.of(context).nextFocus();
                      },
                    ),

                    /// forget password text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .025),
                      child: Align(
                        alignment: context.locale.languageCode == "ar"
                            ? AlignmentGeometry.centerLeft
                            : AlignmentGeometry.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // context.read<AuthCubit>().resetPassword();
                            NavigateHelper.pushReplacement(
                              context,
                              ForgetPasswordScreen(),
                            );
                          },
                          child: CustomeText(text: "login.forgot_password"),
                        ),
                      ),
                    ),
                    SizedBox(height: h * .025),

                    /// Login Button
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is LoginFailure) {
                          CustomeSnakBar.show(
                            context: context,
                            message: state.message,
                          );
                        }
                        if (state is LoginSuccess) {
                          CustomeSnakBar.show(
                            context: context,
                            message: "login.success_login".tr(),
                            backgroundColor: AppColors.primary,
                          );

                          if (state.isAdmin) {
                            NavigateHelper.pushAndRemoveUntil(
                              context,
                              OrdersScreen(),
                            );
                          } else {
                            NavigateHelper.pushAndRemoveUntil(
                              context,
                              NavBar(),
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        return CustomeButton(
                          btnColor: AppColors.green,
                          onPressed: () async {
                            if (_globalKey.currentState!.validate()) {
                              await context.read<AuthCubit>().LoginUser(
                                _email.text,
                                _password.text,
                              );
                            }
                          },
                          btnText: (state is LoginLoading)
                              ? CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : CustomeText(
                                  text: "login.login_button",
                                  textColor: AppColors.white,
                                ),
                        );
                      },
                    ),
                    SizedBox(height: h * .025),

                    /// or text
                    Row(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        Container(
                          height: h * .001,
                          width: w * .3,
                          color: AppColors.textGrey,
                        ),
                        CustomeText(text: "login.or", fontSize: 17),
                        Container(
                          height: h * .001,
                          width: w * .3,
                          color: AppColors.textGrey,
                        ),
                      ],
                    ),
                    SizedBox(height: h * .025),

                    /// Google button
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is googleLoginFailure) {
                          CustomeSnakBar.show(
                            context: context,
                            message: state.message,
                          );
                        }
                        if (state is googleLoginSuccess) {
                          CustomeSnakBar.show(
                            context: context,
                            message: "login.success_login".tr(),
                            backgroundColor: AppColors.primary,
                          );
                        }
                      },
                      builder: (context, state) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * .1),
                            child: CustomeButton(
                              btnColor: AppColors.backgroundLight,
                              onPressed: () async {
                                await context
                                    .read<AuthCubit>()
                                    .signInWithGoogle();
                                NavigateHelper.pushAndRemoveUntil(
                                  context,
                                  NavBar(),
                                );
                              },
                              btnText: (state is googleLoginLoading)
                                  ? CircularProgressIndicator(
                                      color: AppColors.green,
                                    )
                                  : Row(
                                      mainAxisAlignment: .center,
                                      children: [
                                        CustomeText(
                                          text: "login.google_login",
                                          fontSize: 17,
                                        ),
                                        SizedBox(width: w * .025),
                                        Image.asset(
                                          "assets/icons/google.png",
                                          height: h * .03,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: h * .025),

                    /// Don't have account
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        CustomeText(text: "login.no_account"),
                        GestureDetector(
                          onTap: () {
                            NavigateHelper.pushReplacement(
                              context,
                              SignUpScreen(),
                            );
                          },
                          child: Column(
                            children: [
                              CustomeText(text: "login.create_account"),
                              Container(
                                height: 2,
                                width: w * .3,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * .04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
