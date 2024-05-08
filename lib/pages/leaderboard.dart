import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../widgets/user_stats.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

enum OrderBy { highestScore, lowestScore }

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, dynamic> _usersData = {};
  OrderBy _orderBy = OrderBy.highestScore;

  @override
  void initState() {
    super.initState();
    // Recupera gli scores e le immagini dei profili degli utenti quando la pagina viene creata
    _fetchUsersData();
  }

  Future<void> _fetchUsersData() async {
    // Utilizza il metodo getUsersData() del tuo servizio database
    Map<String, dynamic> usersData = await DbService().getUsersData();
    // Aggiorna lo stato con i dati degli utenti
    setState(() {
      _usersData = usersData;
    });
  }

  List<MapEntry<String, int>> _getSortedUsers() {
    // Ordina la mappa degli scores degli utenti in base al punteggio
    List<MapEntry<String, int>> sortedUsers = _usersData.entries
        .map((entry) => MapEntry<String, int>(entry.key, entry.value['score']))
        .toList();
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
            icon: const Icon(Icons.filter_list),
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

    return RefreshIndicator(
        onRefresh: _fetchUsersData,
        child: ListView.builder(
      itemCount: sortedUsers.length,
      itemBuilder: (context, index) {
        final userName = sortedUsers[index].key;
        final score = sortedUsers[index].value;
        final userPfp = _usersData[userName]['pfp'];
        final scommesseCreate = _usersData[userName]['scommesse_create'];
        final scommesseVinte = _usersData[userName]['scommesse_vinte'];
        final scommessePerse = _usersData[userName]['scommesse_perse'];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UserModal(
                  userPfp: userPfp,
                  userName: userName,
                  score: score,
                  scommesseCreate: scommesseCreate,
                  scommesseVinte: scommesseVinte,
                  scommessePerse: scommessePerse,
                );
              },
            );
          },
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1.5,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(userPfp ?? "https://thebowlcut.com/cdn/shop/t/41/assets/loading.gif?v=157493769327766696621701744369",scale: 100),
              ),
            ),
            title: Text(userName),
            trailing: Text('Punteggio: $score'),
          ),
        );
      },
        ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Classifica',
    home: LeaderboardPage(),
  ));
}
