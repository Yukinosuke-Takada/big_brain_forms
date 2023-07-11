import 'package:big_brain_forms/big_brain_forms.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Brain Forms Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Big Brain Forms Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ValueSteppersController controller1 = ValueSteppersController();
    final PhoneNumberPickerController controller2 = PhoneNumberPickerController();
    final YearSliderController controller3 = YearSliderController();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ValueSteppers(
                controller: controller1,
                labelText: 'Age',
                minValue: -2,
                maxValue: 100,
                steps: 1,
                onValueChanged: (value) {
                  print('Value changed to $value');
                },
                textFontSize: 18,
              ),
              PhoneNumberPicker(
                controller: controller2,
                labelText: 'Phone number',
                initialPhoneNumber: '2065550100',
                useCountryCode: true,
                initialCountryCode: 1,
                onValueChanged: (value) {
                  print('Value changed to $value');
                },
                textFontSize: 18,
              ),
              YearSlider(
                controller: controller3,
                labelText: 'Year',
                initialYear: 2001,
                minYear: -13600000000,
                maxYear: 2023,
                onValueChanged: (value) {
                  print('Value changed to $value');
                },
                textFontSize: 18,
              ),
              ElevatedButton(
                onPressed: () {
                  print('ValueSteppers: ${controller1.getValue()}');
                  print('PhoneNumberPicker: ${controller2.getValue()}');
                  print('YearSlider: ${controller3.getValue()}');
                },
                child: const Text('Print values'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
