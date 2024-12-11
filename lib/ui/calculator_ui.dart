// IM-2021-067
//Thujatha Ponnuthurai

import 'package:flutter/material.dart';
import '../logic/calculator_logic.dart';
import 'package:flutter/services.dart';

class CalculatorHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const CalculatorHome({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  final CalculatorLogic calculatorLogic = CalculatorLogic();
  bool showExtraFunctions = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: widget.isDarkMode
            ? const Color.fromARGB(255, 24, 17, 34)
            : Colors.white,
        systemNavigationBarIconBrightness:
            widget.isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: buildDisplayArea(),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showExtraFunctions = !showExtraFunctions;
              });
            },
            child: Icon(
              showExtraFunctions
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 30,
              color: widget.isDarkMode
                  ? const Color(0xB3FFFFFF)
                  : const Color.fromARGB(255, 53, 53, 67),
            ),
          ),
          if (showExtraFunctions)
            ExtraFunctionButtons(
              isDarkMode: widget.isDarkMode,
              calculatorLogic: calculatorLogic,
              onUpdate: () {
                setState(() {});
              },
            ),
          Expanded(
            flex: 3,
            child: buildMainButtons(),
          ),
        ],
      ),
    );
  }

  Widget buildDisplayArea() {
    return Container(
      color: widget.isDarkMode
          ? const Color.fromARGB(217, 54, 54, 75)
          : const Color.fromARGB(217, 239, 239, 247),
      child: Stack(
        children: [
          Positioned(
            top: 26,
            right: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: widget.toggleTheme,
                ),
                const SizedBox(width: 3),
                IconButton(
                  icon: Icon(
                    Icons.history,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          history: calculatorLogic.history,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  calculatorLogic.userInput,
                  style: TextStyle(
                    fontSize: 33,
                    color: widget.isDarkMode
                        ? const Color.fromRGBO(255, 255, 255, 0.702)
                        : Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  calculatorLogic.answer,
                  style: TextStyle(
                    fontSize: 48,
                    color: widget.isDarkMode
                        ? const Color.fromRGBO(255, 255, 255, 1)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainButtons() {
    const buttonRows = [
      ['C', '⌫', '%', '÷'],
      ['7', '8', '9', 'x'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
    ];

    return Column(
      children: buttonRows.map((row) => createRow(row)).toList()
        ..add(
          Expanded(
            child: Row(
              children: [
                createButton('0', flex: 1, color: buttonColor('0')),
                createButton('.', flex: 1, color: buttonColor('.')),
                createButton('=', flex: 2, color: buttonColor('=')),
              ],
            ),
          ),
        ),
    );
  }

  Widget createRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          return createButton(
            button,
            flex: 1,
            color: buttonColor(button),
          );
        }).toList(),
      ),
    );
  }

  Widget createButton(String text, {required int flex, required Color color}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          setState(() {
            calculatorLogic.handleButtonPress(text);
          });
        },
        child: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(90),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColorForButton(text),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color buttonColor(String button) {
    if (button == 'C' || button == '⌫' || button == '%') {
      return const Color.fromARGB(255, 62, 50, 86);
    } else if (calculatorLogic.isOperator(button)) {
      return widget.isDarkMode
          ? const Color(0xD9D9D9FF)
          : const Color.fromARGB(217, 157, 157, 224);
    } else if (button == '=') {
      return const Color.fromARGB(255, 68, 37, 131);
    } else if (['√', '^', '( )', 'π'].contains(button)) {
      return const Color.fromARGB(255, 53, 39, 83);
    } else {
      return widget.isDarkMode
          ? const Color.fromARGB(217, 54, 54, 75)
          : const Color.fromARGB(255, 230, 229, 229);
    }
  }

  Color textColorForButton(String button) {
    if (button == 'C' || button == '⌫' || button == '%') {
      return widget.isDarkMode
          ? const Color.fromARGB(250, 255, 255, 255)
          : const Color.fromARGB(255, 255, 255, 255);
    } else if (calculatorLogic.isOperator(button)) {
      return widget.isDarkMode
          ? const Color.fromARGB(255, 82, 51, 99)
          : const Color.fromARGB(255, 82, 51, 99);
    } else if (button == '=') {
      return widget.isDarkMode
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 255, 255, 255);
    } else if (['√', '^', '( )', 'π'].contains(button)) {
      return widget.isDarkMode
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 255, 255, 255);
    } else {
      return widget.isDarkMode
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 0, 0, 0);
    }
  }
}

class ExtraFunctionButtons extends StatelessWidget {
  final bool isDarkMode;
  final CalculatorLogic calculatorLogic;
  final VoidCallback onUpdate;

  const ExtraFunctionButtons({
    Key? key,
    required this.isDarkMode,
    required this.calculatorLogic,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const extraFunctions = ['√', '^', '( )', 'π'];

    return Container(
      color: isDarkMode
          ? const Color(0xFF20232A)
          : const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: 117,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 8,
          childAspectRatio: 1.1,
          physics: const NeverScrollableScrollPhysics(),
          children: extraFunctions.map((text) {
            return GestureDetector(
              onTap: () {
                print('Extra button pressed: $text');
                calculatorLogic.handleButtonPress(text);
                onUpdate();
              },
              child: Container(
                margin: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 53, 39, 83),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final List<String> history;

  HistoryScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              history[index],
              style: TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
