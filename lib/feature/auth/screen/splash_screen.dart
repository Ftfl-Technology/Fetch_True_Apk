import 'dart:async';
import 'package:fetchtrue/feature/auth/sharedPref/intro_sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(const Duration(seconds: 1), () {
  //     context.go('/introScreen');
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _checkIntro();
  }

  Future<void> _checkIntro() async {
    await Future.delayed(const Duration(seconds: 1));

    final isSeen = await IntroSharedpref.isIntroSeen();

    if (!mounted) return;

    if (isSeen) {
      context.go('/dashboard');
    } else {
      context.go('/introScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Image.asset(CustomLogo.fetchTrueLogo, height: 150,),
          ],
        ),
      ),
    );
  }
}