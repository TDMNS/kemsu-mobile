import 'package:flutter/material.dart';

ThemeData darkThemeProperties = ThemeData(
    accentColor: Colors.red,
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.black,
    ));

ThemeData lightThemeProperties = ThemeData(
  accentColor: Colors.pink,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black)),
);
