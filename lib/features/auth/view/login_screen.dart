import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
       child: Column(
        mainAxisAlignment: .center,
         children: [
           Center(
            child: ElevatedButton(onPressed: (){
              context.setLocale(Locale("ar"));
              setState(() {
                
              });
            }, child: Text("Change Lang ar")),
           ),

            Center(
            child: ElevatedButton(onPressed: (){
              context.setLocale(Locale("en"));
              setState(() {
                
              });
            }, child: Text("Change Lang en")),
           ),
       
         ],
       ),
     ),
    );
  }
}
