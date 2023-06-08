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
        primarySwatch: Colors.blue,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            ValueSteppers(
              text: 'Age',
              minValue: -2,
              maxValue: 100,
              steps: 1,
              onValueChanged: (value) {
                print('Value changed to $value');
              },
            ),
            const PhoneNumberPicker(
              text: 'Phone number',
              initialPhoneNumber: '2065550100',
              useCountryCode: true,
              initialCountryCode: 1,
            ),
          ],
        ),
      ),
    );
  }
}
