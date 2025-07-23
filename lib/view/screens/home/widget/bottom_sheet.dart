import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../utils/app_layout.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/my_font.dart';
import '../../../../utils/my_helper.dart';
import '../../../../utils/my_image.dart';
import '../../../widgets/my_snake_bar.dart';

class ServerBottomSheet extends StatelessWidget {
  final Function onSelected;

  const ServerBottomSheet({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    if (homeController.serversList.isEmpty) {
      homeController.getServers();
    }
    return Container(
      width: AppLayout.getScreenWidth(context),
      height: context.height * 0.7,
      margin: const EdgeInsets.only(top: 30),
      child: BackdropFilter(
        blendMode: BlendMode.srcOver,
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFEFFD3).withOpacity(.17),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(33),
              topRight: Radius.circular(33),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 0,
                    ),
                    Text(
                      'Choose Server',
                      style: outfitBold.copyWith(
                          fontSize: 20, color: MyColor.yellow),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: MyColor.yellow,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Expanded(
                  child: homeController.serversList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: homeController.serversList.length,
                          itemBuilder: (context, index) {
                            final server = homeController.serversList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  if (index == 0)
                                    const Divider(
                                      color: MyColor.yellow,
                                      thickness: 1,
                                    ),
                                  InkWell(
                                    onTap: () {
                                      if(server.accessType == "premium" && homeController.isSubscribed.value){
                                        Navigator.pop(context);
                                        onSelected(server);
                                      }else if(server.accessType == "free"){
                                        Navigator.pop(context);
                                        onSelected(server);
                                      }else{
                                        MySnakeBar.showSnakeBar("Need Subscribe!", "Subscribe & use Premium server!");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            child: Image.network(
                                              "${MyHelper.baseUrl}${server.country?.icon}",
                                              height: 25,
                                              width: 36,
                                              fit: BoxFit.fill,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const SizedBox(
                                                  height: 25,
                                                  width: 36,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              server.vpnCountry ?? '',
                                              style: outfitRegular.copyWith(
                                                  fontSize: 14,
                                                  color: MyColor.yellow),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Visibility(
                                            visible: server.accessType == "premium",
                                            child: Image.asset(
                                              MyImage.proIcon,
                                              color: MyColor.yellow,
                                              height: 26,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: MyColor.yellow,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: MyColor.yellow,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
