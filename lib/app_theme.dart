import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static String fontFamily = '';
  static Color primaryColor = const Color(0xff51971B);
  static Color hintColor = const Color(0xff686868);
  static Color starColor = Colors.lightGreen.shade200;
  static Color scaffoldBackgroundColor = Colors.black;

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: primaryColor,
    hintColor: hintColor,
    backgroundColor: const Color(0xff51971B),
    primaryColorLight: Colors.white,
    dividerColor: hintColor,
    cardColor: const Color(0xff202020),

    ///appBar theme
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      centerTitle: true,
    ),

    ///text theme
    textTheme: TextTheme(
      headline4: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      button: const TextStyle(fontSize: 16.5),
      bodyText2: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      caption: TextStyle(color: hintColor),
    ).apply(),
  );

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.blueGrey.shade50,
    primaryColor: primaryColor,
    hintColor: hintColor,
    backgroundColor: Colors.white,
    primaryColorLight: Colors.black,
    dividerColor: hintColor,
    cardColor: Colors.white,

    ///appBar theme
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryColor),
      centerTitle: true,
    ),

    ///text theme
    textTheme: TextTheme(
      headline4: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      button: const TextStyle(fontSize: 16.5),
      // headline6: TextStyle(color: Colors.black),
      // headline5: TextStyle(color: Colors.black),
      // bodyText1: TextStyle(color: Colors.black),
      // subtitle1: TextStyle(color: Colors.black),
      // subtitle2: TextStyle(color: Colors.black),
      bodyText2: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      caption: TextStyle(color: hintColor),
    ).apply(
      displayColor: Colors.black,
      bodyColor: Colors.black,
      decorationColor: Colors.black,
    ),
  );
}
