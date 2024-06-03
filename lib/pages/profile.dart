import 'dart:async';
import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../services/db_service.dart';
import '../style/text_style.dart';

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

  StreamSubscription<Map<String, dynamic>>? _userDataSubscription;

  @override
  void initState() {
    super.initState();
    _fetchUserTargetBets();
    _fetchUserData();
    _userDataSubscription = _dbService.getUserDataStream().listen((userData) {
      setState(() {
        _userData = userData;
      });
    });
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
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

  void _logout() {
    _storage.remove('userName');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
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
                              radius: 80,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(_userData['pfp'] ??
                                  "https://thebowlcut.com/cdn/shop/t/41/assets/loading.gif?v=157493769327766696621701744369",),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _storage.read('userName') ?? '',
                            style:  TextStyleBets.profileUserName,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Punteggio: ',
                                style: TextStyleBets.profileVariable,
                              ),
                              Text(
                                '${_userData['score'] ?? ''}',
                                style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD),
                              ),
                            ],
                          ),
                          const SizedBox(height:15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Scommesse create: ',
                                style: TextStyleBets.profileVariable,
                              ),
                              Text(
                                '${_userData['scommesse_create'] ?? ''}',
                                style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Vinte: ',
                                    style: TextStyleBets.profileVariable,
                                  ),
                                  Text(
                                    '${_userData['scommesse_vinte'] ?? ''}',
                                    style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Perse: ',
                                    style: TextStyleBets.profileVariable,
                                  ),
                                  Text(
                                    '${_userData['scommesse_perse'] ?? ''}',
                                    style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_userTargetBets > 0)
                            const SizedBox(height: 20),
                          if (_userTargetBets > 0)
                            const FractionallySizedBox(
                              widthFactor: 0.5,
                              child: SizedBox(
                                width: 50,
                                child: Divider(color: ColorsBets.blackHD,),
                              ),
                            ),
                          if (_userTargetBets > 0)
                            Column(
                              children: [
                                const Text(
                                  '🚨 Attenzione 🚨',
                                  style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Sei il target di $_userTargetBets ${_userTargetBets == 1 ? 'scommessa' : 'scommesse'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          if (_userTargetBets > 0)
                            const FractionallySizedBox(
                              widthFactor: 0.7,
                              child: SizedBox(
                                width: 50,
                                child: Divider(color: ColorsBets.blackHD,),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 5,
            child: IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout,color: ColorsBets.blueHD,size: 28,),
            ),
          ),
        ],
      ),
    );
  }
}