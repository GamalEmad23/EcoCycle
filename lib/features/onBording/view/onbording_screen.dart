import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../widget/intro_widget.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  IntroductionScreen(

      globalBackgroundColor: Colors.white,
      pages: [
          IntroWidget(
            image: 'assets/introImage/Overlay.png',
            title: "مرحباً بك في EcoCycle",
            description: "ساهم في حماية البيئة من خلال إعادة التدوير بسهولة وبطريقة مبتكرة.",
          ),

          IntroWidget(
            image: 'assets/introImage/Background+Shadow.png',
            title: "اعثر على أقرب مركز",
            description: "استخدم الخريطة لمعرفة أقرب مراكز إعادة التدوير وتسليم مخلفاتك بسهولة.",
          ),

          IntroWidget(
            image: 'assets/introImage/Main Illustration Placeholder.png',
            title: "اكسِب نقاط ومكافآت",
            description: "قم بتسجيل عمليات إعادة التدوير واحصل على نقاط واستبدلها بخصومات ومكافآت بيئية",
          ),



      ],
      onDone: () {

        Navigator.pushAndRemoveUntil(
            context,
           MaterialPageRoute(builder: (context)=>LoginScreen()),
                (route) => false
        );

      },
      showSkipButton: true,
      skip: Text("Skip",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green),),
      next: Text("Next",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green),),
      done: Text("Finish", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green)),
      dotsDecorator: DotsDecorator(
        activeColor: Colors.green

      ),
    );;
  }
}
