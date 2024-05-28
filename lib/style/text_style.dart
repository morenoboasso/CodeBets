import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';

class TextStyleBets {
  // Titoli generali
  static TextStyle get titleBlue => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ColorsBets.blueHD,
      );

  //  --login--
  //login hint text
  static TextStyle get hintTextLogin => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: ColorsBets.blueHD.withOpacity(0.8),
      );
  //login input text
  static TextStyle get inputTextLogin => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: ColorsBets.blueHD,
      );
  //
  static TextStyle get inputTextTitle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD,
  );
  static TextStyle get hintTextTitle =>  TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD.withOpacity(0.6),
  );
  static TextStyle get hintTextAnswer => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD.withOpacity(0.3),
  );
}