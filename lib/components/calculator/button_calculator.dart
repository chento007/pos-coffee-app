import 'package:flutter/material.dart';

// creating Stateless Widget for buttons
class ButtonCalculator extends StatelessWidget {

  // declaring variables
  final color;
  final textColor;
  final String buttonText;
  final buttontapped;

  //Constructor
  ButtonCalculator({this.color, this.textColor,required this.buttonText, this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}