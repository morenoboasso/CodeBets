import 'package:flutter/material.dart';
import '../services/db_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

enum OrderBy { highestScore, lowestScore }

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, int> _usersScores = {};
  OrderBy _orderBy = OrderBy.highestScore;

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

  List<MapEntry<String, int>> _getSortedUsers() {
    // Ordina la mappa degli scores degli utenti in base al punteggio
    List<MapEntry<String, int>> sortedUsers = _usersScores.entries.toList();
    if (_orderBy == OrderBy.highestScore) {
      sortedUsers.sort((a, b) => b.value.compareTo(a.value));
    } else {
      sortedUsers.sort((a, b) => a.value.compareTo(b.value));
    }
    return sortedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classifica'),
        actions: [
          PopupMenuButton<OrderBy>(
            onSelected: (OrderBy result) {
              setState(() {
                _orderBy = result;
              });
            },
            icon: const Icon(Icons.filter_alt_sharp),
            tooltip: "Filtra",
            itemBuilder: (BuildContext context) => <PopupMenuEntry<OrderBy>>[
              const PopupMenuItem<OrderBy>(
                value: OrderBy.highestScore,
                child: Text('Punteggio più alto'),
              ),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.lowestScore,
                child: Text('Punteggio più basso'),
              ),
            ],
          ),
        ],
      ),
      body: _buildLeaderboard(),
    );
  }

  Widget _buildLeaderboard() {
    List<MapEntry<String, int>> sortedUsers = _getSortedUsers();

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
