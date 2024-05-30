import 'package:auto_size_text/auto_size_text.dart';
import 'package:codebets/models/bet.dart';
import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../services/db_service.dart';
import '../../style/text_style.dart';
import '../../widgets/bet_card/bets_answers_shape.dart';
import '../terminate_bet_dialog/terminate_bet_dialog.dart';
import 'answer_confirm_button.dart';
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
  List<Map<String, String>> _usersList = [];

  @override
  void initState() {
    super.initState();
    _loadUserAnswer();
    _checkAnswerConfirmation();
    _loadUsers();
  }

// Metodo per verificare la conferma della risposta dell'utente
  Future<void> _checkAnswerConfirmation() async {
    String betId = widget.bet.id;
    bool confirmed = await dbService.checkAnswerConfirmation(betId);
    setState(() {isAnwerConfirmed = confirmed;});
  }
// Metodo per caricare la risposta dell'utente
  Future<void> _loadUserAnswer() async {
    String betId = widget.bet.id;
    String? userAnswer = await dbService.loadUserAnswer(betId);
    setState(() {selectedAnswer = userAnswer;});
  }
  //selezione risposta
  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }
  Future<void> _loadUsers() async {
    List<Map<String, String>> usersList = await dbService.getUsersListWithAvatars();
    setState(() {
      _usersList = usersList;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Check if the user is the creator of the bet
    String? storedUserName = GetStorage().read<String>('userName');
    bool isCreator = widget.bet.creator == storedUserName;
// Find target data
    String targetName = widget.bet.target;
    String? targetAvatar = _usersList.isNotEmpty
        ? _usersList.firstWhere((user) => user['name'] == targetName, orElse: () => {'pfp': ''})['pfp']
        : '';
    return Card(
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
          AutoSizeText(
            widget.bet.title,
            minFontSize: 14,
            maxFontSize: 20,
            textAlign: TextAlign.center,
            style: TextStyleBets.betsTitle
          ),
          const SizedBox(height: 10),
          // Description
          if (widget.bet.description.isNotEmpty)
            AutoSizeText(
              widget.bet.description,
              minFontSize: 13,
              maxFontSize: 20,
              textAlign: TextAlign.center,
              style: TextStyleBets.betsDescription ,
            ),
          if (widget.bet.description.isNotEmpty)
            const SizedBox(height: 10),

          // Target
          if (widget.bet.target.isNotEmpty)
          // Target's avatar and name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Target: ',
                    style: TextStyle(fontSize: 14,color: ColorsBets.blackHD, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(targetAvatar ?? ''),
                    radius: 15,
                    backgroundColor: ColorsBets.whiteHD,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    targetName,
                    style: const TextStyle(fontSize: 15,color: ColorsBets.blackHD, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          if (widget.bet.target.isNotEmpty)
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
                  AnswerContainer(
                    answer: widget.bet.answer1,
                    color: ColorsBets.orangeHD,
                    selectedAnswer: selectedAnswer,
                    isAnswerConfirmed: isAnwerConfirmed,
                    onTap: () => selectAnswer(widget.bet.answer1),
                  ),
                  const SizedBox(width: 20),
                  AnswerContainer(
                    answer: widget.bet.answer2,
                    color: ColorsBets.orangeHD,
                    selectedAnswer: selectedAnswer,
                    isAnswerConfirmed: isAnwerConfirmed,
                    onTap: () => selectAnswer(widget.bet.answer2),
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
                    answer: widget.bet.answer3,
                    color: ColorsBets.orangeHD,
                    selectedAnswer: selectedAnswer,
                    isAnswerConfirmed: isAnwerConfirmed,
                    onTap: () => selectAnswer(widget.bet.answer3),
                  ),
                  const SizedBox(width: 20),
                  AnswerContainer(
                    answer: widget.bet.answer4,
                    color: ColorsBets.orangeHD,
                    selectedAnswer: selectedAnswer,
                    isAnswerConfirmed: isAnwerConfirmed,
                    onTap: () => selectAnswer(widget.bet.answer4),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Confirm button
          if ((selectedAnswer != null && selectedAnswer!.isNotEmpty) &&
              !isAnwerConfirmed)
            ConfirmButton(
              onPressed: () {
                setState(() {
                  isAnwerConfirmed = true;
                });
                dbService.confirmSelection(widget.bet.id, selectedAnswer!);
              },
              isEnabled: true,
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
}