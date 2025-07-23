import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../../../utils/my_image.dart';
import '../../../utils/text_util.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/text/my_text.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //AppLayout.screenPortrait(colors: MyColor.settingsHeader);
    return Scaffold(
      appBar: CustomAppBar(title: '',onBackPressed: (){
        Navigator.pop(context);
      },),
      backgroundColor: MyColor.settingsBody,
      body: Column(
        children: [
          Container(
            color: MyColor.settingsHeader,
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(text: TextUtil.devices, font: outfitMedium.copyWith(color: MyColor.yellow,fontSize: 24)),

                SvgPicture.asset(MyImage.deviceIcon,width: 65),

              ],
            ),
          ),

          Expanded(
              child: Container(
                color: MyColor.settingsBody,
                child: Column(
                  children: [

                  ],
                ),
              )
          ),

        ],
      ),
    );
  }
}
