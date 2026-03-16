import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  IntroductionScreen(

      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              crossAxisAlignment: .center,
              children: [

                SizedBox(height: 80),
                Image.asset(
                  'assets/introImage/Overlay.png',

                ),
                SizedBox(height: 50),
                Text(
                  " ًمرحباً بك في EcoCycle",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  textAlign: TextAlign.center,
                  "ساهم في حماية البيئة من خلال إعادة التدوير\n بسهولة وبطريقة مبتكرة.",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),


              ],
            ),
          ),
          body: "",
        ),

        PageViewModel(
          titleWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                SizedBox(height: 80),

                Image.asset(
                  'assets/introImage/Background+Shadow.png',

                ),
                SizedBox(height: 50),
                Text(
                  "اعثر على أقرب مركز",
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "استخدم الخريطة لمعرفة أقرب مراكز إعادة التدوير وتسليم مخلفاتك بسهولة.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          body: "",
        ),

        PageViewModel(
          titleWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(

              children: [
                SizedBox(height: 80),

                Image.asset(
                  'assets/introImage/Main Illustration Placeholder.png',

                ),
                SizedBox(height: 50),
                Text(
                  "اكسِب نقاط ومكافآت",
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "قم بتسجيل عمليات إعادة التدوير واحصل على نقاط واستبدلها بخصومات ومكافآت بيئية",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          body: "",
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
