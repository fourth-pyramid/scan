import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qrscanner/core/router/router.dart';

void showSnackBar(
  String message, {
  bool upperSnackBar = false,
  bool popPage = false,
  int duration = 5,
  Color color = const Color.fromRGBO(31, 43, 70, 1),
}) {
  ScaffoldMessenger.of(MagicRouter.currentContext).hideCurrentSnackBar();
  ScaffoldMessenger.of(MagicRouter.currentContext).showSnackBar(
    SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: upperSnackBar ? const EdgeInsets.only(bottom: 20) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: Text(message, style: const TextStyle(color: Colors.white)),
      action: SnackBarAction(label: '', onPressed: () {}),
      duration: Duration(seconds: duration),
    ),
  );
  if (popPage) Timer(const Duration(seconds: 5), MagicRouter.pop);
}
