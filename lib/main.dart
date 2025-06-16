import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
      ),
      home: const CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String input = '';
  String output = '0';

  void onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        input = '';
        output = '0';
      } else if (text == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
        output = input.isEmpty ? '0' : input;
      } else if (text == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(
            input.replaceAll('×', '*').replaceAll('÷', '/'),
          );
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toString();
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += text;
        output = input;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    output,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    buildButtonRow(['C', '⌫', '÷', '×']),
                    buildButtonRow(['7', '8', '9', '-']),
                    buildButtonRow(['4', '5', '6', '+']),
                    buildButtonRow(['1', '2', '3', '=']),
                    buildButtonRow(['.', '0', '00']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        children: labels.map((label) {
          bool isOperator = ['÷', '×', '-', '+', '=', 'C', '⌫'].contains(label);
          bool isEqual = label == '=';
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ElevatedButton(
                onPressed: () => onButtonPressed(label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOperator
                      ? (isEqual ? Colors.orange : Colors.deepPurple)
                      : Colors.grey[800],
                  padding: const EdgeInsets.all(22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
