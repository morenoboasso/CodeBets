import 'package:codebets/models/bet.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../services/db_service.dart';

class BetCard extends StatefulWidget {
  final Bet bet;

  const BetCard({Key? key, required this.bet}) : super(key: key);

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
                      _buildAnswerContainer(widget.bet.answer1, Colors.orangeAccent),
                      const SizedBox(width: 20),
                      _buildAnswerContainer(widget.bet.answer2, Colors.orangeAccent),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 20),
                      _buildAnswerContainer(widget.bet.answer3, Colors.orangeAccent),
                      const SizedBox(width: 20),
                      _buildAnswerContainer(widget.bet.answer4, Colors.orangeAccent),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              // Confirm button
              if (selectedAnswer != null && selectedAnswer!.isNotEmpty)ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAnwerConfirmed = true;
                      });
                      confirmSelection();
                    },
                    child: isAnwerConfirmed ? const Icon(Icons.check, color: Colors.black) : const Text('Conferma'),
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
                    // Action when the end button is pressed
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
              color: selectedAnswer == answer ? color.withOpacity(1) : color.withOpacity(0.4),
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
}
