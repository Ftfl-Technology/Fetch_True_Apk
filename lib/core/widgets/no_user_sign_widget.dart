import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/auth/screen/auth_screen.dart';
import 'package:fetchtrue/feature/auth/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';

class NoUserSignWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const NoUserSignWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 50,
            color: CustomColor.greyColor,
          ),
          10.height,
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(),)),
            child: Text(
              "Go To Log In",
              style: textStyle16(context, color: CustomColor.appColor).copyWith(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
