import 'package:flutter/material.dart';

class AddProcessScreen extends StatefulWidget {
  const AddProcessScreen({super.key});

  @override
  State<AddProcessScreen> createState() => _AddProcessScreenState();
}

class _AddProcessScreenState extends State<AddProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Add"),),
    );
  }
}