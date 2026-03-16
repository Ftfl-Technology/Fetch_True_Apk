import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../costants/custom_color.dart';
import '../costants/dimension.dart';

class CustomContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String? assetsImg;
  final String? networkImg;
  final Gradient? gradient;
  final bool border;
  final Color? borderColor;
  final bool borderRadius;
  final Widget? child;

  const CustomContainer({super.key,
    this.onTap,
    this.color,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.assetsImg,
    this.networkImg,
    this.gradient,
    this.border = false,
    this.child,
    this.borderColor,
    this.borderRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return GestureDetector(
      onTap: onTap??null,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height,
        width: width,
        margin: margin ?? EdgeInsets.all(10),
        padding: padding ?? EdgeInsets.all(10),
        decoration: BoxDecoration(
         color:  (gradient == null)  ? color ?? Theme.of(context).shadowColor.withOpacity(0.05):null,
          borderRadius: borderRadius ? BorderRadius.circular(dimensions.screenHeight*0.01) :null,
          border: border ? Border.all(color: borderColor ?? CustomColor.strokeColor, width: 0.2):null,
          gradient: gradient,
          image: (networkImg != null)
              ? DecorationImage(image: NetworkImage(networkImg!), fit: BoxFit.fill)
              : (assetsImg != null)
              ? DecorationImage(image: AssetImage(assetsImg!), fit: BoxFit.fill)
              : null,
        ),
        child: child,
      ),
    );
  }
}