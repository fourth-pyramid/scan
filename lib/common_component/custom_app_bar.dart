import 'package:flutter/material.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/constant.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.text, this.showBackButton = true});

  final String? text;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// زر الرجوع على الشمال
          if (showBackButton)
            const Positioned(left: 0, child: BackButton(color: Colors.white)),

          /// العنوان في النص 100%
          CustomText(
            text: text ?? '',
            alignment: Alignment.center,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: colorSecondary,
          ),
        ],
      ),
    );
  }
}
