
import 'dart:developer';
import 'package:flutter/foundation.dart';

void printTest(String text){
  if(kDebugMode){
    print('\x1B[33m$text\x1B[0m');
  }
}

void showLog(String text){
  if(kDebugMode){
    log('\x1B[33m$text\x1B[0m');
  }
}