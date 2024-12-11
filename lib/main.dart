// IM-2021-067
//Thujatha Ponnuthurai

import 'package:flutter/material.dart';
import 'ui/calculator_ui.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF20232A),
            )
          : ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
      home: CalculatorHome(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}
