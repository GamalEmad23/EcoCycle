// ignore_for_file: unnecessary_import, use_function_type_syntax_for_parameters

import 'package:flutter/widgets.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';

class GetHelper {

 static void getTo(Widget page){
    Get.to(page);
  }

  static void getBack(){
    Get.back();
  }
 
  /// delete prev page 
  static void getOff(Widget page){
    Get.off(page);
  }
  
  /// delete all pages 
  static void getOffAll(Widget page){
    Get.offAll(page);
  }
  
  /// Get Snack bar
   static void showSnackBar({required String title , required String message , required Color backGround}) {
    Get.snackbar(title, message, backgroundColor:backGround );
  }
}