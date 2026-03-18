// ignore_for_file: prefer_final_fields, unused_field, body_might_complete_normally_nullable

import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_button.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool obsec = false;
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
                        child: Image.asset("assets/authImages/signup.png"),
                      ),
                    ),

                    /// sign up Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * .04),
                      child: CustomeText(
                        text: "signup.title",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Sign up Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .04,
                        vertical: h * .01,
                      ),
                      child: CustomeText(
                        text: "signup.subtitle",
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                     /// Nmae Text
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * .04,
                        vertical: h * .01,
                      ),
                      child: CustomeText(
                        text: "signup.name_label",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Email TextFormField
                    CustomeTextFormField(
                      controller: _name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "signup_validation.name_required".tr();
                        }

                        if (value.length <2) {
                          return "signup_validation.name_short".tr();
                        }
                      },
                      inputType: TextInputType.text,
                      hint: "signup.name_hint",
                      prefix: Icon(Icons.email_outlined),
                      suffix: null,
                      onFieldSubmitted: (gamal) {
                        FocusScope.of(context).nextFocus();
                      },
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
                          return "signup_validation.email_required".tr();
                        }
                        if (!(value.contains("@gmail.com"))) {
                          return "signup_validation.email_invalid".tr();
                        }
                      },
                      inputType: TextInputType.text,
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
                        text: "signup.password_label",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Password lTextFormField
                    CustomeTextFormField(
                      controller: _password,
                      validator: (value) {
                         if (value!.isEmpty) {
                          return "signup_validation.password_required".tr();
                        }
                        if (value.length<6) {
                          return "signup_validation.password_short".tr();
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
                    SizedBox(height: h * .025),

                    

                    /// sign up Button
                    CustomeButton(
                      btnColor: AppColors.green,
                      onPressed: () {
                        if (_globalKey.currentState!.validate()) {
                          context.read<AuthCubit>();
                        }
                      },
                      btnText: CustomeText(
                        text: "signup.signup_button",
                        textColor: AppColors.white,
                      ),
                    ),
                    SizedBox(height: h * .025),

                    
                     
                    /// Don't have account
                    
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        CustomeText(text: "signup.have_account"),
                        Column(
                          children: [
                            CustomeText(text: "signup.login_now"),
                            Container(height: 2,width: w*.3,color: AppColors.black,)
                          ],
                        )
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