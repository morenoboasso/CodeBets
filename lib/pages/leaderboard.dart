import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../widgets/leaderboard/other_user_stats_dialog.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

enum OrderBy { highestScore, lowestScore, mostCreatedBets, mostWonBets, mostLostBets }

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, dynamic> _usersData = {};
  OrderBy _orderBy = OrderBy.highestScore;
  String _appBarTitle = 'Classifica';


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
    List<MapEntry<String, int>> sortedUsers = _usersData.entries
        .where((entry) => entry.key != 'Admin')
        .map((entry) =>
        MapEntry<String, int>(entry.key, _getOrderByValue(entry)))
        .toList();

    sortedUsers.sort((a, b) => _compareValues(a.value, b.value));
    return sortedUsers;
  }


//ordini vari
  int _getOrderByValue(MapEntry<String, dynamic> entry) {
    switch (_orderBy) {
      case OrderBy.highestScore:
        return entry.value['score'];
      case OrderBy.lowestScore:
        return entry.value['score'];
      case OrderBy.mostCreatedBets:
        return entry.value['scommesse_create'];
      case OrderBy.mostWonBets:
        return entry.value['scommesse_vinte'];
      case OrderBy.mostLostBets:
        return entry.value['scommesse_perse'];
    }
  }

  int _compareValues(int a, int b) {
    if (_orderBy == OrderBy.lowestScore) {
      return a.compareTo(b);
    }
    return b.compareTo(a);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        actions: [
          PopupMenuButton<OrderBy>(
            onSelected: (OrderBy result) {
              setState(() {
                _orderBy = result;
                _updateAppBarTitle();
              });
            },
            icon: const Icon(Icons.filter_list),
            tooltip: "Filtra",
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<OrderBy>>[
              const PopupMenuItem<OrderBy>(
                value: OrderBy.highestScore,
                child: Text('👑 - Punteggio più alto'),
              ),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.lowestScore,
                child: Text('💩 - Punteggio più basso'),
              ),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.mostCreatedBets,
                child: Text('💰 - Scommesse create'),
              ),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.mostWonBets,
                child: Text('🏆 - Scommesse vinte'),
              ),
              const PopupMenuItem<OrderBy>(
                value: OrderBy.mostLostBets,
                child: Text('😢 - Scommesse perse'),
              ),
            ],
          ),
        ],
      ),
      body: _buildLeaderboard(),
    );
  }

  void _updateAppBarTitle() {
    switch (_orderBy) {
      case OrderBy.highestScore:
        setState(() {
          _appBarTitle = 'Classifica';
        });
        break;
      case OrderBy.lowestScore:
        setState(() {
          _appBarTitle = 'Classifica dei peggiori';
        });
        break;
      case OrderBy.mostCreatedBets:
        setState(() {
          _appBarTitle = 'Classifica del ludopatico';
        });
        break;
      case OrderBy.mostWonBets:
        setState(() {
          _appBarTitle = 'Classifica del Vincente';
        });
        break;
      case OrderBy.mostLostBets:
        setState(() {
          _appBarTitle = 'Classifica del Perdente';
        });
        break;
    }
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
          // Determina l'emoji da mostrare in base alla posizione
          Widget leadingIcon;
          if (index == 0) {
            leadingIcon = const Text('🏆',style: TextStyle(fontSize: 20),); // Primo utente
          } else if (index == 1) {
            leadingIcon = const Text('🥈',style: TextStyle(fontSize: 20),); // Secondo utente
          } else if (index == 2) {
            leadingIcon = const Text('🥉',style: TextStyle(fontSize: 20),); // Terzo utente
          } else if (index == sortedUsers.length - 1) {
            leadingIcon = const Text('💩',style: TextStyle(fontSize: 20),); // Ultimo utente
          } else {
            leadingIcon = Text(' ${index + 1}°',style: const TextStyle(fontSize: 20),); // Altri utenti con il loro numero di classifica
          }
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
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leadingIcon,
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      userPfp ??
                          "https://thebowlcut.com/cdn/shop/t/41/assets/loading.gif?v=157493769327766696621701744369",
                      scale: 100,
                    ),
                  ),
                ],
              ),
              title: Text(userName),
              trailing: Text('$score'),
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
