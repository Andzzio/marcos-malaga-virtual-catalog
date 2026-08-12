import 'package:flutter/material.dart';

class ResponsiveTheme {
  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static bool isMobile(BuildContext context) => getWidth(context) < 750;
  static bool isTablet(BuildContext context) =>
      getWidth(context) >= 750 && getWidth(context) < 1100;
  static bool isDesktopWithLimitedSpace(BuildContext context) =>
      getWidth(context) < 1400 && getWidth(context) >= 1100;
}
