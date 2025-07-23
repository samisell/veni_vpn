import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_color.dart';

class AppLayout {
  static getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getHeight(BuildContext context,double pixels) {
    double x = getScreenHeight(context) / pixels;
    return getScreenHeight(context) / x;
  }

  static getWidth(BuildContext context,double pixels) {
    double x = getScreenWidth(context) / pixels;
    return getScreenWidth(context) / x;
  }

  static getStatusBarHeight(BuildContext context,[int? extra]) {
    int extraHeight =0;
    if(extra!=null){
      extraHeight = extra;
    }
    return MediaQuery.of(context).padding.top+extraHeight;
  }

  static screenPortrait({BuildContext? context, Color? colors}) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    systemStatusColor(colors:colors??Colors.transparent);
  }

  static screenPortrait1({BuildContext? context, Color? colors}) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    systemStatusColor(colors:colors??Colors.transparent);
  }

  static screenLandscape() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: SystemUiOverlay.values);
        // overlays: [SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    systemStatusColor(colors:Colors.transparent);
  }

  static systemStatusColor({BuildContext? context, Color? colors}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colors??MyColor.bg,
      // systemNavigationBarIconBrightness: context != null?ColorUtils.getMode(context)?Brightness.light:Brightness.dark:Brightness.dark,
      systemNavigationBarColor:colors?? MyColor.bg,
    ));
  }
}
