import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroWidget extends PageViewModel {
  IntroWidget({
    required String image,
    required String title,
    required String description,
  }) : super(
    titleWidget: Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(50),
            child: Image.asset(image , height: 300,)),

          const SizedBox(height: 35),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    ),
    body: "",
  );
}