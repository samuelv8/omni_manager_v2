import 'package:flutter/material.dart';
import 'package:omni_manager/constants/style.dart';

class CustomTextTitle extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomTextTitle(
      {Key? key, this.text, this.size, this.color, this.weight})
      : super(key: key);
//  const CustomText(this.text, this.size, this.color, this.weight);

  @override
  Widget build(BuildContext context) {
    return Text(
      text??'',  // null safety
      style: TextStyle(
          fontSize: size ?? 25,
          color: color ?? darkYellow,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
