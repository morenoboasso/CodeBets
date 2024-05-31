import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';

import '../../models/bet.dart';
import '../../services/db_service.dart';
import '../../style/color_style.dart';


class DialogTerminateBet extends StatefulWidget {
  final Bet bet;

  const DialogTerminateBet({super.key, required this.bet});

  @override
  _DialogTerminateBetState createState() => _DialogTerminateBetState();
}

class _DialogTerminateBetState extends State<DialogTerminateBet> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsBets.whiteHD,
      surfaceTintColor: ColorsBets.whiteHD,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: ColorsBets.blueHD, width: 3.5),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsBets.blueHD, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              'Seleziona il risultato vincente:',
              style: TextStyleBets.dialogTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            _buildAnswerButton(widget.bet.answer1),
            const SizedBox(height: 15),
            _buildAnswerButton(widget.bet.answer2),
            const SizedBox(height: 15),
            if (widget.bet.answer3.isNotEmpty)
              _buildAnswerButton(widget.bet.answer3),
            if (widget.bet.answer3.isNotEmpty)
              const SizedBox(height: 15),
            if (widget.bet.answer4.isNotEmpty)
              _buildAnswerButton(widget.bet.answer4),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    label: 'Annulla',
                    color: Colors.red.withOpacity(0.5),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    label: 'Conferma',
                    color: ColorsBets.orangeHD,
                    onPressed: selectedAnswer != null ? () {
                      // Output della risposta selezionata in debug
                      debugPrint('Risposta vincente: $selectedAnswer');
                      // Chiudi il dialog
                      Navigator.of(context).pop();
                      // Esegui il controllo delle risposte e l'aggiornamento del punteggio
                      DbService().checkAndUpdateScores(selectedAnswer!, widget.bet.id, widget.bet.target);
                    } : null, // Disabilitato se selectedAnswer è null
                    enabled: selectedAnswer != null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String answer) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = answer;
        });
      },
      child: Container(
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selectedAnswer == answer
              ? ColorsBets.blueHD.withOpacity(1)
              : ColorsBets.blueHD.withOpacity(0.1),
          border: Border.all(color: ColorsBets.blueHD, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            answer,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: selectedAnswer == answer ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
              color: selectedAnswer == answer ? Colors.white : Colors.black.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(enabled ? 1 : 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}