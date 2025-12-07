import 'package:flutter/material.dart';
import 'package:qrscanner/constant.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? Function(String?)? validator;
  final VoidCallback? onPressed;
  final bool secure;
  final bool isNumber;
  final Function(String?)? onSave;
  final int maxLines;

  // final IconData? icon;
  final Widget? suffixIcon;
  final Widget? prefix, prefixIcon;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool isNext;
  final bool isReadOnly;
  final int? maxLength;
  final String? upperText;
  final String? lableText;
  final String? errorText;
  final bool hasLabel;
  final Color? hintColor;
  final TextEditingController? controller;
  final bool isRTL;
  final double horizontalMargin;
  final double verticalMargin;
  final bool multiLine;
  final Color? fillColor;
  final Color? textColor;
  final Color? labelColor;
  final double radius;
  final String? initialValue;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final String? initialText;

  const CustomTextField({
    super.key,
    this.prefix,
    this.isNumber = false,
    this.maxLines = 1,
    this.onPressed,
    this.onSave,
    this.secure = false,
    this.hint,
    this.validator,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.onTap,
    this.isNext = true,
    this.maxLength,
    this.upperText,
    this.hasLabel = false,
    this.isRTL = false,
    this.hintColor = Colors.grey,
    this.horizontalMargin = 0,
    this.multiLine = false,
    this.fillColor = Colors.white,
    this.textColor,
    this.labelColor,
    this.radius = 12,
    this.verticalMargin = 5,
    this.lableText,
    this.initialValue,
    this.prefixIcon,
    this.keyboardType = TextInputType.emailAddress,
    this.focusNode,
    this.errorText,
    this.isReadOnly = false,
    this.initialText,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final BorderRadius borderRadius = BorderRadius.circular(25);
  late bool _showPassword;

  @override
  void initState() {
    _showPassword = widget.secure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.verticalMargin,
        horizontal: widget.horizontalMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.upperText != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                widget.upperText!,
                style: TextStyle(color: colorPrimary, fontSize: 18),
              ),
            ),
          GestureDetector(
            onTap: () {
              if (widget.initialText?.startsWith('http') ?? false) {
                // Utils.customLaunch(widget.initialText!);
              } else {
                widget.onTap!();
              }
            },
            child: TextFormField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              readOnly: widget.isReadOnly,
              initialValue: widget.initialValue,
              obscureText: _showPassword,
              onSaved: widget.onSave,
              onChanged: widget.onChanged,
              textDirection: widget.isRTL == true ? TextDirection.ltr : null,
              maxLength: widget.maxLength,
              textInputAction: widget.multiLine
                  ? TextInputAction.newline
                  : widget.isNext
                  ? TextInputAction.next
                  : TextInputAction.done,
              keyboardType: widget.multiLine
                  ? TextInputType.multiline
                  : widget.isNumber
                  ? TextInputType.number
                  : widget.keyboardType,
              cursorColor: colorPrimary,
              validator: widget.validator,
              onTap: () {
                if (widget.isReadOnly) {
                  if (widget.initialText?.startsWith('http') ?? false) {
                    // Utils.customLaunch(widget.initialText!);
                  } else {
                    widget.onTap;
                  }
                }
              },
              maxLines: widget.maxLines,
              enabled: widget.onTap == null,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) => null,
              style: TextStyle(color: widget.textColor),
              decoration: InputDecoration(
                filled: true,
                errorText: widget.errorText,
                hintStyle: TextStyle(color: widget.hintColor, fontSize: 14),
                labelStyle: TextStyle(color: widget.labelColor),
                fillColor:
                    widget.fillColor ?? const Color.fromRGBO(238, 243, 245, 1),
                counterStyle: const TextStyle(
                  fontSize: 0,
                  color: Colors.transparent,
                ),
                prefix: widget.prefix,
                prefixIcon: widget.prefixIcon,
                suffixIcon:
                    widget.suffixIcon ??
                    (widget.secure
                        ? IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                              size: 18,
                            ),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          )
                        : widget.suffixIcon),
                hintText: widget.hint,
                labelText: widget.lableText,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: widget.maxLines == 1 ? 10 : 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  borderSide: BorderSide(
                    color: widget.isReadOnly
                        ? const Color(0xFF19B305)
                        : colorLightGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
