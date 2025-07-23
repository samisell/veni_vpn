import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextStyle font;

  MyText(
      {super.key,
      required this.text,
      required this.font});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: font,
    );
  }
}
