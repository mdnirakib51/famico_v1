
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/colors_resources.dart' show ColorRes;
import '../constants/images.dart';

enum ImageFor {asset, network, local}

class GlobalImageLoader extends StatelessWidget {
  const GlobalImageLoader({
    super.key,
    required this.imagePath,
    this.imageFor = ImageFor.asset,
    this.height,
    this.width,
    this.fit,
    this.color,
    this.errorBuilder,
    this.errorImg,
    this.errorColor,
    this.errorHeight,
    this.errorWidth,
  });
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageFor imageFor;
  final String? errorImg;
  final Color? errorColor;
  final double? errorHeight;
  final double? errorWidth;

  @override
  Widget build(BuildContext context) {
    if (imageFor == ImageFor.network) {
      log("Image Path: $imagePath");
      return Image.network(
          imagePath,
        height: height,
        width: width,
        fit: fit,
        color: color,
        errorBuilder: errorBuilder ?? (context, exception, stackTrace) => Center(
            child: Container(
              height: height,
              width: width,
              color: ColorRes.grey.withAlpha(130),
              child: Center(
                child: Image.asset(errorImg ?? Images.appLogoShadow,
                  height: errorHeight,
                  width: errorWidth,
                  fit: BoxFit.fill,
                  color: errorColor,
                ),
              ),
            )
          )
      );
    } else if (imageFor == ImageFor.local) {
      // log("Image Path2: $imagePath");
      return Image.file(
        File(imagePath),
        height: height,
        width: width,
        fit: fit,
        color: color,
        errorBuilder: errorBuilder ?? (context, exception, stackTrace) => Center(
            child: Container(
              height: height,
              width: width,
              color: ColorRes.black,
              child: Center(
                child: Image.asset(errorImg ?? Images.appLogoShadow,
                  height: errorHeight,
                  width: errorWidth,
                  fit: BoxFit.fill,
                  color: errorColor,
                ),
              ),
            )
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        color: color,
        errorBuilder: errorBuilder ?? (context, exception, stackTrace) => Center(
            child: Container(
              height: height,
              width: width,
              color: ColorRes.black,
              child: Center(
                child: Image.asset(errorImg ?? Images.appLogoShadow,
                  height: errorHeight,
                  width: errorWidth,
                  fit: BoxFit.fill,
                  color: errorColor,
                ),
              ),
            )
        ),
      );
    }
  }
}
