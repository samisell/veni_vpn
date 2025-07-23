import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../transition/fadeTransition.dart';
import '../../../transition/right_to_left.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/customBtn/plain_btn.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/text/my_text.dart';
import '../../widgets/textField/CustomTextFiled.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';
import 'reset_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.find<AuthController>();
  HomeController homeController = Get.find<HomeController>();

  final TextEditingController emailController = TextEditingController();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPass = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    //AppLayout.screenPortrait(colors: MyColor.settingsHeader);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            MyImage.loginBg,
            fit: BoxFit.fill,
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 170,
                    ),
                    Text(
                      TextUtil.login,
                      style: outfitMedium.copyWith(
                          fontSize: 28, color: MyColor.yellow),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextField(
                        hintText: TextUtil.email,
                        controller: emailController,
                        focusNode: focusEmail,
                        onChanged: (value) {

                        },
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      hintText: TextUtil.password,
                      controller: passwordController,
                      focusNode: focusPass,
                      onChanged: (value) {

                      },
                      keyboardType: TextInputType.visiblePassword,
                      password: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //forgot password
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          const RtLScreenTransition(
                            screen: ResetPasswordScreen(),
                          ).navigate(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: MyText(
                            text: TextUtil.forgotPassword,
                            font: outfitLight.copyWith(color: MyColor.yellow),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // MyText(
                    //     text: TextUtil.orLogin,
                    //     font: outfitMedium.copyWith(color: MyColor.yellow,fontSize: 14)),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //google login button
                    // MyButton(
                    //     text: TextUtil.withGoogle,
                    //     icon: MyImage.googleIcon,
                    //     textFont: outfitMedium.copyWith(color: MyColor.yellow,fontSize: 14),
                    //     callback: () {
                    //       //with google click
                    //     }),

                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: PlainBtn(
                                text: TextUtil.register,
                                btnColor: MyColor.textFieldBg,
                                textFont: outfitRegular.copyWith(
                                    color: MyColor.yellow),
                                callback: () {
                                  FocusScope.of(context).unfocus();
                                  Get.to(RegisterScreen());
                                })),
                        const SizedBox(
                          width: 10,
                        ),
                        GetBuilder<AuthController>(builder: (authController) {
                          return Expanded(
                            child: PlainBtn(
                              text: TextUtil.login,
                              btnColor: MyColor.yellow,
                              textFont:
                                  outfitRegular.copyWith(color: MyColor.bg),
                              isLoading: authController.isLoading,
                              callback: () {
                                FocusScope.of(context).unfocus();
                                authController
                                    .login(emailController.text,
                                        passwordController.text)
                                    .then((responseModel) {
                                  if (responseModel.isSuccess) {
                                    homeController.getUsers();
                                    Navigator.of(context).pop();
                                    FadeScreenTransition(
                                      screen: HomeScreen(),
                                    ).navigate(context);
                                  } else {
                                    MySnakeBar.showSnakeBar(
                                      "Sign In",
                                      responseModel.message ?? '',
                                    );
                                  }
                                }).catchError((error) {
                                  MySnakeBar.showSnakeBar(
                                    "Sign In",
                                    'Something went wrong!',
                                  );
                                  authController.updateError();
                                });
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
