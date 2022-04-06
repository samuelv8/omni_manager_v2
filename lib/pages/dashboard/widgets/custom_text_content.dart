import 'package:flutter/material.dart';
import 'package:omni_manager/constants/style.dart';

class CustomTextContent extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomTextContent(
      {Key? key, this.text, this.size, this.color, this.weight})
      : super(key: key);
//  const CustomText(this.text, this.size, this.color, this.weight);

  @override
  Widget build(BuildContext context) {
    return Text(
      text??'',  // null safety
      style: TextStyle(
          fontSize: size ?? 12,
          color: color ?? lightYellow,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
