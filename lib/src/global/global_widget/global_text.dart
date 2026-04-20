
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../constants/colors_resources.dart';
import '../constants/images.dart';

class GlobalText extends StatelessWidget {
  final String str;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;
  final double? height;
  final String? fontFamily;
  final bool isUpperCase;


  const GlobalText({
    super.key,
    required this.str,
    this.fontWeight,
    this.fontSize,
    this.fontStyle,
    this.color,
    this.letterSpacing,
    this.decoration,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.height,
    this.fontFamily,
    this.isUpperCase = false,
  });

  @override
  Widget build(BuildContext context) {
    final h = height ?? .08;
    final fw = fontSize ?? 14;
    final double fontHeight = h * fw;
    return Text(
      isUpperCase ? str.toUpperCase() : str,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
      style: GoogleFonts.roboto(
        color: color ?? ColorRes.black,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        decoration: decoration,
        height: height == null ? null : fontHeight,
        fontStyle: fontStyle,
        // fontFamily: fontFamily ?? AppConstantKey.fontFamily.key,
      ),
    );
  }
}
