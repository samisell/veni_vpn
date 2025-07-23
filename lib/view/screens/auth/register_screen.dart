import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../transition/fadeTransition.dart';
import '../../../utils/input_formatter.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/customBtn/plain_btn.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/text/my_text.dart';
import '../../widgets/textField/CustomTextFiled.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController _textNumberController = TextEditingController();
  final FocusNode focusName = FocusNode();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPass = FocusNode();
  final FocusNode focusConfirmPass = FocusNode();
  final FocusNode focusNumber = FocusNode();

  // final TextEditingController addressController = TextEditingController();

  final _globalKey = GlobalKey<FormState>();
  String? _countryDialCode = '+880';
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 170,
                      ),
                      MyText(
                          text: TextUtil.register,
                          font: outfitMedium.copyWith(
                              color: MyColor.yellow, fontSize: 28)),
                      const SizedBox(
                        height: 70,
                      ),
                      CustomTextField(
                          hintText: TextUtil.name,
                          controller: nameController,
                          focusNode: focusName,
                          onChanged: (value) {

                          },
                          keyboardType: TextInputType.text),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                          hintText: TextUtil.email,
                          controller: emailController,
                          focusNode: focusEmail,
                          onChanged: (value) {
                            if (!focusEmail.hasFocus) {
                              emailController.text = value;
                            }
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
                          if (!focusPass.hasFocus) {
                            passwordController.text = value;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        password: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: TextUtil.confirmPassword,
                        controller: confirmPasswordController,
                        focusNode: focusConfirmPass,
                        onChanged: (value) {
                          if (!focusConfirmPass.hasFocus) {
                            confirmPasswordController.text = value;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        password: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: TextUtil.number,
                        controller: _textNumberController,
                        focusNode: focusNumber,
                        keyboardType: TextInputType.phone,
                        isPhone: true,
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        onChanged: (value) {
                          if (!focusNumber.hasFocus) {
                            _textNumberController.text = value;
                          }
                        },
                        countryDialCode: _countryDialCode,
                        inputFormatters: [
                          PhoneNumberInputFormatter()
                        ],
                      ),
                      const SizedBox(
                        height: 150,
                      ),

                      Row(
                        children: [
                          Expanded(
                              child: PlainBtn(
                                  text: TextUtil.cancel,
                                  btnColor: MyColor.textFieldBg,
                                  textFont: outfitRegular.copyWith(
                                      color: MyColor.yellow),
                                  callback: () {
                                    FocusScope.of(context).unfocus();
                                    Get.back();
                                  })),
                          const SizedBox(
                            width: 10,
                          ),
                          GetBuilder<AuthController>(builder: (authController) {
                            return Expanded(
                                child: PlainBtn(
                                    text: TextUtil.register,
                                    btnColor: MyColor.yellow,
                                    textFont: outfitRegular.copyWith(
                                        color: MyColor.bg),
                                    isLoading: authController.isLoading,
                                    callback: () {
                                      FocusScope.of(context).unfocus();
                                      final isValid =
                                          _globalKey.currentState!.validate();
                                      if (isValid) {
                                        if (nameController.text.isEmpty) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Enter your name!",
                                          );
                                        } else if (emailController.text.isEmpty) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Enter email address!",
                                          );
                                        } else if (!authController.isEmailValid(emailController.text)) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Enter valid email address!",
                                          );
                                        } else if (passwordController.text.isEmpty) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Enter password!",
                                          );
                                        } else if (passwordController.text.length < 6) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Password length should be 6!",
                                          );
                                        } else if (confirmPasswordController.text.isEmpty) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Enter confirm password!",
                                          );
                                        } else if (confirmPasswordController.text.length < 6) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Password length should be 6!",
                                          );
                                        } else if (passwordController.text != confirmPasswordController.text) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Password not matched!",
                                          );
                                        }else if (_textNumberController.text.isEmpty) {
                                          MySnakeBar.showSnakeBar(
                                            "Sign Up Field",
                                            "Enter your number!",
                                          );
                                        } else {
                                          authController.registration(nameController.text,emailController.text, passwordController.text, '$_countryDialCode${_textNumberController.text}').then((responseModel) {
                                            if (responseModel.isSuccess) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              homeController.getUsers();
                                              FadeScreenTransition(
                                                screen: HomeScreen(),
                                              ).navigate(context);
                                            } else {
                                              MySnakeBar.showSnakeBar(
                                                "Sign Up",
                                                responseModel.message ?? '',
                                              );
                                            }
                                          }).catchError((error) {
                                            MySnakeBar.showSnakeBar(
                                              "Sign Up",
                                              'Something went wrong!',
                                            );
                                            authController.updateError();
                                          });
                                        }
                                      } else {
                                        return null;
                                      }
                                    }));
                          })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
