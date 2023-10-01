import 'package:calculator_app/pages/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [buildOutputSection(), buildButtonsSection()],
        ),
      ),
    );
  }

  Widget buildOutputSection() {
    return Expanded(
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "$number1$operand$number2".isEmpty
                ? "0"
                : "$number1$operand$number2",
            style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }

  Widget buildButtonsSection() {
    final screenSize = MediaQuery.of(context).size;
    return Wrap(
        children: Buttons.buttonValues
            .map((value) => SizedBox(
                width: [Buttons.n0].contains(value)
                    ? screenSize.width / 2
                    : screenSize.width / 4,
                height: screenSize.width / 5,
                child: buildButton(value)))
            .toList());
  }

  Widget buildButton(String buttonValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: getButtonColor(buttonValue),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.white24)),
        child: InkWell(
            onTap: () => onButtonTap(buttonValue),
            child: Center(
                child: Text(
              buttonValue,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ))),
      ),
    );
  }

  Color getButtonColor(value) {
    return [Buttons.del, Buttons.clr].contains(value)
        ? Colors.blueGrey
        : [
            Buttons.per,
            Buttons.multiply,
            Buttons.add,
            Buttons.subtract,
            Buttons.divide,
            Buttons.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  onButtonTap(String tappedInput) {
    if (tappedInput == Buttons.del) {
      delete();
      return;
    }
    if (tappedInput == Buttons.clr) {
      clearAll();
      return;
    }
    if (tappedInput == Buttons.per) {
      convertToPercentage();
      return;
    }

    if (tappedInput == Buttons.calculate) {
      calculate();
      return;
    }
    appendValue(tappedInput);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double doubleNumber1 = double.parse(number1);
    final double doubleNumber2 = double.parse(number2);

    var result = 0.0;

    switch (operand) {
      case Buttons.add:
        result = doubleNumber1 + doubleNumber2;
        break;
      case Buttons.subtract:
        result = doubleNumber1 - doubleNumber2;
        break;
      case Buttons.multiply:
        result = doubleNumber1 * doubleNumber2;
        break;
      case Buttons.divide:
        result = doubleNumber1 / doubleNumber2;
        break;
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

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //calculate before conversion to percentage
      calculate();
    }
    if (operand.isNotEmpty) {
      //cannot be converted
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String valueToAppend) {
    // if is operand and not "."
    if (valueToAppend != Buttons.dot && int.tryParse(valueToAppend) == null) {
      //Operand pressed

      if (operand.isNotEmpty && number2.isNotEmpty) {
        //perform the calculation
        calculate();
      }
      operand = valueToAppend;
    }
    //assign a value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      //(Check if value is ".")

      if (valueToAppend == Buttons.dot && number1.contains(Buttons.dot)) return;
      if (valueToAppend == Buttons.dot &&
          (number1.isEmpty || number1 == Buttons.n0)) {
        valueToAppend = "0.";
      }
      number1 += valueToAppend;
    }
    //assign a value to number1 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      if (valueToAppend == Buttons.dot && number2.contains(Buttons.dot)) return;
      if (valueToAppend == Buttons.dot &&
          (number2.isEmpty || number2 == Buttons.n0)) {
        valueToAppend = "0.";
      }
      number2 += valueToAppend;
    }

    setState(() {});
  }
}
