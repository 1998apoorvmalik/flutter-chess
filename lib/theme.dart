import 'package:flutter/material.dart';
import 'package:flutter_chess/constants.dart';

ThemeData themeData = ThemeData(
  fontFamily: kFontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: kPrimaryColor,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black.withOpacity(kBlackOpacity),
    ),
    color: kPrimaryColor,
    titleTextStyle: TextStyle(
      fontFamily: kFontFamily,
      color: Colors.black.withOpacity(kBlackOpacity),
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: 0,
      primary: Colors.black.withOpacity(kBlackOpacity),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
    labelStyle: const TextStyle(
      fontSize: 18,
      color: kSecondaryColor,
    ),
    floatingLabelStyle: TextStyle(
      fontSize: 18,
      color: Colors.black.withOpacity(kBlackOpacity),
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            width: kBorderWidth,
            color: Colors.black.withOpacity(kBlackOpacity))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            width: kBorderWidth,
            color: Colors.black.withOpacity(kBlackOpacity))),
  ),
  sliderTheme: ThemeData.dark().sliderTheme.copyWith(
        activeTrackColor: Colors.black.withOpacity(kBlackOpacity / 1.5),
        overlayColor: Colors.transparent,
        thumbColor: kIconColor,
        inactiveTrackColor: kSecondaryColor,
      ),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.black.withOpacity(kBlackOpacity),
      fontWeight: FontWeight.bold,
      fontSize: 40,
      letterSpacing: 2,
    ),
    headline2: const TextStyle(
      color: kPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    headline3: TextStyle(
      color: Colors.black.withOpacity(kBlackOpacity),
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
);
