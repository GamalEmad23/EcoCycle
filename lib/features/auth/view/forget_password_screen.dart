// ignore_for_file: prefer_final_fields, unused_field, body_might_complete_normally_nullable

import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_button.dart';
import 'package:eco_cycle/core/widgets/custome_snak_bar.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:eco_cycle/features/auth/view/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
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

      body: SingleChildScrollView(
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
                  child: Image.asset("assets/authImages/forgetPassword.png"),
                ),
              ),

              /// Forget Password Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .04),
                child: CustomeText(
                  text: "forgot_password.title",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Forget Password Subtitle
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .04,
                  vertical: h * .01,
                ),
                child: CustomeText(
                  text: "forgot_password.subtitle",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Email Text
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * .04,
                  vertical: h * .01,
                ),
                child: CustomeText(
                  text: "forgot_password.email_label",
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
              SizedBox(height: h * .019),

              /// Send Link Button
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ResetPasswordFailure) {
                    CustomeSnakBar.show(
                      backgroundColor: AppColors.red,
                      icon: Icons.error,
                      context: context,
                      message: "forgot_password.error".tr(),
                    );
                  }
                  if (state is ResetPasswordSuccess) {
                    CustomeSnakBar.show(
                      backgroundColor: AppColors.green,
                      icon: Icons.done,
                      context: context,
                      message: "forgot_password.success".tr(),
                    );
                      NavigateHelper.pushReplacement(context, LoginScreen());
                  }
                },
                builder: (context, state) {
                  return CustomeButton(
                    onPressed: () {
                     if (_globalKey.currentState!.validate()) {
                      context.read<AuthCubit>().resetPassword(_email.text);
                     }
                    },
                    btnWidth: w * .9,
                    btnText: 
                    (state is ResetPasswordLoading)? CircularProgressIndicator(color: AppColors.white,)
                    : CustomeText(
                      text: "forgot_password.reset_button",
                      textColor: AppColors.white,
                    ),
                    btnColor: AppColors.green,
                  );
                },
              ),
              SizedBox(height: h * .019),

              /// under button text
              Center(
                child: CustomeText(
                  text: "forgot_password.info_message",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
