
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget desktop;
  final Widget? desktopLarge;

  const Responsive({
    Key? key,
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    required this.desktop,
    this.desktopLarge,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 500;

  static bool isMobileLarge(BuildContext context) =>
      MediaQuery.of(context).size.width > 500 && MediaQuery.of(context).size.width <= 800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 800 && MediaQuery.of(context).size.width <= 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1024 && MediaQuery.of(context).size.width < 1450;

  static bool isDesktopLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1450;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    if (isDesktopLarge(context) && desktopLarge != null) {
      return desktopLarge!;
    } else if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet!;
    } else if (isMobileLarge(context) && mobileLarge != null) {
      return mobileLarge!;
    } else {
      return mobile;
    }
  }

  
}