import 'package:codebets/pages/ping_pong.dart';
import 'package:codebets/pages/profile.dart';
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

  static final List<Widget> _widgetOptions = <Widget>[
    const ActiveBetsPage(),
    const CreateBetPage(),
    const LeaderboardPage(),
    const PingPongPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
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
            icon: Icon(Icons.monetization_on_rounded),
            label: 'Attive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'Aggiungi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Classifica',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Ping Pong',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
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


