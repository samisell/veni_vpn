import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_layout.dart';
import '../../utils/my_color.dart';
import '../../utils/my_font.dart';
import '../../utils/my_image.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final Color? bgColor;
  final Color? leadingIconColor;
  final String? type;
  final TextStyle? textstyle;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.bgColor,
      this.type,
      this.textstyle,
      this.leadingIconColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: textstyle ??
              outfitMedium.copyWith(fontSize: 20, color: MyColor.yellow)),
      centerTitle: true,
      leading: isBackButtonExist
          ? IconButton(
              icon: SvgPicture.asset(
                MyImage.backArrow,
              ),
              color: leadingIconColor ??
                  Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  AppLayout.screenPortrait();
                  Navigator.pop(context);
                }
              },
            )
          : const SizedBox(),
      backgroundColor: bgColor ?? MyColor.settingsHeader,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size(1170, 50);
}
