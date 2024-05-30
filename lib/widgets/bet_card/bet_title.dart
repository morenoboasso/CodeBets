import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../style/text_style.dart';


class BetTitle extends StatelessWidget {
  final String title;

  const BetTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      minFontSize: 14,
      maxFontSize: 20,
      textAlign: TextAlign.center,
      style: TextStyleBets.betsTitle,
    );
  }
}
