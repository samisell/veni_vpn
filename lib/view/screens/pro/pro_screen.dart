import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import '../../../ads/ads_callback.dart';
import '../../../ads/ads_helper.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_helper.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/text/my_text.dart';
import '../settings/web_view_screen.dart';
import 'widget/count_down_timer_left.dart';
import 'widget/select_payment_method.dart';

class ProScreen extends StatefulWidget {
  final bool? fromHome;

  const ProScreen({super.key, this.fromHome});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  late HomeController homeController;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    authController = Get.find<AuthController>();
    if (homeController.productList.isEmpty) {
      homeController.getSubscriptionPackageList().then((value) {
        homeController.getProducts();
      });
    }
  }

  // Handle Flutterwave payment
  Future<void> _handleFlutterwavePayment(dynamic product) async {
    try {
      if (homeController.user.value!.name!.isEmpty ||
          homeController.user.value!.email!.isEmpty ||
          homeController.user.value!.phone!.isEmpty) {
        MySnakeBar.showSnakeBar(
          "Incomplete",
          "Complete your Profile Info!",
        );
        return;
      }

      final response = await homeController.payUsingFlutterwave(
        context: context,
        amount: product.packagePrice!,
        productId: product.id!,
        packageDuration: product.packageDuration.toString(),
        packageName: product.packageName ?? '',
      );

      final result = await homeController.processFlutterwavePayment(
        response: response,
        productId: product.id!,
        packageDuration: product.packageDuration.toString(),
        originalAmount: product.packagePrice!,
      );

      MySnakeBar.showSnakeBar(
        result.isSuccess ? "Success" : "Error",
        result.message ?? "Unknown error occurred",
      );
    } catch (e) {
      MySnakeBar.showSnakeBar(
        "Error",
        "Payment failed: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: TextUtil.membership,
          onBackPressed: () {
            if (widget.fromHome ?? false) {
              AppLayout.screenPortrait();
            }
            Navigator.pop(context);
          },
        ),
        backgroundColor: MyColor.settingsBody,
        body: Column(
          children: [
        Expanded(
        child: Container(
        decoration: const BoxDecoration(
          color: MyColor.settingsBody,
        ),
        child: Column(
            children: [
            Obx(
            () =>
        Padding(
        padding: const EdgeInsets.symmetric(
        vertical: 15, horizontal: 25),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment
        .start,
    children: [
    MyText(
    text: TextUtil.youAreUsing,
    font: outfitLight.copyWith(
    color: MyColor.yellow,
    fontSize: 20)),
    MyText(
    text: !homeController.isSubscribed
        .value
    ? TextUtil.freePlan
        : homeController
        .user
        .value
        ?.userPackageDetails
        ?.packageName
        .toString() ??
    TextUtil.premiumPlan,
    font: outfitMedium.copyWith(
    color: MyColor.yellow,
    fontSize: 32)),
    if (homeController.isSubscribed.value)
    Padding(
    padding: const EdgeInsets.only(
    top: 10.0),
    child: Row(
    children: [
    Text(
    'Ends in ${homeController.user
        .value?.userPackageDetails
        ?.expiresAt != null
    ? DateFormat(
    'MMM dd, yyyy').format(
    homeController.user.value!
        .userPackageDetails!
        .expiresAt!)
        : 'N/A'}'
        .toString(),
    style: outfitMedium.copyWith(
    color: MyColor.yellow,
    fontSize: 14)),
    SizedBox(
    width: AppLayout.getWidth(
    context, 20),
    ),
    Expanded(
    child: CountDownTimerLeft(
    endTime: homeController.user
        .value
        ?.userPackageDetails
        ?.expiresAt,
    )),
    ],
    ),
    ),
    ],
    ),
    ),
    Visibility(
    visible: !homeController.isSubscribed.value,
    child: SizedBox(
    height: 65,
    width: 70,
    child: Image.asset(MyImage.freeGurdIcon),
    ),
    ),
    ],
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(
    top: 10, bottom: 10, left: 10, right: 10),
    child: Container(
    width: double.infinity,
    height: 1,
    decoration: const BoxDecoration(color: MyColor.yellow),
    ),
    ),
    SizedBox(
    height: 20,
    child: Image.asset(MyImage.proTagIcon),
    ),
    Obx(
    () =>
    Flexible(
    child: homeController.productList.isNotEmpty
    ? ListView.builder(
    itemCount: homeController.productList.length,
    shrinkWrap: true,
    padding: const EdgeInsets.symmetric(
    horizontal: 15, vertical: 10),
    itemBuilder: (context, index) {
    final product = homeController
        .productList[index];
    List<String> savings = [];
    if (index > 0) {
    savings = homeController.calculateSavings(
    homeController
        .productList[index - 1].packagePrice!,
    product.packagePrice!,
    product.packageDuration!,
    homeController
        .productList[index - 1]
        .packageDuration!,
    );
    }

    // Convert USD to Naira for display
    double usdPrice = double.parse(product.packagePrice ?? '0');
    double nairaPrice = MyHelper.convertUsdToNgn(usdPrice);

    return GestureDetector(
    onTap: () {
    Get.bottomSheet(
    SelectPayMethod(
    onSelected: (methodItem) {
    if (methodItem.id == 0) {
    // In-App Purchase
    if (homeController
        .product.isNotEmpty &&
    homeController
        .productIds.isNotEmpty) {
    homeController.iApEngine
        .handlePurchase(
    homeController
        .product[index],
    homeController.productIds);
    } else {
    MySnakeBar.showSnakeBar(
    "Info",
    "No productIds on Test mode!",
    );
    }
    } else if (methodItem.id == 1) {
    // Flutterwave Payment
    _handleFlutterwavePayment(product);
    } else {
    // UddoktaPay (existing code)
    if (homeController
        .user.value!.name!.isEmpty ||
    homeController
        .user.value!.email!
        .isEmpty ||
    homeController
        .user.value!.phone!
        .isEmpty) {
    return MySnakeBar.showSnakeBar(
    "Incomplete",
    "Complete your Profile Info!",
    );
    }
    homeController
        .payUsingUddokta(
    product.packagePrice!,
    product.id!,
    product.packageDuration!)
        .then((responseModel) {
    if (responseModel.isSuccess) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    WebViewScreen(
    url: responseModel
        .message!,
    onSuccess: (
    invoiceId) {
    homeController
        .verifyPayment(
    invoiceId,
    authController)
        .then((
    verifyData) {
    if (verifyData
        .isSuccess) {
    authController
        .updatePaymentDetails(
    verifyData
        .message)
        .then(
    (
    updatePaymentResponse) {
    if (updatePaymentResponse
        .isSuccess) {
    MySnakeBar
        .showSnakeBar(
    "Payment",
    "${updatePaymentResponse
        .message}",
    );
    homeController
        .getUsers();
    } else
    if (updatePaymentResponse
        .code ==
    401) {
    MySnakeBar
        .showSnakeBar(
    "Payment",
    "${updatePaymentResponse
        .message}",
    );
    } else {
    MySnakeBar
        .showSnakeBar(
    "Payment",
    "${updatePaymentResponse
        .message}",
    );
    }
    });
    } else {
    MySnakeBar
        .showSnakeBar(
    "Payment",
    "${responseModel
        .message}",
    );
    }
    }).catchError((
    error) {
    MySnakeBar
        .showSnakeBar(
    "Payment",
    "$error",
    );
    });
    },
    ),
    ),
    );
    } else {
    MySnakeBar.showSnakeBar(
    "Payment",
    "${responseModel.message}",
    );
    }
    }).catchError((error) {
    MySnakeBar.showSnakeBar(
    "Payment",
    "$error",
    );
    });
    }
    },
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    );
    },
    child: Visibility(
    visible: product.status.toString() == "0",
    child: Container(
    margin:
    const EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
    color: MyColor.proItemPackBg,
    borderRadius:
    BorderRadius.circular(10)),
    child: Padding(
    padding: const EdgeInsets.only(
    top: 16,
    bottom: 16,
    left: 10,
    right: 10),
    child: Column(
    children: [
    Row(
    mainAxisAlignment:
    MainAxisAlignment.start,
    children: [
    Expanded(
    child: RichText(
    text: TextSpan(
    text: product
        .packageName ??
    '',
    // Main text
    style: outfitBold
        .copyWith(
    color: MyColor.orange,
    fontSize: 18,
    ),
    children: [
    TextSpan(
    text:
    '  /  ${product
        .packageDuration} days',
    style: outfitRegular
        .copyWith(
    fontSize: 12,
    color: MyColor
        .yellow),
    ),
    ],
    ),
    ),
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    MyText(
    text: MyHelper.formatNairaAmount(nairaPrice),
    font: outfitBold.copyWith(
    color: MyColor.green,
    fontSize: 18)),
    MyText(
    text: '\$${product.packagePrice}',
    font: outfitRegular.copyWith(
    color: MyColor.yellow.withOpacity(0.7),
    fontSize: 12)),
    ],
    ),
    ],
    ),
    if (index > 0)
    const SizedBox(
    height: 6,
    ),
    if (index > 0)
    Row(
    mainAxisAlignment:
    MainAxisAlignment
        .spaceBetween,
    children: [
    Container(
    decoration: BoxDecoration(
    borderRadius:
    BorderRadius.circular(
    30),
    color: MyColor.yellow
        .withAlpha(120)),
    child: Padding(
    padding:
    const EdgeInsets.only(
    left: 8,
    right: 8,
    top: 4,
    bottom: 4),
    child: MyText(
    text:
    "Save ${savings[1]}",
    font: outfitRegular
        .copyWith(
    color: MyColor
        .yellow,
    fontSize: 14)),
    ),
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    Text(
    "₦${MyHelper.convertUsdToNgn(double.parse(savings[0])).toStringAsFixed(0)}",
    style: outfitRegular
        .copyWith(
    decoration: TextDecoration
        .lineThrough,
    color: MyColor.yellow,
    decorationColor:
    MyColor.yellow,
    fontSize: 14),
    ),
    Text(
    "\$${savings[0]}",
    style: outfitRegular
        .copyWith(
    decoration: TextDecoration
        .lineThrough,
    color: MyColor.yellow.withOpacity(0.7),
    decorationColor:
    MyColor.yellow,
    fontSize: 10),
    ),
    ],
    ),
    ],
    )
    ],
    ),
    ),
    ),
    ),
    );
    })
        : const SizedBox(),
    ),
    ),

    Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
    color: MyColor.proItemPackBg,
    borderRadius: BorderRadius.circular(10)),
    child: Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 15, horizontal: 20),
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    MyText(
    text: TextUtil.upgradeToGet,
    font: outfitMedium.copyWith(
    color: MyColor.yellow, fontSize: 16)),
    Image.asset(
    MyImage.proIcon,
    color: MyColor.yellowDark,
    height: 25,
    )
    ],
    ),
    const Divider(
    color: MyColor.yellow,
    height: 20,
    thickness: 1.2,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    SvgPicture.asset('assets/images/ic_tick.svg'),
    const SizedBox(
    width: 5,
    ),
    MyText(
    text: TextUtil.unlock,
    font: outfitLight.copyWith(
    color: MyColor.yellow, fontSize: 16)),
    ],
    ),
    const SizedBox(
    height: 5,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    SvgPicture.asset('assets/images/ic_tick.svg'),
    const SizedBox(
    width: 5,
    ),
      MyText(
          text: TextUtil.fasterConnection,
          font: outfitLight.copyWith(
              color: MyColor.yellow, fontSize: 16)),
    ],
    ),
      const SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/images/ic_tick.svg'),
          const SizedBox(
            width: 5,
          ),
          MyText(
              text: TextUtil.adsFree,
              font: outfitLight.copyWith(
                  color: MyColor.yellow, fontSize: 16)),
        ],
      ),
    ],
    ),
    ),
    ),
              // Loading indicator for Flutterwave
              Obx(() => homeController.isFlutterwaveLoading
                  ? Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: MyColor.proItemPackBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: MyColor.yellow,
                    ),
                    const SizedBox(width: 15),
                    MyText(
                      text: "Processing payment...",
                      font: outfitRegular.copyWith(
                        color: MyColor.yellow,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox()),
            ],
        ),
        )),
          ],
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
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/instance_manager.dart';
// import 'package:get/route_manager.dart';
// import 'package:get/state_manager.dart';
// import 'package:intl/intl.dart';
// import '../../../ads/ads_callback.dart';
// import '../../../ads/ads_helper.dart';
// import '../../../controller/auth_controller.dart';
// import '../../../controller/home_controller.dart';
// import '../../../utils/app_layout.dart';
// import '../../../utils/my_color.dart';
// import '../../../utils/my_font.dart';
// import '../../../utils/my_image.dart';
// import '../../../utils/text_util.dart';
// import '../../widgets/custom_app_bar.dart';
// import '../../widgets/my_snake_bar.dart';
// import '../../widgets/text/my_text.dart';
// import '../settings/web_view_screen.dart';
// import 'widget/count_down_timer_left.dart';
// import 'widget/select_payment_method.dart';
//
// class ProScreen extends StatefulWidget {
//   final bool? fromHome;
//
//   const ProScreen({super.key, this.fromHome});
//
//   @override
//   State<ProScreen> createState() => _ProScreenState();
// }
//
// class _ProScreenState extends State<ProScreen> {
//   late HomeController homeController;
//   late AuthController authController;
//
//   @override
//   void initState() {
//     super.initState();
//     homeController = Get.find<HomeController>();
//     authController = Get.find<AuthController>();
//     if (homeController.productList.isEmpty) {
//       homeController.getSubscriptionPackageList().then((value) {
//         homeController.getProducts();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: TextUtil.membership,
//         onBackPressed: () {
//           if (widget.fromHome ?? false) {
//             AppLayout.screenPortrait();
//           }
//           Navigator.pop(context);
//         },
//       ),
//       backgroundColor: MyColor.settingsBody,
//       body: Column(
//         children: [
//           Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: MyColor.settingsBody,
//                 ),
//                 child: Column(
//                   children: [
//                     Obx(
//                           () =>
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 15, horizontal: 25),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment
//                                         .start,
//                                     children: [
//                                       MyText(
//                                           text: TextUtil.youAreUsing,
//                                           font: outfitLight.copyWith(
//                                               color: MyColor.yellow,
//                                               fontSize: 20)),
//                                       MyText(
//                                           text: !homeController.isSubscribed
//                                               .value
//                                               ? TextUtil.freePlan
//                                               : homeController
//                                               .user
//                                               .value
//                                               ?.userPackageDetails
//                                               ?.packageName
//                                               .toString() ??
//                                               TextUtil.premiumPlan,
//                                           font: outfitMedium.copyWith(
//                                               color: MyColor.yellow,
//                                               fontSize: 32)),
//                                       if (homeController.isSubscribed.value)
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 10.0),
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                   'Ends in ${homeController.user
//                                                       .value?.userPackageDetails
//                                                       ?.expiresAt != null
//                                                       ? DateFormat(
//                                                       'MMM dd, yyyy').format(
//                                                       homeController.user.value!
//                                                           .userPackageDetails!
//                                                           .expiresAt!)
//                                                       : 'N/A'}'
//                                                       .toString(),
//                                                   style: outfitMedium.copyWith(
//                                                       color: MyColor.yellow,
//                                                       fontSize: 14)),
//                                               SizedBox(
//                                                 width: AppLayout.getWidth(
//                                                     context, 20),
//                                               ),
//                                               Expanded(
//                                                   child: CountDownTimerLeft(
//                                                     endTime: homeController.user
//                                                         .value
//                                                         ?.userPackageDetails
//                                                         ?.expiresAt,
//                                                   )),
//                                             ],
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                                 Visibility(
//                                   visible: !homeController.isSubscribed.value,
//                                   child: SizedBox(
//                                     height: 65,
//                                     width: 70,
//                                     child: Image.asset(MyImage.freeGurdIcon),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: 10, bottom: 10, left: 10, right: 10),
//                       child: Container(
//                         width: double.infinity,
//                         height: 1,
//                         decoration: const BoxDecoration(color: MyColor.yellow),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                       child: Image.asset(MyImage.proTagIcon),
//                     ),
//                     Obx(
//                           () =>
//                           Flexible(
//                             child: homeController.productList.isNotEmpty
//                                 ? ListView.builder(
//                                 itemCount: homeController.productList.length,
//                                 shrinkWrap: true,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15, vertical: 10),
//                                 itemBuilder: (context, index) {
//                                   final product = homeController
//                                       .productList[index];
//                                   List<String> savings = [];
//                                   if (index > 0) {
//                                     savings = homeController.calculateSavings(
//                                       homeController
//                                           .productList[index - 1].packagePrice!,
//                                       product.packagePrice!,
//                                       product.packageDuration!,
//                                       homeController
//                                           .productList[index - 1]
//                                           .packageDuration!,
//                                     );
//                                   }
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Get.bottomSheet(
//                                         SelectPayMethod(
//                                           onSelected: (methodItem) {
//                                             if (methodItem.id == 0) {
//                                               if (homeController
//                                                   .product.isNotEmpty &&
//                                                   homeController
//                                                       .productIds.isNotEmpty) {
//                                                 homeController.iApEngine
//                                                     .handlePurchase(
//                                                     homeController
//                                                         .product[index],
//                                                     homeController.productIds);
//                                               } else {
//                                                 MySnakeBar.showSnakeBar(
//                                                   "Info",
//                                                   "No productIds on Test mode!",
//                                                 );
//                                               }
//                                             } else {
//                                               if (homeController
//                                                   .user.value!.name!.isEmpty ||
//                                                   homeController
//                                                       .user.value!.email!
//                                                       .isEmpty ||
//                                                   homeController
//                                                       .user.value!.phone!
//                                                       .isEmpty) {
//                                                 return MySnakeBar.showSnakeBar(
//                                                   "Incomplete",
//                                                   "Complete your Profile Info!",
//                                                 );
//                                               }
//                                               homeController
//                                                   .payUsingUddokta(
//                                                   product.packagePrice!,
//                                                   product.id!,
//                                                   product.packageDuration!)
//                                                   .then((responseModel) {
//                                                 if (responseModel.isSuccess) {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           WebViewScreen(
//                                                             url: responseModel
//                                                                 .message!,
//                                                             onSuccess: (
//                                                                 invoiceId) {
//                                                               homeController
//                                                                   .verifyPayment(
//                                                                   invoiceId,
//                                                                   authController)
//                                                                   .then((
//                                                                   verifyData) {
//                                                                 if (verifyData
//                                                                     .isSuccess) {
//                                                                   authController
//                                                                       .updatePaymentDetails(
//                                                                       verifyData
//                                                                           .message)
//                                                                       .then(
//                                                                           (
//                                                                           updatePaymentResponse) {
//                                                                         if (updatePaymentResponse
//                                                                             .isSuccess) {
//                                                                           MySnakeBar
//                                                                               .showSnakeBar(
//                                                                             "Payment",
//                                                                             "${updatePaymentResponse
//                                                                                 .message}",
//                                                                           );
//                                                                           homeController
//                                                                               .getUsers();
//                                                                         } else
//                                                                         if (updatePaymentResponse
//                                                                             .code ==
//                                                                             401) {
//                                                                           MySnakeBar
//                                                                               .showSnakeBar(
//                                                                             "Payment",
//                                                                             "${updatePaymentResponse
//                                                                                 .message}",
//                                                                           );
//                                                                         } else {
//                                                                           MySnakeBar
//                                                                               .showSnakeBar(
//                                                                             "Payment",
//                                                                             "${updatePaymentResponse
//                                                                                 .message}",
//                                                                           );
//                                                                         }
//                                                                       });
//                                                                 } else {
//                                                                   MySnakeBar
//                                                                       .showSnakeBar(
//                                                                     "Payment",
//                                                                     "${responseModel
//                                                                         .message}",
//                                                                   );
//                                                                 }
//                                                               }).catchError((
//                                                                   error) {
//                                                                 MySnakeBar
//                                                                     .showSnakeBar(
//                                                                   "Payment",
//                                                                   "$error",
//                                                                 );
//                                                               });
//                                                             },
//                                                           ),
//                                                     ),
//                                                   );
//                                                 } else {
//                                                   MySnakeBar.showSnakeBar(
//                                                     "Payment",
//                                                     "${responseModel.message}",
//                                                   );
//                                                 }
//                                               }).catchError((error) {
//                                                 MySnakeBar.showSnakeBar(
//                                                   "Payment",
//                                                   "$error",
//                                                 );
//                                               });
//                                             }
//                                           },
//                                         ),
//                                         backgroundColor: Colors.transparent,
//                                         isScrollControlled: true,
//                                       );
//                                     },
//                                     child: Visibility(
//                                       visible: product.status.toString() == "0",
//                                       child: Container(
//                                         margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                         decoration: BoxDecoration(
//                                             color: MyColor.proItemPackBg,
//                                             borderRadius:
//                                             BorderRadius.circular(10)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 16,
//                                               bottom: 16,
//                                               left: 10,
//                                               right: 10),
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                                 children: [
//                                                   Expanded(
//                                                     child: RichText(
//                                                       text: TextSpan(
//                                                         text: product
//                                                             .packageName ??
//                                                             '',
//                                                         // Main text
//                                                         style: outfitBold
//                                                             .copyWith(
//                                                           color: MyColor.orange,
//                                                           fontSize: 18,
//                                                         ),
//                                                         children: [
//                                                           TextSpan(
//                                                             text:
//                                                             '  /  ${product
//                                                                 .packageDuration} days',
//                                                             style: outfitRegular
//                                                                 .copyWith(
//                                                                 fontSize: 12,
//                                                                 color: MyColor
//                                                                     .yellow),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   MyText(
//                                                       text:
//                                                       '\$${product
//                                                           .packagePrice}',
//                                                       font: outfitBold.copyWith(
//                                                           color: MyColor.green,
//                                                           fontSize: 18)),
//                                                 ],
//                                               ),
//                                               if (index > 0)
//                                                 const SizedBox(
//                                                   height: 6,
//                                                 ),
//                                               if (index > 0)
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                                   children: [
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.circular(
//                                                               30),
//                                                           color: MyColor.yellow
//                                                               .withAlpha(120)),
//                                                       child: Padding(
//                                                         padding:
//                                                         const EdgeInsets.only(
//                                                             left: 8,
//                                                             right: 8,
//                                                             top: 4,
//                                                             bottom: 4),
//                                                         child: MyText(
//                                                             text:
//                                                             "Save ${savings[1]}",
//                                                             font: outfitRegular
//                                                                 .copyWith(
//                                                                 color: MyColor
//                                                                     .yellow,
//                                                                 fontSize: 14)),
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "\$ ${savings[0]}",
//                                                       style: outfitRegular
//                                                           .copyWith(
//                                                           decoration: TextDecoration
//                                                               .lineThrough,
//                                                           color: MyColor.yellow,
//                                                           decorationColor:
//                                                           MyColor.yellow,
//                                                           fontSize: 14),
//                                                     ),
//                                                   ],
//                                                 )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 })
//                                 : const SizedBox(),
//                           ),
//                     ),
//
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 15),
//                       decoration: BoxDecoration(
//                           color: MyColor.proItemPackBg,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 15, horizontal: 20),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 MyText(
//                                     text: TextUtil.upgradeToGet,
//                                     font: outfitMedium.copyWith(
//                                         color: MyColor.yellow, fontSize: 16)),
//                                 Image.asset(
//                                   MyImage.proIcon,
//                                   color: MyColor.yellowDark,
//                                   height: 25,
//                                 )
//                               ],
//                             ),
//                             const Divider(
//                               color: MyColor.yellow,
//                               height: 20,
//                               thickness: 1.2,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SvgPicture.asset('assets/images/ic_tick.svg'),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 MyText(
//                                     text: TextUtil.unlock,
//                                     font: outfitLight.copyWith(
//                                         color: MyColor.yellow, fontSize: 16)),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SvgPicture.asset('assets/images/ic_tick.svg'),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 MyText(
//                                     text: TextUtil.fasterConnection,
//                                     font: outfitLight.copyWith(
//                                         color: MyColor.yellow, fontSize: 16)),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SvgPicture.asset('assets/images/ic_tick.svg'),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 MyText(
//                                     text: TextUtil.adsFree,
//                                     font: outfitLight.copyWith(
//                                         color: MyColor.yellow, fontSize: 16)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(
//                     //   height: 30,
//                     // ),
//                     // Visibility(
//                     //   visible: !homeController.isSubscribed,
//                     //   child: Padding(
//                     //     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     //     child: PlainBtn(
//                     //         text: 'Restore Subscription',
//                     //         btnColor: MyColor.proItemPackBg,
//                     //         textFont: outfitRegular.copyWith(color: MyColor.yellow),
//                     //         callback: () {
//                     //           homeController.iApEngine.inAppPurchase
//                     //               .restorePurchases();
//                     //         }),
//                     //   ),
//                     // )
//                   ],
//                 ),
//               )),
//         ],
//       ),
//       bottomNavigationBar: Obx(() {
//         return Container(
//           height: Get
//               .find<AdsCallBack>()
//               .isBannerLoaded
//               .value ? 50 : 0,
//           color: MyColor.bg,
//           child: AdsHelper().showBanner(),
//         );
//       }),
//     );
//   }
// }
