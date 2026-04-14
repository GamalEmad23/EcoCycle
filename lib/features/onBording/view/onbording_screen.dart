import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../widget/intro_widget.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: [
          
            IntroWidget(
              image: 'assets/introImage/Overlay.png',
              title: "onboarding.title1".tr(),
              description: "onboarding.desc1".tr(),
            ),
      
            IntroWidget(
              image: 'assets/introImage/Background+Shadow.png',
              title:"onboarding.title2".tr(),
              description: "onboarding.desc2".tr(),
            ),
      
            IntroWidget(
              image: 'assets/introImage/Main Illustration Placeholder.png',
              title: "onboarding.title3".tr(),
              description: "onboarding.desc3".tr(),
            ),
      
      
      
        ],
        onDone: () {
          NavigateHelper.pushAndRemoveUntil(context, LoginScreen());
        },
        showSkipButton: true,
        skip: CustomeText(text: "buttons.skip".tr() , fontSize: 20, fontWeight: FontWeight.bold,textColor: AppColors.green,),
        next: CustomeText(text: "buttons.next".tr() , fontSize: 20, fontWeight: FontWeight.bold,textColor: AppColors.green,),
        done: CustomeText(text: "buttons.finish".tr() , fontSize: 20, fontWeight: FontWeight.bold,textColor: AppColors.green,),
        dotsDecorator: DotsDecorator(
          activeColor: AppColors.green
      
        ),
      ),
    );
  }
}
