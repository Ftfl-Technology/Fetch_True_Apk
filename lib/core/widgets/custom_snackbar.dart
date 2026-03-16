import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../costants/custom_color.dart';
import '../costants/text_style.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message , style: textStyle12(context, color: CustomColor.whiteColor),),
      elevation: 0.0,
      // backgroundColor: CustomColor.whiteColor,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(20),
    ),
  );
}


void showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 12,
  );
}
