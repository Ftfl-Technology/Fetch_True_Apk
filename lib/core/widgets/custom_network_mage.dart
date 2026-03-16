import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isLoader;
  final Widget? child;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.onTap,
    this.isLoader = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
          margin: margin ?? EdgeInsets.zero,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap?? null,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: fit,
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                fadeInDuration: Duration.zero,
                fadeOutDuration:Duration.zero,
                memCacheHeight: 400,
                memCacheWidth: 400,
                placeholderFadeInDuration: Duration.zero,
                placeholder: (context, url) => Container(
                  width: width ?? double.infinity,
                  height: height,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: isLoader ? CircularProgressIndicator(strokeWidth: 2):null,
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.image, color: Colors.grey, size: 40,),
              ),
            ),
          ),
        ),

        if (child != null) Positioned.fill(child: child!),
      ],
    );
  }
}
