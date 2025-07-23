import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../ads/ads_callback.dart';
import '../../../controller/home_controller.dart';
import '../../../model/vpn_status.dart';
import '../../../service/vpn_engine.dart';
import '../../../transition/left_to_right.dart';
import '../../../transition/right_to_left.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_helper.dart';
import '../../../utils/my_image.dart';
import '../../widgets/text/my_text.dart';
import '../auth/login_screen.dart';
import '../freePlan/free_plan_screen.dart';
import '../pro/pro_screen.dart';
import '../settings/settings_screen.dart';
import 'widget/bottom_sheet.dart';
import 'widget/count_down_timer.dart';
import 'widget/rotate_widget.dart';
import 'widget/rotating_circles_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    AdsCallBack _adsController = Get.put(AdsCallBack());
    AppLayout.screenPortrait();
    VpnEngine.vpnStageSnapshot().listen((event) {
      homeController.vpnState.value = event;
    });
    return Scaffold(
      backgroundColor: MyColor.bg,
      body: Stack(
        children: [
          Obx(
            () => TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(
                  begin: homeController.vpnState.value == VpnEngine.vpnConnected
                      ? 0
                      : 0.15,
                  end: homeController.vpnState.value == VpnEngine.vpnConnected
                      ? 0.15
                      : 0),
              builder: (BuildContext context, double value, Widget? child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  left: -(AppLayout.getScreenWidth(context) * value),
                  right: -(AppLayout.getScreenWidth(context) * value),
                  top: (homeController.vpnState.value == VpnEngine.vpnConnected
                      ? -(AppLayout.getScreenWidth(context) * (value + .55))
                      : AppLayout.getStatusBarHeight(context, 20)),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: RotateWorld(
                      isConnected: homeController.vpnState.value ==
                          VpnEngine.vpnConnected,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: AppLayout.getStatusBarHeight(context, 15),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          const LtRScreenTransition(
                            screen: FreePlanScreen(),
                          ).navigate(context);
                        },
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: Image.asset(
                            MyImage.menuIcon,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (homeController.user.value == null ||
                                  homeController.user.value!.loginMode!
                                      .contains("guest")) {
                                const RtLScreenTransition(
                                  screen: LoginScreen(),
                                ).navigate(context);
                              } else {
                                const RtLScreenTransition(
                                  screen: ProScreen(
                                    fromHome: true,
                                  ),
                                ).navigate(context);
                              }
                            },
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: Image.asset(
                                MyImage.proIcon,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     RtLScreenTransition(
                          //       screen: NotificationScreen(),
                          //     ).navigate(context);
                          //   },
                          //   child: SizedBox(
                          //     height: 35,
                          //     width: 35,
                          //     child: Image.asset(
                          //       MyImage.notificationIcon,
                          //       fit: BoxFit.fill,
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              const RtLScreenTransition(
                                screen: SettingsScreen(),
                              ).navigate(context);
                            },
                            child: SvgPicture.asset(
                              MyImage.settingsIcon,
                              height: 35,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Obx(() => Visibility(
                      visible: homeController.vpnState.value !=
                          VpnEngine.vpnConnected,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: MyColor.ipContainer.withAlpha(180),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    text: "Current Ip",
                                    font: outfitBold.copyWith(
                                        color: MyColor.yellow, fontSize: 14)),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder<String>(
                                  future: homeController.getIPText,
                                  builder: (context, snapshot) {
                                    return MyText(
                                        text: snapshot.data ?? '',
                                        font: outfitLight.copyWith(
                                            color: MyColor.yellow,
                                            fontSize: 14));
                                  },
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                    text: "Status:",
                                    font: outfitBold.copyWith(
                                        color: MyColor.yellow, fontSize: 14)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  homeController.vpnState.value ==
                                          VpnEngine.vpnConnected
                                      ? "Safe"
                                      : "Unsafe",
                                  style: outfitLight.copyWith(
                                      fontSize: 14,
                                      color: homeController.vpnState.value ==
                                              VpnEngine.vpnConnected
                                          ? MyColor.green
                                          : MyColor.orange),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                Obx(() => Visibility(
                      visible: homeController.vpnState.value ==
                          VpnEngine.vpnConnected,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  color: MyColor.ipContainer.withAlpha(180),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                        text: "Current IP",
                                        font: outfitBold.copyWith(
                                            color: MyColor.yellow,
                                            fontSize: 14)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FutureBuilder<String>(
                                      future: homeController.getIPText,
                                      builder: (context, snapshot) {
                                        return MyText(
                                            text: snapshot.data ?? '',
                                            font: outfitLight.copyWith(
                                                color: MyColor.yellow,
                                                fontSize: 14));
                                      },
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(
                                        height: 1,
                                        color: MyColor.yellow,
                                      ),
                                    ),
                                    MyText(
                                        text: "Status:",
                                        font: outfitBold.copyWith(
                                            color: MyColor.yellow,
                                            fontSize: 14)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      homeController.vpnState.value ==
                                              VpnEngine.vpnConnected
                                          ? "Safe"
                                          : "Unsafe",
                                      style: outfitLight.copyWith(
                                          fontSize: 14,
                                          color:
                                              homeController.vpnState.value ==
                                                      VpnEngine.vpnConnected
                                                  ? MyColor.green
                                                  : MyColor.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 6,
                              child: SizedBox(
                                child: StreamBuilder<VpnStatus?>(
                                    initialData: VpnStatus(),
                                    stream: VpnEngine.vpnStatusSnapshot(),
                                    builder: (context, snapshot) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: MyColor.ipContainer
                                                  .withAlpha(180),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                          text: "Download:",
                                                          font: outfitBold
                                                            ..copyWith(
                                                                color: MyColor
                                                                    .yellow,
                                                                fontSize: 14)),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data?.byteIn ??
                                                            '0 kbps',
                                                        maxLines: 1,
                                                        style: outfitLight
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: MyColor
                                                                    .yellow),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Transform.rotate(
                                                  angle: 270 *
                                                      (3.1415926535897932 /
                                                          180),
                                                  child: SvgPicture.asset(
                                                    MyImage.backArrow,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: MyColor.ipContainer
                                                  .withAlpha(180),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      MyText(
                                                          text: "Upload:",
                                                          font: outfitBold
                                                              .copyWith(
                                                                  color: MyColor
                                                                      .yellow,
                                                                  fontSize:
                                                                      14)),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data
                                                                ?.byteOut ??
                                                            '0 kbps',
                                                        maxLines: 1,
                                                        style: outfitLight
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: MyColor
                                                                    .yellow),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Transform.rotate(
                                                  angle: 90 *
                                                      (3.1415926535897932 /
                                                          180),
                                                  child: SvgPicture.asset(
                                                    MyImage.backArrow,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Obx(
                  () => SizedBox(
                    height:
                        homeController.vpnState.value == VpnEngine.vpnConnected
                            ? 120
                            : homeController.checkConnecting
                                ? 200
                                : 250,
                  ),
                ),
                Obx(() => Visibility(
                      visible: homeController.vpnState.value ==
                          VpnEngine.vpnConnected,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: CountDownTimer(
                            startTimer: homeController.vpnState.value ==
                                VpnEngine.vpnConnected,startTime: homeController.vpnConnectedStartTime,),
                      ),
                    )),
                Obx(() => Stack(
                      alignment: Alignment.center,
                      children: [
                        if (homeController.checkConnecting)
                          RotatingCircles(
                            isConnected: homeController.checkConnecting,
                          ),
                        GestureDetector(
                          onTap: () {
                            homeController.onTryConnect();
                          },
                          child: Container(
                            height: homeController.vpnState.value ==
                                        VpnEngine.vpnConnected ||
                                    homeController.checkConnecting
                                ? 148
                                : 124,
                            width: homeController.vpnState.value ==
                                        VpnEngine.vpnConnected ||
                                    homeController.checkConnecting
                                ? 124
                                : 103,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(MyImage.connectIcon),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: homeController.vpnState.value ==
                                          VpnEngine.vpnConnected
                                      ? MyColor.yellow
                                      : MyColor.transparent,
                                  spreadRadius: 10,
                                  blurRadius: 100,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: homeController.vpnState.value !=
                                      VpnEngine.vpnConnected,
                                  child: MyText(
                                    text: homeController.getButtonText,
                                    font: outfitMedium.copyWith(
                                        color: MyColor.black),
                                  ),
                                ),
                                Visibility(
                                  visible: homeController.vpnState.value ==
                                      VpnEngine.vpnConnected,
                                  child: FutureBuilder(
                                    future: Future.delayed(
                                        const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          // homeController.onConnected();
                                        });
                                        return Column(
                                          children: [
                                            const Icon(
                                              Icons.check_rounded,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            MyText(
                                              text: "Connected",
                                              font: outfitLight.copyWith(
                                                  color: MyColor.black,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            MyText(
                                              text: "Disconnect",
                                              font: outfitMedium.copyWith(
                                                  color: MyColor.black,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return MyText(
                                          text: "Connected",
                                          font: outfitMedium.copyWith(
                                              color: MyColor.black,
                                              fontSize: 16),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      ServerBottomSheet(
                        onSelected: (serverValue) {
                          homeController.loadCount().then((value) {
                            print('___ ${homeController.countAds}');
                            if (homeController.countAds == 0) {
                              homeController.adsService.showInterAd();
                              _adsController
                                  .openAdsOnMessageEvent()
                                  .then((value) {
                                if (value.contains(MyHelper.DISMISS)) {
                                  homeController.savedAds().then((value) {
                                    homeController
                                        .saveSelectedServer(serverValue);
                                  });
                                } else {
                                  homeController
                                      .saveSelectedServer(serverValue);
                                }
                              });
                            } else {
                              homeController.savedAds().then((value) {
                                homeController.saveSelectedServer(serverValue);
                              });
                            }
                          });
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(() => Container(
                            height: 56,
                            width: 200,
                            decoration: BoxDecoration(
                              color: MyColor.white.withOpacity(.13),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Center(
                                child: RichText(
                              text: TextSpan(
                                  text: 'To ',
                                  style: outfitLight.copyWith(
                                      fontSize: 14, color: MyColor.yellow),
                                  children: [
                                    TextSpan(
                                        text: homeController
                                                    .selectedServer.value !=
                                                null
                                            ? homeController.selectedServer
                                                .value!.vpnCountry
                                            : "",
                                        style: outfitBold.copyWith(
                                            fontSize: 14,
                                            color: MyColor.yellow))
                                  ]),
                            )),
                          )),
                      Positioned(
                        right: -16,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 32,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: MyColor.yellow,
                              borderRadius: BorderRadius.circular(32)),
                          child: SvgPicture.asset(MyImage.angleArrow),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
