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

    setState(() {
      _betList = betList;
    });
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
        actions: <Widget>[
          IconButton(
            tooltip: "Storico scommesse",
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              //todo: gestire hystory
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: _betList.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("☹️ Nessuna scommessa al momento.."),
            ],
          ),
        )
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemCount: _betList.length,
          itemBuilder: (BuildContext context, int index) {
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
          },
        ),
      ),
    );
  }
}
