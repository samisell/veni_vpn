import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import '../../../ads/ads_callback.dart';
import '../../../ads/ads_helper.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../transition/right_to_left.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/text/my_text.dart';
import '../../widgets/textField/CustomTextFiled.dart';
import '../auth/reset_pass_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  HomeController homeController = Get.find<HomeController>();
  AuthController authController = Get.find<AuthController>();

  TextEditingController _textNameController = TextEditingController();
  TextEditingController _textPhoneController = TextEditingController();
  FocusNode focusName = FocusNode();
  FocusNode focusPhone = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      _textNameController.text = '${homeController.user.value!.name}';
      _textPhoneController.text = '${homeController.user.value!.phone}';
    });
  }

  @override
  Widget build(BuildContext context) {
    //AppLayout.screenPortrait(colors: MyColor.settingsHeader);
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: MyColor.settingsBody,
      body: Column(
        children: [
          Container(
            color: MyColor.settingsHeader,
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                    text: TextUtil.account,
                    font: outfitMedium.copyWith(
                        fontSize: 24, color: MyColor.yellow)),
                SvgPicture.asset(
                  MyImage.accountIcon,
                  height: 72,
                  width: 65,
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: MyColor.settingsBody,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: MyColor.settingsHeader,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                  text: "Name",
                                  font: outfitLight.copyWith(
                                      fontSize: 14, color: MyColor.yellow)),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => IgnorePointer(
                                  ignoring: !authController.isEditing.isTrue,
                                  child: CustomTextField(
                                      hintText: '',
                                      controller: _textNameController,
                                      focusNode: focusName,
                                      fillColor: Colors.transparent,
                                      boxHight: 20,
                                      padding: 0,
                                      onChanged: (value) {
                                        _textNameController.text = value;
                                      },
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (authController.isEditing.isTrue) {
                                FocusScope.of(context).unfocus();
                                if (_textNameController.text.isNotEmpty) {
                                  String data = _textPhoneController.text;
                                  if (data.isEmpty) {
                                    data =
                                        homeController.user.value?.phone ?? '';
                                  }
                                  authController
                                      .updateProfile(
                                          _textNameController.text,
                                          data,
                                          homeController.user.value!.email ??
                                              '')
                                      .then((responseModel) {
                                    if (responseModel.isSuccess) {
                                      authController.changeEditItem(true);
                                      MySnakeBar.showSnakeBar(
                                        "Update Profile",
                                        responseModel.message ?? '',
                                      );
                                    } else {
                                      MySnakeBar.showSnakeBar(
                                        "Update Profile",
                                        responseModel.message ?? '',
                                      );
                                    }
                                  }).catchError((error) {
                                    MySnakeBar.showSnakeBar(
                                      "Update Profile",
                                      'Something went wrong!',
                                    );
                                    authController.updateError();
                                  });
                                } else {
                                  MySnakeBar.showSnakeBar(
                                    "Update Profile",
                                    'Enter Name!',
                                  );
                                }
                              } else {
                                authController.changeEditItem(true);
                              }
                            },
                            child: authController.isEditing.isTrue
                                ? authController.isLoading
                                    ? const CircularProgressIndicator(
                                        color: MyColor.yellow,
                                      )
                                    : SvgPicture.asset(MyImage.doneIcon)
                                : SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: Image.asset(MyImage.editIcon),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: MyColor.settingsHeader,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                text: "Email",
                                font: outfitLight.copyWith(
                                    fontSize: 14, color: MyColor.yellow)),
                            const SizedBox(
                              height: 5,
                            ),
                            MyText(
                                text: homeController.user.value!.email ?? '',
                                font: outfitRegular.copyWith(
                                    color: MyColor.yellow, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: MyColor.settingsHeader,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                text: "Password",
                                font: outfitLight.copyWith(
                                    color: MyColor.yellow, fontSize: 14)),
                            const SizedBox(
                              height: 5,
                            ),
                            MyText(
                                text: "****",
                                font: outfitRegular.copyWith(
                                    color: MyColor.yellow, fontSize: 18)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            RtLScreenTransition(
                              screen: ResetPasswordScreen(
                                email: homeController.user.value!.email ?? '',
                              ),
                            ).navigate(context);
                          },
                          child: SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset(MyImage.editIcon),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: MyColor.settingsHeader,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                  text: "Phone",
                                  font: outfitLight.copyWith(
                                      color: MyColor.yellow, fontSize: 14)),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => IgnorePointer(
                                  ignoring:
                                      !authController.isEditingPhone.isTrue,
                                  child: CustomTextField(
                                      hintText: '',
                                      controller: _textPhoneController,
                                      focusNode: focusPhone,
                                      fillColor: Colors.transparent,
                                      boxHight: 20,
                                      padding: 0,
                                      onChanged: (value) {
                                        _textPhoneController.text = value;
                                      },
                                      keyboardType: TextInputType.phone),
                                ),
                              )
                            ],
                          ),
                        ),
                        Obx(() => GestureDetector(
                              onTap: () {
                                if (authController.isEditingPhone.isTrue) {
                                  FocusScope.of(context).unfocus();
                                  if (_textPhoneController.text.isNotEmpty) {
                                    String data = _textNameController.text;
                                    if (data.isEmpty) {
                                      data =
                                          homeController.user.value!.name ?? '';
                                    }
                                    authController
                                        .updateProfile(
                                            data,
                                            _textPhoneController.text,
                                            homeController.user.value!.email ??
                                                '')
                                        .then((responseModel) {
                                      if (responseModel.isSuccess) {
                                        authController.changeEditItem(false);
                                        MySnakeBar.showSnakeBar(
                                          "Update Profile",
                                          responseModel.message ?? '',
                                        );
                                      } else {
                                        MySnakeBar.showSnakeBar(
                                          "Update Profile",
                                          responseModel.message ?? '',
                                        );
                                      }
                                    }).catchError((error) {
                                      MySnakeBar.showSnakeBar(
                                        "Update Profile",
                                        'Something went wrong!',
                                      );
                                      authController.updateError();
                                    });
                                  } else {
                                    MySnakeBar.showSnakeBar(
                                      "Update Profile",
                                      'Enter phone!',
                                    );
                                  }
                                } else {
                                  authController.changeEditItem(false);
                                }
                              },
                              child: authController.isEditingPhone.isTrue
                                  ? authController.isLoading
                                      ? const CircularProgressIndicator(
                                          color: MyColor.yellow,
                                        )
                                      : SvgPicture.asset(MyImage.doneIcon)
                                  : SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: Image.asset(MyImage.editIcon),
                                    ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 147,
                    //   height: 38,
                    //   child: Image.asset(MyImage.removeAccountIcon),
                    // ),

                    const SizedBox(
                      width: 10,
                    ),

                    GestureDetector(
                      onTap: () {
                        homeController.logOut().then((value) {
                          homeController.doRegisterAsGuest().then((value) {
                            Navigator.of(context).pop();
                          });
                        });
                      },
                      child: SizedBox(
                        width: 93,
                        height: 38,
                        child: Image.asset(MyImage.logoutIcon),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          height: Get.find<AdsCallBack>().isBannerLoaded.value ? 50 : 0,
          color: MyColor.bg,
          child: AdsHelper().showBanner(),
        );
      }),
    );
  }
}
