import 'package:flutter/material.dart';

import '../../models/bet.dart';
import '../../services/db_service.dart';
import '../../widgets/bet_card.dart';
import 'package:get_storage/get_storage.dart';

class ActiveBetsPage extends StatefulWidget {
  const ActiveBetsPage({super.key});

  @override
  _ActiveBetsPageState createState() => _ActiveBetsPageState();
}

class _ActiveBetsPageState extends State<ActiveBetsPage> {
  List<Bet> _betList = [];

  // Carica i bets dal db
  Future<void> _loadBets() async {
    DbService dbService = DbService();
    List<Bet> betList = await dbService.getBetsList();

    // Ottieni l'utente memorizzato nello storage
    String? storedUserName = GetStorage().read<String>('userName');

    // Filtra le scommesse in base al target dell'utente
    //se sono il target non vedrò quella scommessa
    if (storedUserName != null) {
      betList = betList.where((bet) => bet.target != storedUserName).toList();
    }

    // Recupera le risposte dell'utente per le scommesse attive
    Map<String, String> userAnswers = {};
    for (var bet in betList) {
      String? userAnswer = await dbService.getUserAnswerForBet(bet.id, storedUserName!);
      userAnswers[bet.id] = userAnswer!;
    }

    setState(() {
      _betList = betList;
    });
  }

  Future<void> _refresh() async {
    await _loadBets();
  }

  @override
  void initState() {
    super.initState();
    _loadBets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scommesse Attive'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: GridView.builder(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            itemCount: _betList.isEmpty ? 1 : _betList.length,
            itemBuilder: (BuildContext context, int index) {
              if (_betList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("☹️ Nessuna scommessa al momento.."),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: BetCard(
                        bet: _betList[index],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}