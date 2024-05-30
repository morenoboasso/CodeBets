import 'package:flutter/material.dart';
import 'package:codebets/style/color_style.dart';
import '../../../models/bet.dart';
import 'bets_answers_shape.dart';

class BetAnswers extends StatelessWidget {
  final Bet bet;
  final String? selectedAnswer;
  final bool isAnswerConfirmed;
  final Function(String) onTap;

  const BetAnswers({
    super.key,
    required this.bet,
    required this.selectedAnswer,
    required this.isAnswerConfirmed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Scegli una risposta:'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 20),
            AnswerContainer(
              answer: bet.answer1,
              color: ColorsBets.orangeHD,
              selectedAnswer: selectedAnswer,
              isAnswerConfirmed: isAnswerConfirmed,
              onTap: () => onTap(bet.answer1),
            ),
            const SizedBox(width: 20),
            AnswerContainer(
              answer: bet.answer2,
              color: ColorsBets.orangeHD,
              selectedAnswer: selectedAnswer,
              isAnswerConfirmed: isAnswerConfirmed,
              onTap: () => onTap(bet.answer2),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 20),
            AnswerContainer(
              answer: bet.answer3,
              color: ColorsBets.orangeHD,
              selectedAnswer: selectedAnswer,
              isAnswerConfirmed: isAnswerConfirmed,
              onTap: () => onTap(bet.answer3),
            ),
            const SizedBox(width: 20),
            AnswerContainer(
              answer: bet.answer4,
              color: ColorsBets.orangeHD,
              selectedAnswer: selectedAnswer,
              isAnswerConfirmed: isAnswerConfirmed,
              onTap: () => onTap(bet.answer4),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
