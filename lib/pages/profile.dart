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

  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(_userData['pfp'] ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              'Punteggio: ${_userData['score'] ?? ''}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
