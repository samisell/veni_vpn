import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_layout.dart';
import '../../../utils/my_color.dart';
import '../../../utils/my_font.dart';
import '../code_picker_widget.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function? onChanged;
  final TextInputType keyboardType;
  final TextAlign? textAlign;
  final bool? password;
  final String? preFixIcon;
  final int? maxLines;
  final String? countryDialCode;
  final bool? isPhone;
  final Color? fillColor;
  final double? boxHight;
  final double? padding;
  final Function(CountryCode countryCode)? onCountryChanged;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.focusNode,
      this.onChanged,
      required this.keyboardType,
      this.textAlign,
      this.password,
      this.preFixIcon,
      this.maxLines,
      this.countryDialCode,
      this.onCountryChanged,
      this.isPhone, this.fillColor, this.boxHight, this.padding, this.inputFormatters});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passWord = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _passWord = widget.password ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.boxHight??50,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines ?? 1,
        textAlign: widget.textAlign == null ? TextAlign.start : TextAlign.center,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor??MyColor.textFieldBg,
          hintText: widget.hintText,
          hintStyle: outfitLight.copyWith(
              fontSize: 16, color: MyColor.yellow, height: 1.4),
          contentPadding: EdgeInsets.only(left: widget.padding??15, top: widget.padding??15, bottom: widget.padding??15),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: MyColor.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppLayout.getWidth(context, 10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: MyColor.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppLayout.getWidth(context, 10)),
          ),
          prefixIconConstraints: BoxConstraints(
            maxWidth: widget.preFixIcon != null
                ? 65
                : widget.isPhone != null
                ? 52
                : widget.padding??15,
            maxHeight: widget.isPhone != null ? 48 : 20,
          ),
          prefixIcon: widget.preFixIcon != null
              ? Container(
                  margin: const EdgeInsets.only(left: 15, right: 30),
                  child: SvgPicture.asset(
                    widget.preFixIcon!,
                    color: MyColor.yellow,
                    height: 20,
                  ))
              : widget.isPhone ?? false
                  ? Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppLayout.getWidth(context, 40)),
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: CodePickerWidget(
                              flagWidth: 30,
                              padding: EdgeInsets.zero,
                              onChanged: widget.onCountryChanged,
                              initialSelection: widget.countryDialCode,
                              favorite: [widget.countryDialCode!],
                              hideMainText: true,
                              dialogBackgroundColor: Theme.of(context).cardColor,
                              textStyle: outfitRegular.copyWith(
                                fontSize: 16,
                                color: MyColor.yellow,
                              ),
                            ),
                          ),
                        ),
                      Container(
                        height: 40,
                        width: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        color: const Color(0xFF9DA363),
                      )
                    ],
                  )
                  : const SizedBox(
                      width: 15,
                    ),
          suffixIcon: widget.password != null
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _passWord = !_passWord;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: _passWord
                        ? SvgPicture.asset(
                            'assets/images/ic_show.svg',
                            color: MyColor.yellow,
                            height: 18,
                          )
                        : SvgPicture.asset(
                            'assets/images/ic_un_show.svg',
                            color: MyColor.yellow,
                            height: 18,
                          ),
                  ),
                )
              : const SizedBox(),
        ),
        style: outfitLight.copyWith(
            fontSize: 16, color: MyColor.yellow, height: 1.4),
        obscureText: _passWord,
        cursorColor: MyColor.yellow,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged as void Function(String)?,
      ),
    );
  }
}
