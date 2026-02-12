import 'package:flutter/material.dart';

SizedBox sizedBoxH(double? h){
  return SizedBox(height: h);
}

SizedBox sizedBoxW(double? w){
  return SizedBox(width: w);
}

Size size(BuildContext context){
  return MediaQuery.sizeOf(context);
}
