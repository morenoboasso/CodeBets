import 'package:auto_size_text/auto_size_text.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';
import '../../../style/color_style.dart';

class AnswerContainer extends StatelessWidget {
  final String answer;
  final Color color;
  final String? selectedAnswer;
  final bool isAnswerConfirmed;
  final VoidCallback? onTap;

  const AnswerContainer({
    required this.answer,
    required this.color,
    required this.selectedAnswer,
    required this.isAnswerConfirmed,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (answer.isEmpty) {
      return Expanded(
        child: Container(),
      );
    }

    final boxDecoration = BoxDecoration(
      color: selectedAnswer == answer ? color : color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: ColorsBets.orangeHD.withOpacity(0.5),
        width: isAnswerConfirmed ? 1.5 : 2,
      ),
    );

    return Expanded(
      child: GestureDetector(
        onTap: isAnswerConfirmed ? null : onTap,
        child: Container(
          height: 40,
          decoration: boxDecoration,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  answer,
                  minFontSize: 12,
                  maxFontSize: 20,
                  textAlign: TextAlign.center,
                  style: selectedAnswer == answer
                      ? TextStyleBets.selectedAnswer
                      : TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorsBets.blackHD.withOpacity(0.4),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
