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
            "0",
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

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: getButtonColor(value),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.white24)),
        child: InkWell(
            onTap: () {},
            child: Center(
                child: Text(
              value,
              style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
}
