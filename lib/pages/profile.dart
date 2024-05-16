import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../services/db_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DbService _dbService = DbService();
  final GetStorage _storage = GetStorage();
  int _userTargetBets = 0;

  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserTargetBets();
  }

  //metodo per recuperare il numero di scommesse come target
  Future<void> _fetchUserTargetBets() async {
    final userName = _storage.read('userName');
    if (userName != null) {
      final betsList = await _dbService.getBetsList();
      // Conta quante scommesse hanno l'utente come target
      int targetBetsCount =
          betsList.where((bet) => bet.target == userName).length;
      setState(() {
        _userTargetBets = targetBetsCount;
      });
    }
  }

  Future<void> _fetchUserData() async {
    final userName = _storage.read('userName');
    if (userName != null) {
      final userData = await _dbService.getUsersData();
      if (userData.containsKey(userName)) {
        setState(() {
          _userData = userData[userName];
        });
      }
    }
  }

  Future<void> _resetUserData() async {
    final userName = _storage.read('userName');
    if (userName != null) {
      await _dbService.resetUserData(userName);
      await _fetchUserData();
      await _fetchUserTargetBets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Il mio profilo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(_userData['pfp'] ??
                    'https://thebowlcut.com/cdn/shop/t/41/assets/loading.gif?v=157493769327766696621701744369'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Punteggio: ${_userData['score'] ?? '0'}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Scommesse create: ${_userData['scommesse_create'] ?? '0'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vinte: ${_userData['scommesse_vinte'] ?? '0'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                Text(
                  'Perse: ${_userData['scommesse_perse'] ?? '0'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),


            if (_userTargetBets > 0)
              const FractionallySizedBox(
                widthFactor: 0.5,
                child: SizedBox(
                  width: 50,
                  child: Divider(),
                ),
              ),
            if (_userTargetBets > 0)
              Column(
              children: [
                const Text(
                  '🚨 Attenzione 🚨',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Sei il target di $_userTargetBets ${_userTargetBets == 1 ? 'scommessa' : 'scommesse'}.',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (_userTargetBets > 0)
              const FractionallySizedBox(
              widthFactor: 0.7,
              child: SizedBox(
                width: 50,
                child: Divider(),
              ),
            ),


            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () async {
                await _resetUserData();
              },
              tooltip: "Cancella score e scommesse create",
              child: const Icon(Icons.delete_sweep_outlined),
            )
          : null,
    );
  }
}
