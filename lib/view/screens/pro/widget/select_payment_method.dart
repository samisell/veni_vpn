import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/payment_method_item.dart';
import '../../../../utils/app_layout.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/my_font.dart';

class SelectPayMethod extends StatelessWidget {
  final Function onSelected;

  const SelectPayMethod({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 0,
                    ),
                    Text(
                      'Choose Payment Method',
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
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: myList.length,
                  itemBuilder: (context, index) {
                    final items = myList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          if (index == 0)
                            const Divider(
                              color: MyColor.yellow,
                              thickness: 1,
                            ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              onSelected(items);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(3),
                                    child: items.iconUrl.isNotEmpty
                                        ? Image.network(
                                            items.iconUrl,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return _buildFallbackIcon(items);
                                            },
                                          )
                                        : _buildFallbackIcon(items),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items.name,
                                          style: outfitRegular.copyWith(
                                              fontSize: 14,
                                              color: MyColor.yellow),
                                        ),
                                        if (items.type == 'flutterwave')
                                          Text(
                                            'Pay with Card, Bank Transfer, USSD',
                                            style: outfitLight.copyWith(
                                                fontSize: 12,
                                                color: MyColor.yellow.withOpacity(0.7)),
                                          ),
                                        if (items.type == 'in_app')
                                          Text(
                                            'Apple Pay / Google Pay',
                                            style: outfitLight.copyWith(
                                                fontSize: 12,
                                                color: MyColor.yellow.withOpacity(0.7)),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Payment method indicator
                                  if (items.type == 'flutterwave')
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: MyColor.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'NGN',
                                        style: outfitMedium.copyWith(
                                          fontSize: 10,
                                          color: MyColor.green,
                                        ),
                                      ),
                                    ),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(PaymentMethodItem items) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: MyColor.yellow.withOpacity(.2),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: items.type == 'flutterwave'
            ? const Icon(
                Icons.payment,
                color: MyColor.yellow,
                size: 20,
              )
            : Text(
                items.name.substring(0, 2),
                style: outfitSemiBold.copyWith(
                    fontSize: 20,
                    color: MyColor.yellow),
              ),
      ),
    );
  }
}
