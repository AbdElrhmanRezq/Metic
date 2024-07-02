import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        color: Colors.black,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        centerTitle: true),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(
          255, 11, 11, 11), // Darker shade of grey for background
      primary: Color.fromARGB(255, 42, 41,
          41), // Light purple (Material Design recommended color for dark theme)
      secondary: Color.fromARGB(255, 161, 21, 21),
    ));
