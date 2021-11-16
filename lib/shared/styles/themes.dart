import 'package:flutter/material.dart';

ThemeData darkTheme=ThemeData(
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      fontSize: 20.0,
      color: Colors.grey,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
    ),
    subtitle2: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ) ,
    headline1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ) ,

    caption: TextStyle(
      color: Colors.grey,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
    ),
  ),
  buttonColor: Colors.pink,
  backgroundColor: Colors.pink,
  focusColor: Colors.pinkAccent,
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  primaryColor: Colors.black,
  canvasColor: Colors.white,
);

ThemeData lightTheme=ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Colors.black
    )
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 20.0,
      color: Colors.grey,

    ),
    subtitle1: TextStyle(
      color: Colors.black,
    ),
    subtitle2: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ) ,
    headline1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ) ,
    caption: TextStyle(
      color: Colors.grey,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
    )
  ),
  buttonColor: Colors.blueAccent,
  backgroundColor: Colors.black,
  focusColor: Colors.blue,
  iconTheme: IconThemeData(
      color: Colors.black,
    ),
  primaryColor: Colors.white,
  canvasColor: Colors.grey,
);