import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';

class MyInputFieldTheme {
  MyInputFieldTheme._();

  static InputDecorationTheme lightInputTheme({required bool isWear}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.myLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWear ? 20.0 : 12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: isWear ? 0.0 : 16.0,
          horizontal: isWear ? 10.0 : 16.0,
        ),
        hintStyle: TextStyle(
          color: AppColors.myGray,
          fontSize: isWear ? 8.0 : 16.0,
        ),
      );

  static InputDecorationTheme darkInputTheme({required bool isWear}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.myGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWear ? 20.0 : 12.0),
          borderSide: BorderSide.none,
        ),

        contentPadding: EdgeInsets.symmetric(
          vertical: isWear ? 0.0 : 16.0,
          horizontal: isWear ? 10.0 : 16.0,
        ),
        hintStyle: TextStyle(
          color: AppColors.myLightGray,
          fontSize: isWear ? 8.0 : 16.0,
        ),
      );
}
