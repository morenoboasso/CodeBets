import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../style/text_style.dart';

class BetDescription extends StatelessWidget {
  final String description;

  const BetDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      description,
      minFontSize: 13,
      maxFontSize: 20,
      textAlign: TextAlign.justify,
      style: TextStyleBets.betsDescription,
    );
  }
}
