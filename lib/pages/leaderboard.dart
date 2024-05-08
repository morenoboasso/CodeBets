import 'package:flutter/material.dart';

import '../services/db_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, int> _usersScores = {};

  @override
  void initState() {
    super.initState();
    // Recupera gli scores degli utenti quando la pagina viene creata
    _fetchUsersScores();
  }

  Future<void> _fetchUsersScores() async {
    // Utilizza il metodo getUsersScores() del tuo servizio database
    Map<String, int> usersScores = await DbService().getUsersScores();
    // Aggiorna lo stato con i punteggi degli utenti
    setState(() {
      _usersScores = usersScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classifica'),
      ),
      body: _buildLeaderboard(),
    );
  }

  Widget _buildLeaderboard() {
    // Ordina la mappa degli scores degli utenti in base al punteggio
    List<MapEntry<String, int>> sortedUsers = _usersScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      itemCount: sortedUsers.length,
      itemBuilder: (context, index) {
        final userName = sortedUsers[index].key;
        final score = sortedUsers[index].value;
        return ListTile(
          title: Text(userName),
          trailing: Text('Punteggio: $score'),
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Classifica',
    home: LeaderboardPage(),
  ));
}
