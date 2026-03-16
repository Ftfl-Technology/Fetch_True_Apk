import 'package:flutter/material.dart';

class Dimensions {
  late MediaQueryData mediaQuery;

  late double screenWidth;
  late double screenHeight;
  late double aspectRatio;
  late double devicePixelRatio;
  late EdgeInsets padding;
  late EdgeInsets viewInsets;
  late bool isLandscape;
  late double textScaleFactor;

  Dimensions(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    aspectRatio = mediaQuery.size.aspectRatio;
    devicePixelRatio = mediaQuery.devicePixelRatio;
    padding = mediaQuery.padding;
    viewInsets = mediaQuery.viewInsets;
    isLandscape = mediaQuery.orientation == Orientation.landscape;
    textScaleFactor = mediaQuery.textScaleFactor;
  }
}

extension SizeBox on num{
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
}