import 'package:flutter/material.dart';

void showSnackBar(
    {required String text,
    required BuildContext context,
    Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: backgroundColor,
  ));
}

void hideSnackBar({required BuildContext context}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
