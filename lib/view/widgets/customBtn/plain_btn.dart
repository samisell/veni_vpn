import 'package:flutter/material.dart';

class PlainBtn extends StatelessWidget {
  final String text;
  final Color btnColor;
  final Color? loadingColor;
  final TextStyle textFont;
  final Function() callback;
  final bool? isLoading;
  final double? paddingVer;

  const PlainBtn(
      {super.key,
      required this.text,
      required this.btnColor,
      required this.textFont,
      required this.callback,
      this.isLoading, this.paddingVer, this.loadingColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          isLoading != null && isLoading! ? null : callback as void Function()?,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: btnColor),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVer??12),
          child: isLoading != null && isLoading!
              ? Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: loadingColor??Colors.black,strokeWidth: 2,)
                      ]),
                )
              : Text(
                  text,
                  style: textFont,
                ),
        ),
      ),
    );
  }
}
