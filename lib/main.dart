import 'package:fit_well/screens/authentication_screen/signin_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fit Well",
      home: SignInScreen(),
    ),
  );
}
