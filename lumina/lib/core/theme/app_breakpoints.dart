import 'package:flutter/material.dart';

class AppBreakpoints {
  static const mobile = 600.0;
  static const tablet = 1024.0;
  static const desktop = 1440.0;

  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 360;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;

  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    if (isSmallMobile(context)) return 12.0;
    return 16.0;
  }

  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200.0;
    return double.infinity;
  }
}
