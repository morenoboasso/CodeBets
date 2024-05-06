import 'package:codebets/pages/ping_pong.dart';
import 'package:flutter/material.dart';

import 'bets/active_bets.dart';
import 'bets/create_bet.dart';
import 'leaderboard.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  BottomNavigationBarWidgetState createState() =>
      BottomNavigationBarWidgetState();
}

class BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;
  bool _createBetRequested = false; // Flag per indicare se è stata richiesta la creazione di una nuova scommessa

  static final List<Widget> _widgetOptions = <Widget>[
    CreateBetPage(),
    ActiveBetsPage(),
    LeaderboardPage(),
    PingPongPage(),
  ];

  void _onItemTapped(int index) {
    // Se l'utente ha richiesto di creare una nuova scommessa, andiamo alla tab delle scommesse attive
    if (_createBetRequested) {
      _createBetRequested = false; // Resettiamo il flag
      setState(() {
        _selectedIndex = 1; // Vai alla tab delle scommesse attive
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Aggiungi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_rounded),
            label: 'Attive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Classifica',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Ping Pong',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey,fontSize: 10),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
