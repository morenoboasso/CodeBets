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
  //create bet
  //bet input form
  static TextStyle get inputTextTitle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD,
  );
  //bet hint form
  static TextStyle get hintTextTitle =>  TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD.withOpacity(0.6),
  );
  //bet form text
  static TextStyle get hintTextAnswer => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD.withOpacity(0.3),
  );
  //titolo schermata bet
  static TextStyle get betTextTitle => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blueHD,
  );

  //bets attive
//titolo
  static TextStyle get activeBetTitle => const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blackHD,
  );

  //dialog termina bet
  static TextStyle get dialogTitle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorsBets.blueHD,
  );
}