import 'package:flutter/widgets.dart';

abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double desktop = 1280;
  static const double contentMaxWidth = 1200;
  static const double formMaxWidth = 420;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  static EdgeInsets contentPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= desktop) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    if (width >= mobile) {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  static double readableMaxWidth(
    BuildContext context, {
    double maxWidth = contentMaxWidth,
  }) {
    final padding = contentPadding(context).horizontal;
    final availableWidth = MediaQuery.sizeOf(context).width - padding;
    return availableWidth.clamp(0, maxWidth).toDouble();
  }
}
