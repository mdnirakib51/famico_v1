
import 'package:flutter/material.dart';
import '../constants/colors_resources.dart';
import 'global_text.dart';

class CoupleTextButton extends StatelessWidget {
  final String firstText;
  final String secondText;

  const CoupleTextButton({
    super.key,
    required this.firstText,
    required this.secondText
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: const TextStyle(
              color: ColorRes.deep400,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              // decoration: TextDecoration.lineThrough,
            ),
          ),
          const TextSpan(
            text: ' ',
            style: TextStyle(
              // color: KColor.deep2.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: secondText,
            style: const TextStyle(
              color: ColorRes.red,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class GlobalCoupleTextButton extends StatelessWidget {
  final String firstText;
  final String secondText;
  const GlobalCoupleTextButton({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          str: firstText,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),

        Flexible(
          child: GlobalText(
            str: secondText,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class GlobalCoupleTextExpendedButton extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color? containerColor;
  const GlobalCoupleTextExpendedButton({
    super.key,
    required this.firstText,
    required this.secondText,
    this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor ?? ColorRes.appBackColor,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GlobalText(
              str: firstText,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          Expanded(
            child: GlobalText(
              str: secondText,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}


class GlobalCoupleEndTextButton extends StatelessWidget {
  final String firstText;
  final String secondText;
  final MainAxisAlignment? mainAxisAlignment;
  const GlobalCoupleEndTextButton({
    super.key,
    required this.firstText,
    required this.secondText,
    this.mainAxisAlignment = MainAxisAlignment.end
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
      children: [
        GlobalText(
          str: firstText,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),

        Flexible(
          child: GlobalText(
            str: secondText,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
