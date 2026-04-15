import 'package:animate_do/animate_do.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/onBording/view/onbording_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 3), () {
    if (!mounted) return; // 🔥 أهم سطر

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnbordingScreen()),
    );
  });
}

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Spacer(),
            ZoomIn(
              duration: Duration(seconds: 1),
              child: Image.asset(
                "assets/images/Margin.png",
                width: 300,
                height: 300,
              ),
            ),
            CustomeText(
              text: "EcoCycle",
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            Spacer(),
            FadeInUp(
              delay: Duration(seconds: 2),
              child: Image.asset("assets/icons/Container.png"),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
