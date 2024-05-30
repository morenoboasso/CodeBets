import 'package:flutter/material.dart';

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

    if (isAnswerConfirmed) {
      return Expanded(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selectedAnswer == answer ? color.withOpacity(1) : color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              answer,
              textAlign: TextAlign.center,
              style: selectedAnswer == answer
                  ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  : TextStyle(color: Colors.black.withOpacity(0.8)),
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: selectedAnswer == answer ? color.withOpacity(1) : color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                answer,
                textAlign: TextAlign.center,
                style: selectedAnswer == answer
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    : TextStyle(color: Colors.black.withOpacity(0.8)),
              ),
            ),
          ),
        ),
      );
    }
  }
}
