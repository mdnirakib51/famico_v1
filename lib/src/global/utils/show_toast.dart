import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/colors_resources.dart';
import '../global_widget/global_text.dart';

// Print test message in debug mode
void printTest(String text) {
  if (kDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

// Show log message in debug mode
void showLog(String text) {
  if (kDebugMode) {
    log('\x1B[33m$text\x1B[0m');
  }
}

// Show custom SnackBar (GetX থেকে Flutter standard-এ convert করা হয়েছে)
void showCustomSnackBar(
    BuildContext context,
    String message, {
      IconData? icon,
      bool isError = true,
      bool isPosition = false,
      double? duration,
    }) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isError ? Icons.error : Icons.check_circle,
          size: 18,
          color: ColorRes.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlobalText(
            str: message,
            color: ColorRes.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    backgroundColor: isError ? ColorRes.red : ColorRes.green,
    duration: duration != null
        ? Duration(seconds: duration.toInt())
        : const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

// Show loading overlay
void showLoadingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (context) => const OverlayLoadingIndicator(),
  );
}

// Hide loading overlay
void hideLoadingOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

// Loading Indicator Widget
class OverlayLoadingIndicator extends StatelessWidget {
  const OverlayLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 125,
          width: 120,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ColorRes.appBackColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularProgressIndicator(
                color: ColorRes.appRedColor,
              ),
              GlobalText(
                str: 'Loading..',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ),
      ),
    );
  }
}
