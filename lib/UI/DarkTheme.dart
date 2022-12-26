import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black54,
      dividerColor: Colors.transparent,
      primaryColor: Colors.grey.shade900,
      primaryColorDark: Colors.white,
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade900,
      ),
      cardColor: Colors.grey.shade900,
      expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.grey.shade900,
          textColor: Colors.blue,
          collapsedIconColor: Colors.white,
          iconColor: Colors.blue,
          collapsedBackgroundColor: Colors.grey.shade900),
      colorScheme: const ColorScheme.dark());

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      dividerColor: Colors.transparent,
      primaryColor: Colors.white,
      primaryColorDark: Colors.black,
      canvasColor: Colors.grey.shade600,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      cardColor: Colors.white,
      expansionTileTheme: const ExpansionTileThemeData(
        //backgroundColor: Colors.white,
        textColor: Colors.blue,
        collapsedIconColor: Colors.black,
        iconColor: Colors.blue,
      ),
      colorScheme: const ColorScheme.light());
}
