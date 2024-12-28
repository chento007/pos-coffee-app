import 'package:flutter/material.dart';

class ScreenTypeDevice {
  // Small devices, typically phones
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Medium devices, typically tablets
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  // Large devices, typically desktops or large tablets
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  // Extra small devices (optional, e.g., very small phones or older devices)
  static bool isExtraSmall(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  // Custom range for specific needs
  static bool isCustomRange(BuildContext context, double minWidth, double maxWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= minWidth && screenWidth < maxWidth;
  }
}
