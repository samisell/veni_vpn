import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../ads/ads_callback.dart';
import '../../../ads/ads_helper.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_helper.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/switch_exm/SwitchExample.dart';
import '../../widgets/text/my_text.dart';
import 'web_view_screen.dart';

class SettingsScreen extends StatelessWidget {
  final bool? fromFreePlan;

  const SettingsScreen({super.key, this.fromFreePlan = false});

  @override
  Widget build(BuildContext context) {
    //AppLayout.screenPortrait(colors: MyColor.settingsHeader);
    GetStorage sharedPreferences = GetStorage();
    bool isPremium = sharedPref.read(MyHelper.isAccountPremium) ?? false;
    return WillPopScope(
      onWillPop: () async {
        if (!fromFreePlan!) {
          AppLayout.screenPortrait();
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: TextUtil.settings,
          onBackPressed: () {
            if (!fromFreePlan!) {
              AppLayout.screenPortrait();
            }
            Get.back();
          },
        ),
        backgroundColor: MyColor.settingsBody,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                          text: TextUtil.settingsAutoConnect,
                          font: outfitRegular.copyWith(
                              color: MyColor.yellow, fontSize: 18)),
                      SwitchExample(
                        switchValue:
                        sharedPreferences.read(MyHelper.autoConnect) ??
                            false,
                        onChanged: (value) {
                          sharedPreferences.write(MyHelper.autoConnect, value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                          text: TextUtil.settingsSaveLastSelected,
                          font: outfitRegular.copyWith(
                              color: MyColor.yellow, fontSize: 18)),
                      SwitchExample(
                        switchValue:
                        sharedPreferences.read(MyHelper.saveLastServer) ??
                            true,
                        onChanged: (value) {
                          sharedPreferences.write(
                              MyHelper.saveLastServer, value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                          text: TextUtil.settingsNotification,
                          font: outfitRegular.copyWith(
                              color: MyColor.yellow, fontSize: 18)),
                      SwitchExample(
                        switchValue:
                        sharedPreferences.read(MyHelper.notification) ??
                            true,
                        onChanged: (value) {
                          sharedPreferences.write(MyHelper.notification, value);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: MyColor.yellow,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: MyText(
                              text: TextUtil.settingsRemoveAdd,
                              font: outfitRegular.copyWith(
                                  color: MyColor.yellow, fontSize: 18))),
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset(
                          MyImage.proIcon,
                          color: MyColor.yellowDark,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SwitchExample(
                        switchValue:
                        sharedPreferences.read(MyHelper.removeAds) ?? false,
                        onChanged: (value) {
                          if (isPremium) {
                            sharedPreferences.write(MyHelper.removeAds, value);
                          } else {
                            MySnakeBar.showSnakeBar("Remove ad",
                                "Upgrade to premium to enable this feature");
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: MyColor.yellow,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewScreen(
                                  url: sharedPreferences.read(
                                      MyHelper.faqUrl))),
                    );
                  },
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
                        child: MyText(
                            text: TextUtil.faq,
                            font: outfitRegular.copyWith(
                                color: MyColor.yellow, fontSize: 18)),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewScreen(
                                  url:
                                  sharedPreferences.read(MyHelper.contactUrl))),
                    );
                  },
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: MyText(
                            text: TextUtil.contactUs,
                            font: outfitRegular.copyWith(
                                color: MyColor.yellow, fontSize: 18)),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewScreen(
                                  url: sharedPreferences
                                      .read(MyHelper.termsAndCondition))),
                    );
                  },
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: MyText(
                            text: TextUtil.termsCondition,
                            font: outfitRegular.copyWith(
                                color: MyColor.yellow, fontSize: 18)),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewScreen(
                                  url: sharedPreferences
                                      .read(MyHelper.privacyPolicy))),
                    );
                  },
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: MyText(
                            text: TextUtil.privacyPolicy,
                            font: outfitRegular.copyWith(
                                color: MyColor.yellow, fontSize: 18)),
                      )),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() {
          return Container(
            height: Get
                .find<AdsCallBack>()
                .isBannerLoaded
                .value ? 50 : 0,
            color: MyColor.bg,
            child: AdsHelper().showBanner(),
          );
        }),
      ),
    );
  }
}
