import 'package:codebets/models/bet.dart';
import 'package:codebets/style/color_style.dart';
import 'package:codebets/widgets/bet_card/terminate_bet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../services/db_service.dart';
import '../../style/text_style.dart';
import 'bet_creator.dart';
import 'bet_delete.dart';
import 'bet_terminate_button.dart';
import 'bets_answer/bet_answers.dart';
import 'answer_confirm_button.dart';
import 'bet_description.dart';
import 'bet_target.dart';
import 'bet_title.dart';

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
    setState(() {
      isAnwerConfirmed = confirmed;
    });
  }

  // Metodo per caricare la risposta dell'utente
  Future<void> _loadUserAnswer() async {
    String betId = widget.bet.id;
    String? userAnswer = await dbService.loadUserAnswer(betId);
    setState(() {
      selectedAnswer = userAnswer;
    });
  }

  // Selezione risposta
  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  // Caricamento degli utenti
  Future<void> _loadUsers() async {
    List<Map<String, String>> usersList =
    await dbService.getUsersListWithAvatars();
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
        ? _usersList.firstWhere((user) => user['name'] == targetName,
        orElse: () => {'pfp': 'default_avatar'})['pfp']
        : 'default_avatar';
    String? creatorAvatar = _usersList.isNotEmpty
        ? _usersList.firstWhere((user) => user['name'] == widget.bet.creator,
        orElse: () => {'pfp': 'default_avatar'})['pfp']
        : 'default_avatar';

    return Card(
      surfaceTintColor: ColorsBets.whiteHD,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: ColorsBets.blueHD, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            if (isCreator)
              Positioned(
                top: -17.5,
                right: -17.5,
                child: IconButton(
                  tooltip: 'Elimina scommessa',
                  color: ColorsBets.whiteHD,
                  icon: const Icon(Icons.delete_outline,color: Colors.red,size: 18,),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DeleteConfirmationModal(
                          onDelete: () async {
                            // Chiamata per eliminare la scommessa
                            await dbService.deleteBet(widget.bet.id);
                            // Chiudi la modal
                            Navigator.of(context).pop();
                          },
                          onCancel: () {
                            // Chiudi la modal
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Titolo scommessa
                BetTitle(title: widget.bet.title),

                // Descrizione scommessa
                if (widget.bet.description.isNotEmpty)
                  BetDescription(description: widget.bet.description),
                const SizedBox(height: 5),

                // Target scommessa
                if (widget.bet.target.isNotEmpty)
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    BetTarget(targetName: targetName, targetAvatar: targetAvatar!),
                  ]),

                // Creatore bet
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  BetCreator(
                    creatorName: widget.bet.creator,
                    creatorAvatar: creatorAvatar,
                  ),
                ]),
                const SizedBox(height: 15),

                // Risposte
                BetAnswers(
                  bet: widget.bet,
                  selectedAnswer: selectedAnswer,
                  isAnswerConfirmed: isAnwerConfirmed,
                  onTap: selectAnswer,
                ),

                if ((selectedAnswer != null && selectedAnswer!.isNotEmpty) &&
                    !isAnwerConfirmed)
                  const SizedBox(height: 15),

                // Conferma risposta bet
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

                // Terminate bet button
                if (isCreator)
                  const SizedBox(height: 10),
                if (isCreator)
                  TerminateButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogTerminateBet(bet: widget.bet);
                        },
                      );
                    },
                    isEnabled: true,
                  ),

                // Data della scommessa
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.bet.creationDate,
                    style: TextStyleBets.betsDate,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
