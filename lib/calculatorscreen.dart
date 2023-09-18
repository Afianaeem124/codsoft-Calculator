import 'package:calculator_app/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = ""; //+ / * -
  String number2 = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 160,
                    color: Color.fromARGB(255, 192, 183, 183),
                    alignment: Alignment.bottomRight,
                    child: Text(
                        "$number1$operand$number2".isEmpty
                            ? "0"
                            : "$number1$operand$number2",
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.right),
                  ),
                ),
              ),
            ),
            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  //#############################################################################################
  void appendval(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //calculate eq before asgn new operand
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      //number1="1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        //number1=" |"0"
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      //number1="1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        //number1=" |"0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  //#############################################################################################
  void onbtntap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      percentage();
      return;
    }
    // if (value == Btn.fact) {
    //   factorial(value);
    //   return;
    // }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendval(value);
  }

//#############################################################################################
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;

      default:
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

//#############################################################################################

//#############################################################################################
  void percentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //calculate the eq
      calculate();
    }
    if (operand.isNotEmpty) {
      //error

      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  //#############################################################################################
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //#############################################################################################
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = " ";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

//#############################################################################################
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: btncolor(value),
        clipBehavior: Clip.hardEdge,
        shape: const CircleBorder(eccentricity: BorderSide.strokeAlignCenter),
        child: InkWell(
          onTap: () => onbtntap(value),
          child: Center(
            child: Text(value, style: Theme.of(context).textTheme.labelSmall),
          ),
        ),
      ),
    );
  }

//#############################################################################################
  Color btncolor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Color.fromARGB(255, 231, 94, 140)
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Color.fromARGB(255, 98, 168, 84)
            : Color.fromARGB(255, 113, 205, 248);
  }
}
