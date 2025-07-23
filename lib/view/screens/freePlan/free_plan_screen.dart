import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../ads/ads_callback.dart';
import '../../../ads/ads_helper.dart';
import '../../../controller/free_plan_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../transition/right_to_left.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/text/my_text.dart';
import '../account/account_screen.dart';
import '../auth/login_screen.dart';
import '../pro/pro_screen.dart';
import '../pro/widget/count_down_timer_left.dart';
import '../settings/settings_screen.dart';

class FreePlanScreen extends StatefulWidget {
  const FreePlanScreen({super.key});

  @override
  State<FreePlanScreen> createState() => _FreePlanScreenState();
}

class _FreePlanScreenState extends State<FreePlanScreen> {
  FreePlanController freePlanController = Get.put(FreePlanController());
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    //AppLayout.screenPortrait(colors: MyColor.settingsHeader);
    return WillPopScope(
      onWillPop: () async {
        AppLayout.screenPortrait();
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: '',
        ),
        backgroundColor: MyColor.settingsBody,
        body: Obx(() {
          return Column(
            children: [
              Container(
                color: MyColor.settingsHeader,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                        text: !homeController.isSubscribed.value
                            ? TextUtil.freePlan
                            : homeController
                                    .user.value?.userPackageDetails?.packageName
                                    .toString() ??
                                TextUtil.premiumPlan,
                        font: outfitMedium.copyWith(
                            color: MyColor.yellow, fontSize: 24)),
                    InkWell(
                      onTap: () {
                        if (homeController.user.value == null ||
                            homeController.user.value!.loginMode!
                                .contains("guest")) {
                          const RtLScreenTransition(
                            screen: LoginScreen(),
                          ).navigate(context);
                        } else {
                          const RtLScreenTransition(
                            screen: ProScreen(),
                          ).navigate(context);
                        }
                      },
                      child: Visibility(
                        visible: !homeController.isSubscribed.value,
                        child: SizedBox(
                          height: 29,
                          width: 106,
                          child: Image.asset(
                            MyImage.upgradeProIcon,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: MyColor.settingsBody,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (homeController.user.value == null ||
                              homeController.user.value!.loginMode!
                                  .contains("guest") ||
                              homeController.user.value!.name == null) {
                            const RtLScreenTransition(
                              screen: LoginScreen(),
                            ).navigate(context);
                          } else {
                            const RtLScreenTransition(
                              screen: AccountScreen(),
                            ).navigate(context);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColor.settingsHeader,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 16, bottom: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(MyImage.accountIcon),
                                const SizedBox(
                                  width: 8,
                                ),
                                MyText(
                                    text: TextUtil.account,
                                    font: outfitRegular.copyWith(
                                        color: MyColor.yellow, fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     const RtLScreenTransition(
                      //       screen: DevicesScreen(),
                      //     ).navigate(context);
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color: MyColor.settingsHeader,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 10, right: 10, top: 16, bottom: 16),
                      //       child: Row(
                      //         children: [
                      //           SvgPicture.asset(MyImage.deviceIcon),
                      //           const SizedBox(
                      //             width: 8,
                      //           ),
                      //           MyText(
                      //               text: TextUtil.devices,
                      //               font: outfitRegular.copyWith(
                      //                   color: MyColor.yellow, fontSize: 18))
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      GestureDetector(
                        onTap: () {
                          const RtLScreenTransition(
                            screen: SettingsScreen(
                              fromFreePlan: true,
                            ),
                          ).navigate(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColor.settingsHeader,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 16, bottom: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  MyImage.settingsIcon,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                MyText(
                                    text: TextUtil.settings,
                                    font: outfitRegular.copyWith(
                                        color: MyColor.yellow, fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: MyColor.settingsHeader,
                      //       borderRadius: BorderRadius.circular(10)),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 10, right: 10, top: 16, bottom: 16),
                      //     child: Row(
                      //       children: [
                      //         SvgPicture.asset(MyImage.filterIcon),
                      //         const SizedBox(
                      //           width: 8,
                      //         ),
                      //         const MyText(
                      //             text: TextUtil.appsFilter,
                      //             textSize: 18,
                      //             textColor: MyColor.yellow,
                      //             font: MyFont.outfitRegular)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      InkWell(
                        onTap: () {
                          freePlanController.openStore();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColor.settingsHeader,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 16, bottom: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(MyImage.rateUsIcon),
                                const SizedBox(
                                  width: 8,
                                ),
                                MyText(
                                    text: TextUtil.rateUs,
                                    font: outfitRegular.copyWith(
                                        color: MyColor.yellow, fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          //share app
                          freePlanController.shareApp();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColor.settingsHeader,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 16, bottom: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(MyImage.shareIcon),
                                const SizedBox(
                                  width: 8,
                                ),
                                MyText(
                                    text: TextUtil.share,
                                    font: outfitRegular.copyWith(
                                        color: MyColor.yellow, fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )),
            ],
          );
        }),
        bottomNavigationBar: Obx(() {
          return Container(
            height: Get.find<AdsCallBack>().isBannerLoaded.value ? 50 : 0,
            color: MyColor.bg,
            child: AdsHelper().showBanner(),
          );
        }),
      ),
    );
  }
}
