import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static lightElevatedButtonTheme({required bool isWear}) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.myWhite,
          backgroundColor: AppColors.myGreen,
          padding: EdgeInsets.symmetric(
            vertical: isWear ? 2.0 : 18.0,
            horizontal: isWear ? 8.0 : 20.0,
          ),
          textStyle: TextStyle(
            fontSize: isWear ? 10.0 : 18.0,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isWear ? 18.0 : 12.0),
          ),
        ),
      );

  static darkElevatedButtonTheme({required bool isWear}) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.myBlack,
          backgroundColor: AppColors.myGreen,
          padding: EdgeInsets.symmetric(
            vertical: isWear ? 2.0 : 18.0,
            horizontal: isWear ? 8.0 : 20.0,
          ),
          textStyle: TextStyle(
            fontSize: isWear ? 10.0 : 18.0,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isWear ? 18.0 : 12.0),
          ),
        ),
      );
}
