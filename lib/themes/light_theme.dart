import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black as Color),
        color: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        centerTitle: true),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.white,
      primary: Colors.white as Color,
      secondary: Colors.deepPurple as Color,
    ));
