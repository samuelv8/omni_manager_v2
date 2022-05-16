import 'package:flutter/material.dart';

void showSnackBar(
    {required String text,
    required BuildContext context,
    required bool isError}) {
  if (isError) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text)
    ));
  }
}
