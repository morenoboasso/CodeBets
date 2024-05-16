import 'package:flutter/material.dart';
import '../../models/bet.dart';
import '../../services/db_service.dart';
import '../../widgets/bet_card.dart';
import 'package:get_storage/get_storage.dart';

class ActiveBetsPage extends StatefulWidget {
  const ActiveBetsPage({Key? key}) : super(key: key);

  @override
  _ActiveBetsPageState createState() => _ActiveBetsPageState();
}

class _ActiveBetsPageState extends State<ActiveBetsPage> {
  List<Bet> _betList = [];
  bool _isLoading = true;
  late Stream<List<Bet>> _betsStream; // Aggiunta dello stream

  @override
  void initState() {
    super.initState();
    _betsStream = DbService().betsStream; // Inizializzazione dello stream
    _loadBets(); // Caricamento iniziale delle scommesse
  }

  // Load bets from the database and apply user filter
  Future<void> _loadBets() async {
    String? storedUserName = GetStorage().read<String>('userName');
    await for (List<Bet> snapshot in _betsStream) { // Ascolta gli aggiornamenti dello stream
      setState(() {
        _isLoading = true; // Mostra lo spinner di caricamento
      });
      // Aggiorna la lista locale delle scommesse con quella ottenuta dallo stream
      _betList = snapshot;
      // Applica il filtro in base all'utente memorizzato
      if (storedUserName != null) {
        _betList = _betList.where((bet) => bet.target != storedUserName).toList();
      }
      setState(() {
        _isLoading = false; // Nasconde lo spinner di caricamento
      });
    }
  }

  // Restituisci un indicatore di aggiornamento quando si scorre verso il basso
  Future<void> _refresh() async {
    setState(() {
      _isLoading = true; // Mostra lo spinner di caricamento
    });
    await _loadBets(); // Ricarica le scommesse
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scommesse Attive'),
      ),
      body: _isLoading
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
          : RefreshIndicator(
        onRefresh: _refresh,
        child: _betList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Nessuna scommessa al momento"),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _refresh,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh_outlined,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
            : CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Padding(
                    padding:
                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
    );
  }
}
