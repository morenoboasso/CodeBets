import 'package:codebets/models/bet.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../services/db_service.dart';

class BetCard extends StatefulWidget {
  final Bet bet;

  const BetCard({super.key, required this.bet});

  @override
  _BetCardState createState() => _BetCardState();
}

class _BetCardState extends State<BetCard> {
  String? selectedAnswer;
  DbService dbService = DbService();

  @override
  void initState() {
    super.initState();
    _loadUserAnswer();
  }

  Future<void> _loadUserAnswer() async {
    String? userName = GetStorage().read<String>('userName');
    String betId = widget.bet.id;
    String? userAnswer = await dbService.getUserAnswerForBet(betId, userName!);
    setState(() {
      selectedAnswer = userAnswer;
    });
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void confirmSelection() async {
    if (selectedAnswer != null) {
      String? userName = GetStorage().read<String>('userName');

      // Ottieni l'ID della scommessa
      String betId = widget.bet.id;

      // Invia la risposta al database
      await dbService.updateAnswer(betId, userName!, selectedAnswer!);

      debugPrint('Risposta inviata al database con successo!');
    } else {
      debugPrint('Seleziona una risposta prima di confermare!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.bet.title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (widget.bet.description.isNotEmpty)
          Text(widget.bet.description),
          if (widget.bet.target.isNotEmpty)
            Text(
              'Target: ${widget.bet.target}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),


          Column(
            children: [
              const Text('Scegli una risposta:'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20,),

                  _buildAnswerContainer(widget.bet.answer1, Colors.orangeAccent),
                  const SizedBox(width: 20,),
                  _buildAnswerContainer(widget.bet.answer2, Colors.orangeAccent),
                  const SizedBox(width: 20,),

                ],
              ),
              const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 20,),
                      _buildAnswerContainer(widget.bet.answer3, Colors.orangeAccent),
                      const SizedBox(width: 20,),
                      _buildAnswerContainer(widget.bet.answer4, Colors.orangeAccent),
                      const SizedBox(width: 20,),
                    ],
                  ),
            ],
          ),
          if (selectedAnswer != null && selectedAnswer!.isNotEmpty)
            ElevatedButton(
              onPressed: confirmSelection,
              child: const Text('Conferma'),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Creatore: ${widget.bet.creator}',
              ),
              Text(widget.bet.creationDate),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerContainer(String answer, Color color) {
    if (answer.isNotEmpty) {
      return Expanded(
        child: GestureDetector(
          onTap: () => selectAnswer(answer),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: selectedAnswer == answer ? color.withOpacity(1) : color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(
              answer,
              style: selectedAnswer == answer ? const TextStyle(fontWeight: FontWeight.bold,fontSize: 16) : TextStyle(color: Colors.black.withOpacity(0.8) ) )),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(),
      );
    }
  }
}
