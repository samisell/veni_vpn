import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/my_color.dart';

class MySnakeBar {
  static void showSnakeBar(
      String title, String msg,{Color? textColor, Color? bgColor}) {
    Get.snackbar(title, msg,
        backgroundColor: bgColor??MyColor.transparent,
        snackPosition: SnackPosition.TOP,
        colorText: textColor??Colors.white,
        borderRadius: 10,
        borderWidth: 2,
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
  }
}
