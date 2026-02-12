
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

class GlobalImageText extends StatelessWidget {
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

  const GlobalImageText({
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
  });

  @override
  Widget build(BuildContext context) {
    final h = height ?? .08;
    final fw = fontSize ?? 14;
    final double fontHeight = h * fw;

    return FutureBuilder<ui.Image>(
      future: _loadUiImage(Images.textUre), // Replace with your image path
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Display a placeholder or empty container until the image loads
          return const SizedBox();
        }

        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return ImageShader(
              snapshot.data!,
              TileMode.repeated,
              TileMode.repeated,
              Matrix4.identity().storage,
            );
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            str,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
            softWrap: softWrap,
            style: GoogleFonts.roboto(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              decoration: decoration,
              height: height == null ? null : fontHeight,
              fontStyle: fontStyle,
            ),
          ),
        );
      },
    );
  }

  Future<ui.Image> _loadUiImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

class ExpandableDescription extends StatefulWidget {
  final String description;
  final int maxLines;
  const ExpandableDescription({
    super.key,
    required this.description,
    this.maxLines = 3,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          str: widget.description,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          fontSize: 11,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;  // Toggle between expanded and collapsed
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GlobalText(
                str: isExpanded ? "See less" : "See more",
                color: ColorRes.appRedColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

