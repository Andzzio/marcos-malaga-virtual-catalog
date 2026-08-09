import 'package:flutter/material.dart';

class ResponsiveTheme {
  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static bool isMobile(BuildContext context) => getWidth(context) < 600;
  static bool isTablet(BuildContext context) =>
      getWidth(context) >= 600 && getWidth(context) < 1400;
}
