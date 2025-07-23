import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../controller/auth_controller.dart';
import '../../../transition/right_to_left.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/customBtn/plain_btn.dart';
import '../../widgets/my_snake_bar.dart';
import 'create_new_pass_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer? _timer;
  int _seconds = 0;
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  void _startTimer() {
    _seconds = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {},
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );

    _startTimer();
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    final appSignature = await _otpInteractor.getAppSignature();
  }

  @override
  void dispose() {
    controller.stopListen();
    _timer?.cancel();
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: AppLayout.getHeight(context, 20)),
                    child: Text(
                      'Enter OTP',
                      style: outfitMedium.copyWith(
                          fontSize: 28, color: MyColor.yellow),
                    ),
                  ),
                  SizedBox(height: AppLayout.getHeight(context, 40)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: PinCodeTextField(
                      length: 6,
                      appContext: context,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.slide,
                      useHapticFeedback: true,
                      enablePinAutofill: true,
                      textStyle: outfitMedium.copyWith(color: Colors.black),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldHeight: AppLayout.getWidth(context, 50),
                        fieldWidth: AppLayout.getWidth(context, 50),
                        borderWidth: 0,
                        activeBorderWidth: 0,
                        inactiveBorderWidth: 0,
                        selectedBorderWidth: 1,
                        borderRadius: BorderRadius.circular(8),
                        selectedColor: MyColor.yellow,
                        selectedFillColor: Colors.transparent,
                        inactiveFillColor: MyColor.yellow,
                        inactiveColor: MyColor.yellowDark,
                        activeColor: MyColor.yellowDark,
                        activeFillColor: MyColor.yellow,
                      ),
                      animationDuration:
                      const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onChanged: (value) {},
                      beforeTextPaste: (text) => true,
                    ),
                  ),
                  Visibility(
                    visible: _seconds == 0,
                    child: GetBuilder<AuthController>(
                        builder: (authController) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 70,
                                child: PlainBtn(
                                  text: 'Resend',
                                  paddingVer: 5,
                                  loadingColor: MyColor.yellow,
                                  btnColor: Colors.transparent,
                                  textFont: outfitRegular.copyWith(color: MyColor.yellow),
                                  isLoading: authController.isLoadingResend,
                                  callback: () {
                                    FocusScope.of(context).unfocus();
                                    authController
                                        .sendOtp(widget.email, isResend: true)
                                        .then((responseModel) {
                                      if (responseModel.isSuccess) {
                                        _startTimer();
                                      } else {
                                        MySnakeBar.showSnakeBar('Validation',
                                            responseModel.message!);
                                      }
                                    }).catchError((error) {
                                      authController.updateError();
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Visibility(
                    visible: _seconds > 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Resend in',
                          style: outfitRegular.copyWith(
                              fontSize: 18,
                              height: 1.4,
                              color: MyColor.yellow),
                        ),
                        Text(
                          ' ${_seconds.toString()} s',
                          style: outfitRegular.copyWith(
                              fontSize: 18,
                              height: 1.4,
                              color: MyColor.yellow),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.only(top: 40),
                    child: GetBuilder<AuthController>(builder: (authController) {
                      return PlainBtn(
                        text: TextUtil.continue_txt,
                        btnColor: MyColor.yellow,
                        textFont:
                            outfitRegular.copyWith(color: MyColor.bg),
                        isLoading: authController.isLoading,
                        callback: () {
                          FocusScope.of(context).unfocus();
                          authController
                              .sendOtp(widget.email, otp: controller.text)
                              .then((responseModel) {
                            if (responseModel.isSuccess) {
                              RtLScreenTransition(
                                remove: true,
                                screen: CreateNewPasswordScreen(
                                  email: widget.email,
                                  otp: controller.text,
                                ),
                              ).navigate(context);
                            } else {
                              MySnakeBar.showSnakeBar(
                                  'Validation', responseModel.message!);
                            }
                          }).catchError((error) {
                            authController.updateError();
                            debugPrint('verify otp error: $error');
                          });
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
