import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration inputDecoration;
  final TextStyle textStyle;
  final bool isHide;
  final TextInputType textInputType;

  const LoginTextField(
      {super.key,
      required this.controller,
      required this.inputDecoration,
      required this.textStyle,
      required this.isHide,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: inputDecoration,
      style: textStyle,
      obscureText: isHide,
      maxLines: 1,
    );
  }
}
