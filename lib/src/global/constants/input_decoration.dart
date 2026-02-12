
import 'package:flutter/material.dart';

import 'colors_resources.dart';

InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: ColorRes.listTileBackColor,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),

);

InputDecoration nonInputField = const InputDecoration(

  border: InputBorder.none,
  errorBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  disabledBorder: InputBorder.none,

);

InputDecoration searchDecoration = InputDecoration(

  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none
  ),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none
  ),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none
  ),

);

InputDecoration domainDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.white, width: 1)
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.white, width: 1)
  ),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.white, width: 1)
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.white, width: 1)
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.white, width: 1)
  ),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.white, width: 1)
  ),

);

InputDecoration borderDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.grey, width: 1)
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.grey, width: 1)
  ),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.grey, width: 1)
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.grey, width: 1)
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.grey, width: 1)
  ),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: ColorRes.grey, width: 1)
  ),

);

InputDecoration todayDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  ),
);

InputDecoration dateInputDecoration = InputDecoration(
  fillColor: ColorRes.white,
  filled: true,
  isDense: true,
  iconColor: ColorRes.grey,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  // labelStyle: const TextStyle(
  //   color: ColorRes.black,
  // ),
  // floatingLabelStyle: const TextStyle(color: ColorRes.blue),
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ColorRes.grey,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ColorRes.appRedColor,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ColorRes.appRedColor,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ColorRes.grey,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ColorRes.grey,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: ColorRes.grey,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  suffixIconColor: ColorRes.grey,
);





/// =============================

// Ocean-themed Input Decoration for Fish Farming App
InputDecoration oceanInputDecoration = InputDecoration(
  isDense: true,
  filled: true,
  fillColor: Colors.white.withOpacity(0.9),

  // Content Padding
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

  // Hint Style
  hintStyle: TextStyle(
    color: Color(0xFF2a5298).withOpacity(0.5),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),

  // Label Style
  labelStyle: const TextStyle(
    color: Color(0xFF1e3c72),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),

  // Floating Label Style
  floatingLabelStyle: const TextStyle(
    color: Color(0xFF2a5298),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),

  // Default Border (Enabled)
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Color(0xFF5fa0b8).withOpacity(0.5),
      width: 2,
    ),
  ),

  // Focused Border
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFF2a5298),
      width: 2.5,
    ),
  ),

  // Error Border
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFFF6B6B),
      width: 2,
    ),
  ),

  // Focused Error Border
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFFF6B6B),
      width: 2.5,
    ),
  ),

  // Disabled Border
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.3),
      width: 1.5,
    ),
  ),

  // Error Style
  errorStyle: const TextStyle(
    color: Color(0xFFFF6B6B),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),

  // Prefix Icon Theme
  prefixIconColor: Color(0xFF2a5298),

  // Suffix Icon Theme
  suffixIconColor: Color(0xFF2a5298),
);

// Alternative: Glassmorphism Style (More Modern)
InputDecoration glassInputDecoration = InputDecoration(
  isDense: true,
  filled: true,
  fillColor: Colors.white.withOpacity(0.15),

  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

  hintStyle: TextStyle(
    color: Colors.white.withOpacity(0.7),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),

  labelStyle: const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),

  floatingLabelStyle: const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Colors.white.withOpacity(0.3),
      width: 1.5,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.white,
      width: 2,
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFFFD93D),
      width: 1.5,
    ),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFFFD93D),
      width: 2,
    ),
  ),

  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Colors.white.withOpacity(0.2),
      width: 1,
    ),
  ),

  errorStyle: const TextStyle(
    color: Color(0xFFFFD93D),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),

  prefixIconColor: Colors.white,
  suffixIconColor: Colors.white,
);

// Bubble Style (Playful Ocean Theme)
InputDecoration bubbleInputDecoration = InputDecoration(
  isDense: true,
  filled: true,
  fillColor: Color(0xFFE8F4F8),

  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

  hintStyle: TextStyle(
    color: Color(0xFF2a5298).withOpacity(0.6),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),

  labelStyle: const TextStyle(
    color: Color(0xFF1e3c72),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),

  floatingLabelStyle: const TextStyle(
    color: Color(0xFF2a5298),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: Color(0xFF5fa0b8).withOpacity(0.3),
      width: 2,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color(0xFF2a5298),
      width: 2.5,
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color(0xFFFF6B6B),
      width: 2,
    ),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color(0xFFFF6B6B),
      width: 2.5,
    ),
  ),

  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.3),
      width: 1.5,
    ),
  ),

  errorStyle: const TextStyle(
    color: Color(0xFFFF6B6B),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),

  prefixIconColor: Color(0xFF2a5298),
  suffixIconColor: Color(0xFF2a5298),
);

// Usage Example:
// GlobalTextFormField(
//   controller: emailCon,
//   titleText: 'User Email / Unique ID / Phone',
//   hintText: 'Enter Your Email / Unique ID / Phone',
//   decoration: oceanInputDecoration, // or glassInputDecoration or bubbleInputDecoration
//   keyboardType: TextInputType.emailAddress,
// )