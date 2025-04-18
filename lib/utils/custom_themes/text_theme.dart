import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';

class MyTextTheme {
  MyTextTheme._();

  static TextTheme lightTextTheme({required bool isWear}) => TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: isWear ? 12.0 : 26.0,
      fontWeight: FontWeight.bold,
      color: AppColors.myBlack,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: isWear ? 8.0 : 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.myBlack,
    ),
    // labelSmall: TextStyle(
    //   fontSize: isWear ? 4.0 : 12.0,
    //   fontWeight: FontWeight.w500,
    //   color: AppColors.myBlack,
    // ),
  );

  static TextTheme darkTextTheme({required bool isWear}) => TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: isWear ? 12.0 : 26.0,
      fontWeight: FontWeight.bold,
      color: AppColors.myWhite,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: isWear ? 8.0 : 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.myWhite,
    ),
    // labelSmall: TextStyle(
    //   fontSize: isWear ? 4.0 : 12.0,
    //   fontWeight: FontWeight.w500,
    //   color: AppColors.myWhite,
    // ),
  );
}
