import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';

class MyCardTheme {
  MyCardTheme._();

  static lightCardTheme({required bool isWear}) => CardTheme(
    color: AppColors.myGreen,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isWear? 16.0 : 18.0)),
  );

  static darkCardTheme({required bool isWear}) => CardTheme(
    color: AppColors.myGreen,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isWear? 16.0 : 18.0)),
  );
}