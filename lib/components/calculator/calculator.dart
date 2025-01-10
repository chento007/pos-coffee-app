import 'package:coffee_app/components/calculator/card_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class CalcApp extends StatefulWidget {
  const CalcApp({Key? key}) : super(key: key);

  @override
  CalcAppState createState() => CalcAppState();
}

class CalcAppState extends State<CalcApp> {
  String _history = '';
  String _expression = '';

  void numClick(String text) {
    setState(() => _expression += text);
  }

  void allClear(String text) {
    setState(() {
      _history = '';
      _expression = '';
    });
  }

  void clear(String text) {
    setState(() {
      _expression = '';
    });
  }

  void evaluate(String text) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();

      setState(() {
        _history = _expression;
        _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
      });
    } catch (e) {
      setState(() {
        _expression = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF283637),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: const Alignment(1.0, 1.0),
            padding: const EdgeInsets.all(5),
            child: Text(
              _history,
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF545F61),
                ),
              ),
            ),
          ),
          Container(
            alignment: const Alignment(1.0, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                _expression,
                style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ..._buildButtonRows(),
        ],
      ),
    );
  }

  /// Build rows of calculator buttons
  List<Widget> _buildButtonRows() {
    return [
      _buildButtonRow([
        CalcButton(
          text: 'AC',
          fillColor: 0xFF6C807F,
          textSize: 20,
          callback: allClear,
        ),
        CalcButton(
          text: 'C',
          fillColor: 0xFF6C807F,
          callback: clear,
        ),
        CalcButton(
          text: '%',
          fillColor: 0xFFFFFFFF,
          textColor: 0xFF65BDAC,
          callback: numClick,
        ),
        CalcButton(
          text: '/',
          fillColor: 0xFFFFFFFF,
          textColor: 0xFF65BDAC,
          callback: numClick,
        ),
      ]),
      _buildButtonRow([
        CalcButton(text: '7', callback: numClick),
        CalcButton(text: '8', callback: numClick),
        CalcButton(text: '9', callback: numClick),
        CalcButton(
          text: '*',
          fillColor: 0xFFFFFFFF,
          textColor: 0xFF65BDAC,
          callback: numClick,
        ),
      ]),
      _buildButtonRow([
        CalcButton(text: '4', callback: numClick),
        CalcButton(text: '5', callback: numClick),
        CalcButton(text: '6', callback: numClick),
        CalcButton(
          text: '-',
          fillColor: 0xFFFFFFFF,
          textColor: 0xFF65BDAC,
          callback: numClick,
        ),
      ]),
      _buildButtonRow([
        CalcButton(text: '1', callback: numClick),
        CalcButton(text: '2', callback: numClick),
        CalcButton(text: '3', callback: numClick),
        CalcButton(
          text: '+',
          fillColor: 0xFFFFFFFF,
          textColor: 0xFF65BDAC,
          callback: numClick,
        ),
      ]),
      _buildButtonRow([
        CalcButton(text: '.', callback: numClick),
        CalcButton(text: '0', callback: numClick),
        CalcButton(
          text: '00',
          callback: numClick,
          textSize: 26,
        ),
        CalcButton(
          text: '=',
          fillColor: 0xFFFFFFFF,
          textColor: 0xFF65BDAC,
          callback: evaluate,
        ),
      ]),
    ];
  }

  /// Helper function to build a row of buttons
  Widget _buildButtonRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
