import 'package:codebets/models/bet.dart';
import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../services/db_service.dart';
import 'dialog/terminate_bet_dialog.dart';

class BetCard extends StatefulWidget {
  final Bet bet;

  const BetCard({super.key, required this.bet});

  @override
  _BetCardState createState() => _BetCardState();
}

class _BetCardState extends State<BetCard> {
  String? selectedAnswer;
  DbService dbService = DbService();
  bool isAnwerConfirmed = false;

  @override
  void initState() {
    super.initState();
    _loadUserAnswer();
    _checkAnswerConfirmation();
  }

//controlla se l'utente ha gia selezionato una risposta
  Future<void> _checkAnswerConfirmation() async {
    String? userName = GetStorage().read<String>('userName');
    String betId = widget.bet.id;
    String? userAnswer = await dbService.getUserAnswerForBet(betId, userName!);
    setState(() {
      isAnwerConfirmed = userAnswer != null && userAnswer.isNotEmpty;
    });
  }

// carica le risposte date
  Future<void> _loadUserAnswer() async {
    String? userName = GetStorage().read<String>('userName');
    String betId = widget.bet.id;
    String? userAnswer = await dbService.getUserAnswerForBet(betId, userName!);
    setState(() {
      selectedAnswer = userAnswer;
    });
  }

  //selezione risposta
  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  //conferma selezione
  void confirmSelection() async {
    if (selectedAnswer != null) {
      String? userName = GetStorage().read<String>('userName');

      // Get the bet ID
      String betId = widget.bet.id;

      // Send the answer to the database
      await dbService.updateAnswer(betId, userName!, selectedAnswer!);

      debugPrint('Answer sent to the database successfully!');
    } else {
      debugPrint('Select an answer before confirming!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is the creator of the bet
    String? storedUserName = GetStorage().read<String>('userName');
    bool isCreator = widget.bet.creator == storedUserName;

    return
      Card(
        surfaceTintColor: ColorsBets.whiteHD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: ColorsBets.blueHD, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              widget.bet.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            if (widget.bet.description.isNotEmpty)
              Text(
                widget.bet.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            const SizedBox(height: 10),

            // Target
            if (widget.bet.target.isNotEmpty)
              Text(
                'Target: ${widget.bet.target}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 15),
            // Answers
            Column(
              children: [
                const Text('Scegli una risposta:'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 20),
                    _buildAnswerContainer(
                        widget.bet.answer1, Colors.orangeAccent),
                    const SizedBox(width: 20),
                    _buildAnswerContainer(
                        widget.bet.answer2, Colors.orangeAccent),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 20),
                    _buildAnswerContainer(
                        widget.bet.answer3, Colors.orangeAccent),
                    const SizedBox(width: 20),
                    _buildAnswerContainer(
                        widget.bet.answer4, Colors.orangeAccent),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),

            // Confirm button
            if ((selectedAnswer != null && selectedAnswer!.isNotEmpty) &&
                !isAnwerConfirmed)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAnwerConfirmed = true;
                  });
                  confirmSelection();
                },
                child: const Text('Conferma'),
              ),

            const SizedBox(height: 20),
            // Creator and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Creatore: ${widget.bet.creator}',
                ),
                Text(widget.bet.creationDate),
                // Button for creator
              ],
            ),
            const SizedBox(height: 5),
            // termina bet button
            if (isCreator)
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogTerminateBet(bet: widget.bet);
                    },
                  );
                },
                child: const Text('Terminate'),
              ),
            const SizedBox(height: 10),
          ],
        ),
      );
  }

  Widget _buildAnswerContainer(String answer, Color color) {
    if (answer.isNotEmpty) {
      // Verifica se l'utente ha già fornito una risposta per questa scommessa
      if (isAnwerConfirmed) {
        // Se sì, rendi il container non cliccabile solo se questa è la risposta selezionata
        return Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: selectedAnswer == answer ? color.withOpacity(1) : color
                  .withOpacity(0.4),
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
        // Altrimenti, rendi il container cliccabile
        return Expanded(
          child: GestureDetector(
            onTap: () => selectAnswer(answer),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: selectedAnswer == answer ? color.withOpacity(1) : color
                    .withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  answer,
                  textAlign: TextAlign.center,
                  style: selectedAnswer == answer
                      ? const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)
                      : TextStyle(color: Colors.black.withOpacity(0.8)),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      return Expanded(
        child: Container(),
      );
    }
  }

  Widget _buildAnswerButton(String answer, VoidCallback onTap,
      bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Colors.lightGreen.withOpacity(1) : Colors
                .lightGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              answer,
              textAlign: TextAlign.center,
              style: isSelected
                  ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                  : TextStyle(
                  color: Colors.black.withOpacity(0.8), fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}