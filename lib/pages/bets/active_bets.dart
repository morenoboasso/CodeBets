import 'package:codebets/style/color_style.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';
import '../../models/bet.dart';
import '../../services/db_service.dart';
import '../../widgets/bet_card/bet_card_shape.dart';
import 'package:get_storage/get_storage.dart';

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
        _betList =
            _betList.where((bet) => bet.target != storedUserName).toList();
      }
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
           const Text("Nessuna scommessa al momento",style: TextStyle(color: ColorsBets.blueHD)),
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
                const SizedBox(height: 20),
                 Text(
                  "Scommesse Attive",
                  style: TextStyleBets.activeBetTitle,
                ),
                Expanded(
                  child: Container(
                    child: _isLoading
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Caricamento..."),
                          const SizedBox(height: 20),
                          CircularProgressIndicator(
                            backgroundColor: Colors.orangeAccent,
                            color: Colors.orange.withOpacity(0.7),
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
