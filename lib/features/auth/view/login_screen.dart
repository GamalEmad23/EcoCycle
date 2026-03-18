// ignore_for_file: unused_local_variable, unused_field, prefer_final_fields

import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_button.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/auth/view/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey();
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
                        text: "login.password",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Password lTextFormField
                    CustomeTextFormField(
                      controller: _password,
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
                        child: CustomeText(text: "login.forgot_password"),
                      ),
                    ),
                    SizedBox(height: h * .025),

                    /// Login Button
                    CustomeButton(
                      btnColor: AppColors.green,
                      onPressed: () {},
                      btnText: CustomeText(
                        text: "login.login_button",
                        textColor: AppColors.white,
                      ),
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
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * .1),
                        child: CustomeButton(
                          btnColor: AppColors.backgroundLight,
                          onPressed: () {},
                          btnText: Row(
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
                    ),
                    SizedBox(height: h * .025),
                     
                    /// Don't have account
                    
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        CustomeText(text: "login.no_account"),
                        Column(
                          children: [
                            CustomeText(text: "login.create_account"),
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
