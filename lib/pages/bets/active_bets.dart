import 'package:codebets/style/color_style.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';
import '../../models/bet.dart';
import '../../services/db_service.dart';
import '../../widgets/bet_card/bet_card_shape.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/intro_screen.dart';

class ActiveBetsPage extends StatefulWidget {
  const ActiveBetsPage({super.key});

  @override
  _ActiveBetsPageState createState() => _ActiveBetsPageState();
}

class _ActiveBetsPageState extends State<ActiveBetsPage> {
  List<Bet> _betList = [];
  bool _isLoading = true;
  late Stream<List<Bet>> _betsStream;

  @override
  void initState() {
    super.initState();
    _betsStream = DbService().betsStream;
    _loadBets();
  }

  Future<void> _loadBets() async {
    String? storedUserName = GetStorage().read<String>('userName');
    await for (List<Bet> snapshot in _betsStream) {
      setState(() {
        _isLoading = true;
      });
      _betList = snapshot;
      if (storedUserName != null) {
        _betList = _betList.where((bet) => bet.target != storedUserName).toList();
      }

      // Ordina la lista in base alla data di creazione dalla più recente alla meno recente
      _betList.sort((a, b) => b.creationDate.compareTo(a.creationDate));

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _noBets() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Nessuna scommessa al momento", style: TextStyle(color: ColorsBets.blueHD)),
          const SizedBox(height: 10),
          ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: ColorsBets.whiteHD,
              child: Image.asset(
                "assets/error.gif",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "Scommesse Attive",
                    style: TextStyleBets.activeBetTitle,
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const IntroScreen()),
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: _isLoading
                        ?  const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: ColorsBets.blueHD,
                          ),
                        ],
                      ),
                    )
                        : _betList.isEmpty
                        ? _noBets()
                        : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 10, 20, 20),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: BetCard(
                                      bet: _betList[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: _betList.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
