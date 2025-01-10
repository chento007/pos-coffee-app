import 'package:coffee_app/core/utils/screen_type_device.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonOrderProduct extends StatelessWidget {
  // Callback when the button is clicked
  final VoidCallback onPressed;

  // Color properties for the button's gradient
  final Color buttonColor;

  // Title for the button
  final String title;

  // Icon for the button
  final Icon icon;

  const ButtonOrderProduct({
    super.key,
    required this.onPressed,
    this.buttonColor = const Color(0xFFF5BC65), // Default gradient colors
    this.title = "Order Product", // Default title
    this.icon = const Icon(Icons.shopping_cart,
        color: Colors.white, size: 24), // Default icon
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ScreenTypeDevice.isPhone(context);
    final isTablet = ScreenTypeDevice.isTablet(context);
    final isDesktop = ScreenTypeDevice.isDesktop(context);

    // Adjust properties based on the device type
    final double padding = isPhone
        ? 8.0
        : isTablet
            ? 8.0
            : isDesktop
                ? 8.0
                : 6.0; 

    final double fontSize = isPhone
        ? 12.0
        : isTablet
            ? 14.0
            : isDesktop
                ? 16.0
                : 10.0; // Smaller font size for extra small

    final double iconSize = isPhone
        ? 18.0
        : isTablet
            ? 20.0
            : isDesktop
                ? 20.0
                : 16.0; // Smaller icon size for extra small

    final double borderRadius = isPhone
        ? 8.0
        : isTablet
            ? 10.0
            : isDesktop
                ? 12.0
                : 6.0; // Smaller border radius for extra small

    return InkWell(
      onTap: onPressed,
      splashColor: Colors.white.withOpacity(0.3), // Splash effect when clicked
      highlightColor: Colors.orange.withOpacity(0.1), // Highlight effect
      child: Container(
        padding: EdgeInsets.all(10), // Adjusted padding
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Subtle shadow for depth
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon.icon,
                color: Colors.white,
                size: iconSize, // Adjusted icon size
              ),
              SizedBox(width: 10), // Adjusted space between icon and text
              Text(
                title, // Custom title
                style: TextStyle(
                  fontSize: fontSize, // Adjusted font size
                  fontWeight: FontWeight.w600, // Bold text
                  color: Colors.white,
                  letterSpacing:
                      1.1, // Slightly reduced letter spacing for readability
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
