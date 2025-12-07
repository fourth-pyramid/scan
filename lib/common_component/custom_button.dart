import 'package:flutter/material.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text = '',
    this.fontSize = 16,
    this.onPress,
    this.widthButton,
    this.heightButton,
    this.isBold = true,
    this.isIcon = false,
    this.icon,
    this.bgColor,
    this.borderColor,
    this.fontColor,
  });

  final String text;
  final double fontSize;
  final bool isBold;
  final VoidCallback? onPress;
  final double? widthButton;
  final double? heightButton;
  final bool isIcon;
  final Widget? icon;
  final Color? bgColor;
  final Color? borderColor;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    // Check if we have anything to show
    final hasContent = (isIcon && icon != null) || text.isNotEmpty;

    return InkWell(
      onTap: onPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: widthButton,
        height: heightButton ?? MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: bgColor ?? colorPrimary,
          gradient: bgColor != null
              ? null
              : const LinearGradient(
                  colors: [
                    Color.fromRGBO(31, 43, 70, 1),
                    Color.fromRGBO(134, 159, 216, 1),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor ?? Colors.white),
        ),
        child: hasContent
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isIcon && icon != null) icon!,
                  if (isIcon && icon != null)
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  if (text.isNotEmpty)
                    CustomText(
                      text: text,
                      fontSize: fontSize,
                      color: fontColor ?? Colors.white,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'Tajwal',
                      alignment: Alignment.center,
                    ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
