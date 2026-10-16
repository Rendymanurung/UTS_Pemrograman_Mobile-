import 'package:flutter/material.dart';

class ResponsiveUtil {

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;


  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1200;


  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;


  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }


  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }
}