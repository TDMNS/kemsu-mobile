import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black54,
      dividerColor: Colors.transparent,
      primaryColor: Colors.grey.shade900,
      focusColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
          iconColor: Colors.white,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          fillColor: Colors.white,
          focusColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.grey.withOpacity(0.2),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue))),
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(color: Colors.white)),
      cardColor: Colors.grey.shade900,
      expansionTileTheme: const ExpansionTileThemeData(
        //backgroundColor: Colors.grey.shade900,
        textColor: Colors.blue,
        collapsedIconColor: Colors.white,
        iconColor: Colors.blue,
        //collapsedBackgroundColor: Colors.grey.shade900,
      ),
      colorScheme: const ColorScheme.dark());

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      dividerColor: Colors.transparent,
      primaryColor: Colors.white,
      primaryColorDark: Colors.black,
      primaryColorLight: Colors.grey.withOpacity(0.4),
      focusColor: Colors.black,
      inputDecorationTheme: const InputDecorationTheme(
          iconColor: Colors.black,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          fillColor: Colors.black,
          focusColor: Colors.black,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue))),
      canvasColor: Colors.grey.shade600,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black)),
      cardColor: Colors.white,
      expansionTileTheme: const ExpansionTileThemeData(
        //backgroundColor: Colors.white,
        textColor: Colors.blue,
        collapsedIconColor: Colors.black,
        iconColor: Colors.blue,
      ),
      colorScheme: const ColorScheme.light());
}
