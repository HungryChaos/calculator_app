import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '';

  void buttonPressed(String text) {
    setState(() {
      input += text;
    });
  }

  void clear() {
    setState(() {
      input = '';
      result = '';
    });
  }

  void backspace() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = '= ${eval.toString()}';
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  Widget buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (text == '=') {
              calculate();
            } else if (text == 'C') {
              clear();
            } else if (text == '⌫') {
              backspace();
            } else {
              buttonPressed(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF2C2C2C), // Dark grey
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rectangle with slightly rounded edges
            ),
            padding: const EdgeInsets.symmetric(vertical: 22),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Samsung calculator dark background
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input,
                      style: const TextStyle(fontSize: 32, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(result,
                      style: const TextStyle(
                          fontSize: 40,
                          color: Color(0xFF39FF14), // Samsung-ish green result
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [
                buildButton('C', color: Colors.redAccent),
                buildButton('⌫', color: Colors.orangeAccent),
                buildButton('%'),
                buildButton('/'),
              ]),
              Row(children: [
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
                buildButton('*'),
              ]),
              Row(children: [
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
                buildButton('-'),
              ]),
              Row(children: [
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
                buildButton('+'),
              ]),
              Row(children: [
                buildButton('0'),
                buildButton('.'),
                buildButton('=',
                    color: const Color(0xFF39FF14)), // Bright green = button
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
