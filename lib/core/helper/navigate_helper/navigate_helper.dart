import 'package:flutter/material.dart';

class NavigateHelper {

  /// push
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// pushReplacement (بدل الصفحة الحالية)
  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// pushAndRemoveUntil (يمسح كل اللي قبله)
  static void pushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// pop
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}