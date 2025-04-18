import 'package:fit_well/utils/custom_themes/card_theme.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:fit_well/utils/custom_themes/elevated_button_theme.dart';
import 'package:fit_well/utils/custom_themes/input_field_theme.dart';
import 'package:fit_well/utils/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();

  static ThemeData lightTheme({required bool isWear}) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.myGreen,
    scaffoldBackgroundColor: AppColors.myWhite,
    textTheme: MyTextTheme.lightTextTheme(isWear: isWear),
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme(
      isWear: isWear,
    ),
    inputDecorationTheme: MyInputFieldTheme.lightInputTheme(isWear: isWear),
    cardTheme: MyCardTheme.lightCardTheme(isWear: isWear),
  );

  static ThemeData darkTheme({required bool isWear}) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.myGreen,
    scaffoldBackgroundColor: AppColors.myBlack,
    textTheme: MyTextTheme.darkTextTheme(isWear: isWear),
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme(
      isWear: isWear,
    ),
    inputDecorationTheme: MyInputFieldTheme.darkInputTheme(isWear: isWear),
    cardTheme: MyCardTheme.darkCardTheme(isWear: isWear),
  );
}
