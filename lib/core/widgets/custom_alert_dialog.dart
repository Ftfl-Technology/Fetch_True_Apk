import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../costants/custom_color.dart';
import '../costants/text_style.dart';

void CustomAlertDialog(BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: textStyle16(context, color: CustomColor.redColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: textStyle14(context, color: CustomColor.descriptionColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text('', style: textStyle14(context, color: Colors.red)),
                    ),
                  ),

                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: Text('Back', style: textStyle16(context, color: CustomColor.appColor))),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
