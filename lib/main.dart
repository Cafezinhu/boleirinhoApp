import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  runApp(Boleirinho());
}

class Boleirinho extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      title: "Boleirinho"
    );
  }
}