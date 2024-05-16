import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isAnwerConfirmed = false;

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
            if (selectedAnswer != null &&
                selectedAnswer!.isNotEmpty)ElevatedButton(
              onPressed: () {
                setState(() {
                  isAnwerConfirmed = true;
                });
                confirmSelection();
              },
              child: isAnwerConfirmed ? const Icon(
                  Icons.check, color: Colors.black) : const Text('Conferma'),
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
            // End bet button
            if (isCreator)
              ElevatedButton(
                onPressed: () {
                  _terminateBet();
                },
                child: const Text('Termina'),
              ),
            const SizedBox(height: 10),
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
            height: 40,
            decoration: BoxDecoration(
              color: selectedAnswer == answer ? color.withOpacity(1) : color
                  .withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                answer,
                style: selectedAnswer == answer
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    : TextStyle(color: Colors.black.withOpacity(0.8)),
              ),
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(),
      );
    }
  }

  //conferma risposta termina bet
  Widget _buildAnswerButton(String answer, VoidCallback onTap,
      bool isSelected) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black.withOpacity(0.8),
        backgroundColor: isSelected ? Colors.green : null,
      ),
      child: Text(answer),
    );
  }

  void _terminateBet() async {
    String? selectedAnswer;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Seleziona risultato scommessa:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display options for selecting winning answer
                  // Display answers in rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 20),
                      _buildAnswerButton(widget.bet.answer1, () {
                        setState(() {
                          selectedAnswer = widget.bet.answer1;
                        });
                      }, selectedAnswer == widget.bet.answer1),
                      const SizedBox(width: 20),
                      _buildAnswerButton(widget.bet.answer2, () {
                        setState(() {
                          selectedAnswer = widget.bet.answer2;
                        });
                      }, selectedAnswer == widget.bet.answer2),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 20),
                      if (widget.bet.answer3.isNotEmpty)
                        _buildAnswerButton(widget.bet.answer3, () {
                          setState(() {
                            selectedAnswer = widget.bet.answer3;
                          });
                        }, selectedAnswer == widget.bet.answer3),
                      const SizedBox(width: 20),
                      if (widget.bet.answer4.isNotEmpty)

                        _buildAnswerButton(widget.bet.answer4, () {
                          setState(() {
                            selectedAnswer = widget.bet.answer4;
                          });
                        }, selectedAnswer == widget.bet.answer4),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annulla'),
                ),
                if (selectedAnswer != null)
                  TextButton(
                    onPressed: () {
                      // Output della risposta selezionata in debug
                      debugPrint('Risposta vincente: $selectedAnswer');
                      // Chiudi il dialog
                      Navigator.of(context).pop();
                      // Esegui il controllo delle risposte e l'aggiornamento del punteggio
                      _checkAndUpdateScores(selectedAnswer!);
                    },
                    child: const Text('Conferma'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  //aumento punti sul db
  void _checkAndUpdateScores(String selectedAnswer) async {
    try {
      String betId = widget.bet.id;

      // Ottieni e aggiorna i punteggi degli utenti
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .get();

      for (var doc in querySnapshot.docs) {
        String user = doc['utente'];
        String answer = doc['risposta_scelta'];
        String target = widget.bet.target;

        if (user == target) {
          await FirebaseFirestore.instance.collection('users').doc(user).update({
            'score': FieldValue.increment(2),
          });
        }

        // Verifica se l'utente ha selezionato una risposta
        if (answer.isNotEmpty) {
          // Controlla se la risposta dell'utente è corretta
          if (answer == selectedAnswer) {
            // Se la risposta è corretta, aumenta il punteggio e il numero di scommesse vinte
            await FirebaseFirestore.instance.collection('users').doc(user).update({
              'score': FieldValue.increment(5), // Aumenta punteggio per chi vince
              'scommesse_vinte': FieldValue.increment(1),
            });

            // Se l'utente è il target, aggiungi anche punti bonus
          } else {
            // Se la risposta è sbagliata, incrementa solo il numero di scommesse perse
            await FirebaseFirestore.instance.collection('users').doc(user).update({
              'scommesse_perse': FieldValue.increment(1),
            });
          }
        }
      }

      // Cancella le risposte associate alla scommessa
      await FirebaseFirestore.instance
          .collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Cancella la scommessa stessa
      await FirebaseFirestore.instance.collection('scommesse').doc(betId).delete();

      debugPrint('Punteggi aggiornati e risposte cancellate correttamente!');
    } catch (e) {
      debugPrint("Errore durante l'aggiornamento dei punteggi degli utenti o la cancellazione delle risposte: $e");
    }
  }


}