import 'package:flutter/material.dart';

class ColorConstants {
  static const Color splashScreenColor = Color(0xff2C2128);
  static Color backgroundColor(double db) {
    if (db >= 0.0 && db < 70) {
      return const Color(0xffb1dd9e);
    } else if (db >= 70 && db < 85) {
      return const Color(0xfffcdc5c);
    } else {
      return const Color(0xffef7564);
    }
  }
}
