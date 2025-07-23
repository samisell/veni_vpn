import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../transition/right_to_left.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/customBtn/plain_btn.dart';
import '../../widgets/my_snake_bar.dart';
import '../../widgets/textField/CustomTextFiled.dart';
import 'otp_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? email;

  const ResetPasswordScreen({Key? key, this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _textEmailController = TextEditingController();
  FocusNode focusEmail = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      setState(() {
        _textEmailController.text = widget.email!;
      });
    }
  }

  @override
  void dispose() {
    _textEmailController.dispose();
    focusEmail.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Enter Email',
                    style: outfitMedium.copyWith(
                        fontSize: 28,
                        color: MyColor.yellow),
                  ),
                  SizedBox(height: AppLayout.getHeight(context, 50)),
                  CustomTextField(
                    hintText: 'Email',
                    controller: _textEmailController,
                    focusNode: focusEmail,
                    onChanged: (value) {
                      if (!focusEmail.hasFocus) {
                        _textEmailController.text = value;
                      }
                      setState(() {});
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 40),
                    child: GetBuilder<AuthController>(builder: (authController) {
                      return PlainBtn(
                        text: TextUtil.continue_txt,
                        btnColor: MyColor.yellow,
                        textFont: outfitRegular.copyWith(color: MyColor.bg),
                        isLoading: authController.isLoading,
                        callback: () {
                          FocusScope.of(context).unfocus();
                          if (_textEmailController.text.isNotEmpty) {
                            authController
                                .sendOtp(_textEmailController.text)
                                .then((responseModel) {
                              if (responseModel.isSuccess) {
                                RtLScreenTransition(
                                  remove: true,
                                  screen: OtpScreen(
                                    email: _textEmailController.text,
                                  ),
                                ).navigate(context);
                              } else {
                                MySnakeBar.showSnakeBar('Validation', responseModel.message!);
                              }
                            }).catchError((error) {
                              authController.updateError();
                              debugPrint('reset pass error: $error');
                            });
                          } else {
                            MySnakeBar.showSnakeBar('Validation', 'write e-mail!');
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
