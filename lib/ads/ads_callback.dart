import 'package:get/get.dart';

import '../utils/my_helper.dart';

class AdsCallBack extends GetxController {
  var dismiss = false.obs;
  var failed = false.obs;
  var isBannerLoaded = false.obs;
  var isPremium = false.obs;

  void setFailed() {
    failed.value = true;
  }

  void setDismiss() {
    dismiss.value = true;
  }

  Future<String> openAdsOnMessageEvent() async {
    if (dismiss.value) {
      return MyHelper.DISMISS;
    } else {
      return MyHelper.FAILED;
    }
  }
}
