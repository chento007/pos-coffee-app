import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final int? fillColor; // Nullable color
  final int textColor;
  final double textSize;
  final void Function(String) callback; // Type-safe callback

  const CalcButton({
    Key? key,
    required this.text, // Required text field
    this.fillColor,
    this.textColor = 0xFFFFFFFF,
    this.textSize = 28,
    required this.callback, // Required callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.black26, // Use nullable fillColor
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          onPressed: () {
            callback(text);
          },
          child: Text(
            text,
            style: GoogleFonts.rubik(
              textStyle: TextStyle(
                fontSize: textSize,
                color: Color(textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
