import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = false;

  void toggleScreen(bool value) {
    setState(() {
      isSignUp = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(
        title: 'Welcome To',
        showBackButton: true,
        bColor: CustomColor.whiteColor,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: isSignUp
            ? SignUpScreen(
          key: const ValueKey("signup"),
          onToggle: toggleScreen,
        )
            : SignInScreen(
          key: const ValueKey("signin"),
          onToggle: toggleScreen,
        ),
      ),

    );
  }
}
