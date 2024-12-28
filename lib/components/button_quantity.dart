import 'package:flutter/material.dart';

class ButtonQuantity extends StatelessWidget {
  final IconData icon; // The icon to display
  final Color iconColor; // Color of the icon
  final Color backgroundColor; // Background color of the button
  final double borderRadius; // Border radius of the button
  final VoidCallback onPressed; // Action to perform on button press
  final double width;
  final double height;
  final double btnSize;
  const ButtonQuantity({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.borderRadius = 8.0,
    this.width = 30,
    this.height = 30,
    this.btnSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: const Color(0xFFECEBE9), // Border color
            width: 1.0, // Border width
          ),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: iconColor,
          onPressed: onPressed,
          iconSize: btnSize,
        ),
      ),
    );
  }
}
