import 'package:flutter/material.dart';

import '../../../utils/my_color.dart';
import '../text/my_text.dart';

class MyButton extends StatelessWidget {
  final String text;
  final String icon;
  final TextStyle textFont;
  final Function() callback;

  const MyButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.textFont,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: MyColor.textFieldBg),
      child: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
                text: text, font: textFont),

            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(icon,fit: BoxFit.fill,),
            ),
          ],
        ),
      ),
    );
  }
}
