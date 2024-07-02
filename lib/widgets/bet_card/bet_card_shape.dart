import 'package:codebets/models/bet.dart';
import 'package:codebets/style/color_style.dart';
import 'package:codebets/widgets/bet_card/terminate_bet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
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
  bool isAnswerConfirmed = false;
  List<Map<String, String>> _usersList = [];
  List<Map<String, String>> _votingUsersList = [];

  @override
  void initState() {
    super.initState();
    _loadUserAnswer();
    _checkAnswerConfirmation();
    _loadUsers();
    _loadVotingUsers();
  }

  Future<void> _loadVotingUsers() async {
    List<Map<String, String>> votingUsersList =
    await dbService.getUsersListWithAvatars();
    List<Map<String, String>> votingUsersWithAnswers = [];

    for (var user in votingUsersList) {
      String? userAnswer =
      await dbService.loadUserAnswerForBet(user['name']!, widget.bet.id);
      if (userAnswer != null && userAnswer.isNotEmpty) {
        votingUsersWithAnswers.add(user);
      }
    }
    setState(() {
      _votingUsersList = votingUsersWithAnswers;
    });
  }

  Future<void> _checkAnswerConfirmation() async {
    String betId = widget.bet.id;
    bool confirmed = await dbService.checkAnswerConfirmation(betId);
    setState(() {
      isAnswerConfirmed = confirmed;
    });
  }

  Future<void> _loadUserAnswer() async {
    String betId = widget.bet.id;
    String? userAnswer = await dbService.loadUserAnswer(betId);
    setState(() {
      selectedAnswer = userAnswer;
    });
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  Future<void> _loadUsers() async {
    List<Map<String, String>> usersList =
    await dbService.getUsersListWithAvatars();
    setState(() {
      _usersList = usersList;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? storedUserName = GetStorage().read<String>('userName');
    bool isTarget = widget.bet.target == storedUserName;

    String targetName = widget.bet.target;
    String? targetAvatar = _usersList.isNotEmpty
        ? _usersList.firstWhere((user) => user['name'] == targetName,
        orElse: () => {'pfp': 'default_avatar'})['pfp']
        : 'default_avatar';
    String? creatorAvatar = _usersList.isNotEmpty
        ? _usersList.firstWhere((user) => user['name'] == widget.bet.creator,
        orElse: () => {'pfp': 'default_avatar'})['pfp']
        : 'default_avatar';

    int numVoters = _usersList.where((user) => user['name'] != null).length;
    int numVotingUsers = _votingUsersList.length;
    String votingCountText = '$numVotingUsers/$numVoters';

    return Card(
      surfaceTintColor: ColorsBets.whiteHD,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: ColorsBets.blueHD, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BetTitle(title: widget.bet.title),
                  if (widget.bet.description.isNotEmpty)
                    BetDescription(description: widget.bet.description),
                  const SizedBox(height: 5),
                  if (widget.bet.target.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BetTarget(targetName: targetName, targetAvatar: targetAvatar!),
                      ],
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BetCreator(
                        creatorName: widget.bet.creator,
                        creatorAvatar: creatorAvatar,
                      ),
                      Text(
                        'Voti: $votingCountText',
                        style: TextStyleBets.inputTextLogin,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  BetAnswers(
                    bet: widget.bet,
                    selectedAnswer: selectedAnswer,
                    isAnswerConfirmed: isAnswerConfirmed,
                    onTap: selectAnswer,
                  ),
                  if ((selectedAnswer != null && selectedAnswer!.isNotEmpty) &&
                      !isAnswerConfirmed)
                    const SizedBox(height: 15),
                  if ((selectedAnswer != null && selectedAnswer!.isNotEmpty) &&
                      !isAnswerConfirmed)
                    ConfirmButton(
                      onPressed: () {
                        setState(() {
                          isAnswerConfirmed = true;
                        });
                        dbService.confirmSelection(widget.bet.id, selectedAnswer!);
                      },
                      isEnabled: true,
                    ),
                  if (widget.bet.creator == storedUserName) const SizedBox(height: 10),
                  if (widget.bet.creator == storedUserName)
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
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.bet.creator == storedUserName)
                        IconButton(
                          tooltip: 'Elimina scommessa',
                          color: ColorsBets.whiteHD,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 24,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteConfirmationModal(
                                  onDelete: () async {
                                    await dbService.deleteBet(widget.bet.id);
                                    Navigator.of(context).pop();
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      Expanded(
                        child: Text(
                          widget.bet.creationDate,
                          style: TextStyleBets.betsDate,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isTarget)
              Positioned.fill(
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Sei il target, non puoi rispondere',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
