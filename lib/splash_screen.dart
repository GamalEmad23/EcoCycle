import 'package:animate_do/animate_do.dart';
import 'package:eco_cycle/features/onBording/view/onbording_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    Future.delayed(
      Duration(seconds: 5),
          () {
        Navigator.pushAndRemoveUntil(
           context,
            MaterialPageRoute
              (builder: (context)=>OnbordingScreen()),
            (route)=>false,
        );
      },
    );
    super.initState();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Spacer(),
            ZoomIn(
                duration: Duration(seconds: 1),
                child: Image.asset("assets/image/Margin.png",width: 300,height: 300,)),
            Text("EcoCycle",style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,

            ),),
            Spacer(),
            FadeInUp(
                delay: Duration(seconds: 2),
                child: Image.asset("assets/icons/Container.png")),
            Spacer(),

          ],
        ),
      ),
    );
  }
}
