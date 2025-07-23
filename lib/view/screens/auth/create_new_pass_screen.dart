import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/customBtn/plain_btn.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/textField/CustomTextFiled.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const CreateNewPasswordScreen(
      {super.key, required this.email, required this.otp});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _textPasswordController = TextEditingController();
  final TextEditingController _textConfirmPasswordController =
      TextEditingController();
  FocusNode focusPass = FocusNode();
  FocusNode focusConfirmPass = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textPasswordController.dispose();
    _textConfirmPasswordController.dispose();
    focusPass.dispose();
    focusConfirmPass.dispose();
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: AppLayout.getHeight(context, 20)),
                    child: Text(
                      'Create New Password!',
                      style: outfitSemiBold.copyWith(
                          fontSize: 28, color: MyColor.yellow),
                    ),
                  ),
                  SizedBox(height: AppLayout.getHeight(context, 40)),
                  CustomTextField(
                    hintText: 'Password',
                    controller: _textPasswordController,
                    focusNode: focusPass,
                    onChanged: (value) {
                      if (!focusPass.hasFocus) {
                        _textPasswordController.text = value;
                      }
                      setState(() {});
                    },
                    keyboardType: TextInputType.visiblePassword,
                    password: true,
                  ),
                  SizedBox(height: AppLayout.getHeight(context, 15)),
                  CustomTextField(
                    hintText: 'Confirm Password',
                    controller: _textConfirmPasswordController,
                    focusNode: focusConfirmPass,
                    onChanged: (value) {
                      if (!focusConfirmPass.hasFocus) {
                        _textPasswordController.text = value;
                      }
                      setState(() {});
                    },
                    keyboardType: TextInputType.visiblePassword,
                    password: true,
                  ),
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 40),
                    child:
                        GetBuilder<AuthController>(builder: (authController) {
                      return PlainBtn(
                        text: TextUtil.continue_txt,
                        btnColor: MyColor.yellow,
                        textFont: outfitRegular.copyWith(color: MyColor.bg),
                        isLoading: authController.isLoading,
                        callback: () {
                          FocusScope.of(context).unfocus();
                          if (_textPasswordController.text.length >= 8 &&
                              _textPasswordController.text ==
                                  _textConfirmPasswordController.text) {
                            authController
                                .changePassword(
                                    widget.email,
                                    widget.otp,
                                    _textPasswordController.text,
                                    _textConfirmPasswordController.text)
                                .then((responseModel) {
                              if (responseModel.isSuccess) {
                                MySnakeBar.showSnakeBar(
                                    'Validation', responseModel.message!);
                                Navigator.of(context).pop();
                              } else {
                                MySnakeBar.showSnakeBar(
                                    'Validation', responseModel.message!);
                              }
                            }).catchError((error) {
                              authController.updateError();
                              debugPrint('verify otp error: $error');
                            });
                          } else {
                            MySnakeBar.showSnakeBar(
                                'Validation', 'password not match!');
                          }
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
