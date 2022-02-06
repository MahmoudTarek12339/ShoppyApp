import 'package:flutter/material.dart';

ThemeData darkTheme=ThemeData(
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    elevation: 0.0,
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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xFFff4667),
    unselectedItemColor: Colors.white,
    elevation: 10.0,
    backgroundColor: Colors.black,
  ),
  backgroundColor: Colors.pink,
  focusColor: Color(0xFFff4667),
  errorColor: Colors.deepOrange,
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  primaryColor: Colors.black,
  canvasColor: Colors.white,
  cardColor: Colors.black54,
);

ThemeData lightTheme=ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    centerTitle: true,
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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xff00BE84),
    unselectedItemColor: Colors.black,
    elevation: 10.0,
    backgroundColor: Colors.white,
  ),
  backgroundColor: Colors.black,
  focusColor: Color(0xff00BE84),
  errorColor: Colors.red,
  iconTheme: IconThemeData(
      color: Colors.black,
    ),
  primaryColor: Colors.white,
  canvasColor: Colors.grey,
  cardColor: Colors.grey[200],
);
/*const Color mainColor = Color(0xff00BE84);
const Color darkGreyClr = Color(0xFF121212);
const Color pinkClr = Color(0xFFff4667);*/