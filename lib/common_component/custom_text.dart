import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.text = '',
    this.fontSize = 20,
    this.color = const Color(0xFF162C47),
    this.alignment,
    this.fontWeight,
    this.verticalMargin = 0,
    this.horizontalMargin = 0,
    this.textAlign,
    this.decoration,
    this.fontFamily,
    this.maxLines,
  });

  final String text;
  final double fontSize;
  final String? fontFamily;
  final Color color;
  final Alignment? alignment;
  final FontWeight? fontWeight;
  final double verticalMargin;
  final double horizontalMargin;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      alignment: alignment,
      child: Text(
        text,
        maxLines: maxLines,
        style: TextStyle(
          decoration: decoration,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
