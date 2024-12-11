// IM-2021-067
//Thujatha Ponnuthurai

import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String userInput = '';
  String answer = '';
  bool lastInputWasOperator = false;
  bool lastInputWasDot = false;
  int openBrackets = 0;

  List<String> history = [];

  static const maxDisplayCharacters = 12;

  bool isOperator(String button) {
    return ['+', '-', 'x', '÷', '^'].contains(button);
  }

  // for Handle button press
  void handleButtonPress(String button) {
    if (button == 'C') {
      userInput = '';
      answer = '';
      lastInputWasOperator = false;
      lastInputWasDot = false;
      openBrackets = 0;
    } else if (button == '⌫') {
      if (answer.isNotEmpty) {
        userInput = '';
        answer = '';
        lastInputWasOperator = false;
        lastInputWasDot = false;
        openBrackets = 0;
      } else {
        if (userInput.isNotEmpty) {
          String lastChar = userInput[userInput.length - 1];
          if (lastChar == '.') lastInputWasDot = false;
          if (['+', '-', 'x', '÷', '^'].contains(lastChar)) {
            lastInputWasOperator = false;
          }
          if (lastChar == '(') openBrackets--;
          if (lastChar == ')') openBrackets++;
          userInput = userInput.substring(0, userInput.length - 1);
        }
      }
    } else if (button == '=') {
      equalPressed();
    } else if (button == '%') {
      percentagePressed();
    } else if (['+', '-', 'x', '÷'].contains(button)) {
      addOperator(button);
    } else if (button == '.') {
      addDot();
    } else if (button == '√') {
      handleSquareRoot();
    } else if (button == '^') {
      addOperator(button);
    } else if (button == '( )') {
      handleParentheses();
    } else if (button == 'π') {
      addPi();
    } else {
      if (answer.isNotEmpty) {
        userInput = button;
        answer = '';
      } else {
        userInput += button;
      }
      lastInputWasOperator = false;
      lastInputWasDot = false;
    }
  }

  // for Handle equal press
  void equalPressed() {
    try {
      String finalInput = userInput.replaceAll('x', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      final normalizedInput = finalInput.replaceAll(RegExp(r'(\d)0+'), r'$1');

      if (normalizedInput.contains(RegExp(r'/\s*0$'))) {
        answer = "Error";
        userInput = '';
        return;
      }

      if (normalizedInput.startsWith('0/')) {
        answer = "0";
        userInput = '';
        return;
      }

      answer = formatResult(eval);

      //I used this for store the calculation and result in history
      history.insert(0, '$userInput = $answer');

      userInput = '';
    } catch (e) {
      answer = "Error";
    }
    lastInputWasOperator = false;
    lastInputWasDot = false;
  }

  // format the result
  String formatResult(double result) {
    const int maxDecimalPlaces = 8;
    const double largeNumberThreshold = 1e12;

    if (result.abs() >= largeNumberThreshold ||
        result.isNaN ||
        result.isInfinite) {
      return result.toStringAsExponential(2);
    }

    String formattedResult = result.toStringAsFixed(maxDecimalPlaces);

    if (formattedResult.contains('.') && formattedResult.endsWith('0')) {
      formattedResult = formattedResult.replaceAll(RegExp(r'0*$'), '');
    }

    if (formattedResult.endsWith('.')) {
      formattedResult =
          formattedResult.substring(0, formattedResult.length - 1);
    }

    return formattedResult;
  }

  // percentage calculation
  void percentagePressed() {
    try {
      if (userInput.isNotEmpty) {
        double value = double.parse(userInput);
        double result = value / 100;
        answer = formatResult(result);
        userInput = '';
      }
    } catch (e) {
      answer = "Error";
    }
  }

  // for handle square root calculation
  void handleSquareRoot() {
    try {
      if (userInput.isNotEmpty) {
        double value = double.parse(userInput);

        if (value < 0) {
          answer = "Error: Negative number";
        } else {
          answer = sqrt(value)
              .toStringAsPrecision(10)
              .replaceAll(RegExp(r'\.0+$'), '');
        }

        userInput = '';
      }
    } catch (e) {
      answer = "Error";
    }
  }

  // for handle brackets input
  void handleParentheses() {
    if (openBrackets > 0) {
      userInput += ')';
      openBrackets--;
    } else {
      userInput += '(';
      openBrackets++;
    }
  }

  // I used for add pi value
  void addPi() {
    const piValue = 3.14159; // The specific value for π
    if (answer.isNotEmpty) {
      userInput = answer + piValue.toString();
      answer = '';
    } else {
      userInput += piValue.toString();
    }

    lastInputWasOperator = false;
    lastInputWasDot = false;
  }

  // add operator with validation
  void addOperator(String operator) {
    if (userInput.isEmpty && answer.isNotEmpty) {
      userInput = answer + operator;
      answer = '';
    } else if (lastInputWasOperator) {
      // replace the last operator
      userInput = userInput.substring(0, userInput.length - 1) + operator;
    } else if (userInput.isNotEmpty) {
      userInput += operator;
    }
    lastInputWasOperator = true;
    lastInputWasDot = false;
  }

  // used for add dot
  void addDot() {
    if (userInput.isNotEmpty) {
      List<String> segments = userInput.split(RegExp(r'[+\-*/]'));
      String lastSegment = segments.last;

      if (!lastSegment.contains('.')) {
        userInput += '.';
        lastInputWasDot = true;
        lastInputWasOperator = false;
      }
    }
  }
}
