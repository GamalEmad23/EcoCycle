import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/helper/get_helper/get_helper.dart';
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
          GetHelper.getOffAll(LoginScreen());
        },
        showSkipButton: true,
        skip: Text("buttons.skip".tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green),),
        next: Text("buttons.next".tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green),),
        done: Text("buttons.finish".tr(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green)),
        dotsDecorator: DotsDecorator(
          activeColor: Colors.green
      
        ),
      ),
    );
  }
}
