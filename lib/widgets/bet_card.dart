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

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void confirmSelection() async {
    if (selectedAnswer != null) {
      // Ottieni il nome utente dall'archiviazione locale
      String? userName = GetStorage().read<String>('userName');

      // Ottieni l'ID della scommessa
      String betId = widget.bet.id; // Assumi che la classe Bet abbia un campo "id"

      // Invia la risposta al database
      await dbService.updateAnswer(betId, userName!, selectedAnswer!);

      // Aggiorna lo stato o esegui altre azioni necessarie

      // Stampa un messaggio di debug
      debugPrint('Risposta inviata al database con successo!');
    } else {
      // Gestisci il caso in cui nessuna risposta è stata selezionata
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
          Text(widget.bet.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Creatore: ${widget.bet.creator}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Target: ${widget.bet.target}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: [
              const Text('Punta su di una risposta:'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnswerContainer(widget.bet.answer1),
                  _buildAnswerContainer(widget.bet.answer2),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnswerContainer(widget.bet.answer3),
                  _buildAnswerContainer(widget.bet.answer4),
                ],
              ),
            ],
          ),
          if (selectedAnswer != null)
            ElevatedButton(
              onPressed: confirmSelection,
              child: const Text('Conferma'),
            ),
          Text(widget.bet.creationDate),
        ],
      ),
    );
  }

  Widget _buildAnswerContainer(String answer) {
    if (answer.isNotEmpty) {
      return Expanded(
        child: GestureDetector(
          onTap: () => selectAnswer(answer),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedAnswer == answer ? Colors.blue : Colors.black,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(child: Text(answer)),
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
