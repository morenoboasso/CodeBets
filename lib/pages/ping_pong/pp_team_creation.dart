import 'package:flutter/material.dart';
import '../../widgets/ping_pong/color_picker_dialog.dart';
import 'pp_game_settings.dart'; // Importa la pagina delle impostazioni del gioco

class TeamCreationPage extends StatefulWidget {
  final int players;
  const TeamCreationPage({Key? key, required this.players}) : super(key: key);

  @override
  _TeamCreationPageState createState() => _TeamCreationPageState();
}

class _TeamCreationPageState extends State<TeamCreationPage> {
  final TextEditingController _team1NameController = TextEditingController();
  final TextEditingController _team2NameController = TextEditingController();
  final List<TextEditingController> _team1PlayerControllers = [];
  final List<TextEditingController> _team2PlayerControllers = [];
  Color _team1Color = Colors.red;
  Color _team2Color = Colors.blue;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < (widget.players / 2); i++) {
      _team1PlayerControllers.add(TextEditingController());
      _team2PlayerControllers.add(TextEditingController());
    }
  }

  void _createTeamsAndNavigateToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameSettingsPage(
          team1Name: _team1NameController.text,
          team2Name: _team2NameController.text,
          team1Color: _team1Color,
          team2Color: _team2Color,
          players: widget.players,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Creation'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Team 1', style: TextStyle(fontSize: 24)),
                      TextField(
                        controller: _team1NameController,
                        decoration: const InputDecoration(labelText: 'Team Name'),
                      ),
                      for (int i = 0; i < (widget.players / 2); i++)
                        TextField(
                          controller: _team1PlayerControllers[i],
                          decoration: InputDecoration(labelText: 'Player ${i + 1} Name'),
                        ),
                      const SizedBox(height: 16),
                      const Text('Team Color'),
                      GestureDetector(
                        onTap: () async {
                          Color? pickedColor = await showDialog<Color>(
                            context: context,
                            builder: (context) => ColorPickerDialog(initialColor: _team1Color),
                          );
                          if (pickedColor != null) {
                            setState(() {
                              _team1Color = pickedColor;
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          color: _team1Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Team 2', style: TextStyle(fontSize: 24)),
                      TextField(
                        controller: _team2NameController,
                        decoration: const InputDecoration(labelText: 'Team Name'),
                      ),
                      for (int i = 0; i < (widget.players / 2); i++)
                        TextField(
                          controller: _team2PlayerControllers[i],
                          decoration: InputDecoration(labelText: 'Player ${i + 1} Name'),
                        ),
                      const SizedBox(height: 16),
                      const Text('Team Color'),
                      GestureDetector(
                        onTap: () async {
                          Color? pickedColor = await showDialog<Color>(
                            context: context,
                            builder: (context) => ColorPickerDialog(initialColor: _team2Color),
                          );
                          if (pickedColor != null) {
                            setState(() {
                              _team2Color = pickedColor;
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          color: _team2Color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTeamsAndNavigateToSettingsPage,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
