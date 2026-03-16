import 'package:flutter/material.dart';

Widget CustomAmountText({
  required String amount,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  bool isLineThrough = false,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.currency_rupee,
        size: fontSize ?? 12,
        color: color ?? Colors.black,
      ),
      Text(
        amount,
        style: TextStyle(
          fontSize: fontSize ?? 12,
          color: color ?? Colors.black,
          fontWeight: fontWeight,
          decoration: isLineThrough ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
    ],
  );
}
