import 'package:flutter/material.dart';

double _responsiveFontSize(BuildContext context, double baseSize) {
  final width = MediaQuery.of(context).size.width;

  // Example: 375px (iPhone 11 width) ko base maan ke scaling
  return baseSize * (width / 375).clamp(0.85, 1.1);
}

TextStyle appTextStyle(
    BuildContext context, {
      required double size,
      Color? color,
      FontWeight? fontWeight,
    }) {
  return TextStyle(
    color: color ?? Colors.black87,
    fontSize: _responsiveFontSize(context, size),
    fontWeight: fontWeight ?? FontWeight.w500,
  );
}

// Usage:
TextStyle textStyle12(BuildContext context, {Color? color, FontWeight? fontWeight}) =>
    appTextStyle(context, size: 12, color: color, fontWeight: fontWeight);

TextStyle textStyle14(BuildContext context, {Color? color, FontWeight? fontWeight}) =>
    appTextStyle(context, size: 14, color: color, fontWeight: fontWeight);

TextStyle textStyle16(BuildContext context, {Color? color, FontWeight? fontWeight}) =>
    appTextStyle(context, size: 16, color: color, fontWeight: fontWeight);

TextStyle textStyle18(BuildContext context, {Color? color, FontWeight? fontWeight}) =>
    appTextStyle(context, size: 18, color: color, fontWeight: fontWeight);

TextStyle textStyle20(BuildContext context, {Color? color, FontWeight? fontWeight}) =>
    appTextStyle(context, size: 20, color: color, fontWeight: fontWeight);

TextStyle textStyle22(BuildContext context, {Color? color, FontWeight? fontWeight}) =>
    appTextStyle(context, size: 22, color: color, fontWeight: fontWeight);
