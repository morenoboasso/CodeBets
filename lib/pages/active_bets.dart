// active_bets_page.dart
import 'package:codebets/models/bet.dart';
import 'package:codebets/services/db_service.dart';
import 'package:codebets/widgets/bet_card.dart';
import 'package:flutter/material.dart';

class ActiveBetsPage extends StatefulWidget {
  const ActiveBetsPage({super.key});

  @override
  _ActiveBetsPageState createState() => _ActiveBetsPageState();
}

class _ActiveBetsPageState extends State<ActiveBetsPage> {

  List<Bet> _betList = [];

  Future<void> _loadBets() async {
    DbService dbService = DbService();
    List<Bet> betList = await dbService.getBetsList();
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
    return Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _betList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: InkWell(
                      onTap: () { },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BetCard(
                          bet: _betList[index],
                        ),
                      )),
                );
              },
            ));
  }
}