
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  const AppText({
    super.key,
    required this.title,
    this.color,
    this.textAlign,
    this.textOverflow,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        color: color??Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: textOverflow,
      ),
    );
  }
}

