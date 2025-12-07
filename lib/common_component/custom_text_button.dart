import 'package:flutter/material.dart';
import 'package:qrscanner/constant.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.text = '',
    this.color,
    this.onPressed,
    this.alignment,
    this.fontWeight,
    this.textDecoration,
  });
  final String text;
  final Color? color;
  final VoidCallback? onPressed;
  final Alignment? alignment;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: colorPrimary,
            fontSize: 14,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
