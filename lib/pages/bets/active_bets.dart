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
  bool _isLoading = true;

  // Load bets from the database
  Future<void> _loadBets() async {
    DbService dbService = DbService();
    List<Bet> betList = await dbService.getBetsList();

    // Get the user stored in the storage
    String? storedUserName = GetStorage().read<String>('userName');

    // Filter bets based on the user's target
    // if I am the target I will not see that bet
    if (storedUserName != null) {
      betList = betList.where((bet) => bet.target != storedUserName).toList();
    }

    // Retrieve user answers for active bets
    Map<String, String> userAnswers = {};
    for (var bet in betList) {
      String? userAnswer =
          await dbService.getUserAnswerForBet(bet.id, storedUserName!);
      userAnswers[bet.id] = userAnswer!;
    }

    // Set loading completion state
    setState(() {
      _betList = betList;
      _isLoading = false;
    });
  }

  // Reload bets
  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
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
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Caricamento..."),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    backgroundColor: Colors.orangeAccent,
                    color: Colors.orange.withOpacity(0.7),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: _betList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Nessuna scommessa al momento"),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: _refresh,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_outlined,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                            childCount: _betList.length,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
