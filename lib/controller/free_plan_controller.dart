import 'dart:io';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FreePlanController extends GetxController {

  void openStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;

    String storeUrl;
    if (Platform.isAndroid) {
      storeUrl = 'https://play.google.com/store/apps/details?id=$packageName';
    } else if (Platform.isIOS) {
      storeUrl = 'https://apps.apple.com/app/<your-app-id>'; // Replace <your-app-id> with your App Store ID
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    if (await canLaunchUrl(Uri.parse(storeUrl))) {
      launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not launch $storeUrl");
    }
  }

  void shareApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;

    String shareUrl;
    if (Platform.isAndroid) {
      shareUrl = 'http://play.google.com/store/apps/details?id=$packageName';
    } else if (Platform.isIOS) {
      shareUrl = 'https://apps.apple.com/app/<your-app-id>';// Replace <your-app-id> with your App Store ID
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    Share.share(shareUrl);
  }
}
