import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';
import '../../widgets/ping_pong/color_picker_dialog.dart';
import 'pp_game_settings.dart';

class TeamCreationPage extends StatefulWidget {
  final int players;
  final bool isSingleMode; // New parameter to indicate single mode
  const TeamCreationPage({super.key, required this.players, required this.isSingleMode});

  @override
  _TeamCreationPageState createState() => _TeamCreationPageState();
}

class _TeamCreationPageState extends State<TeamCreationPage> {
  final TextEditingController _team1NameController = TextEditingController();
  final TextEditingController _team2NameController = TextEditingController();
  final List<TextEditingController> _team1PlayerControllers = [];
  final List<TextEditingController> _team2PlayerControllers = [];
  Color _team1Color = TeamColors.green;
  Color _team2Color = TeamColors.red;

  @override
  void initState() {
    super.initState();
    if (!widget.isSingleMode) {
      for (int i = 0; i < (widget.players / 2); i++) {
        _team1PlayerControllers.add(TextEditingController());
        _team2PlayerControllers.add(TextEditingController());
      }
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: ColorsBets.blackHD),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Creazione Team',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ColorsBets.blackHD,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Team 1', style: TextStyle(fontSize: 24, color: ColorsBets.blackHD)),
                        TextField(
                          controller: _team1NameController,
                          decoration: const InputDecoration(labelText: 'Team Name', labelStyle: TextStyle(color: ColorsBets.blackHD)),
                        ),
                        if (!widget.isSingleMode)
                          for (int i = 0; i < (widget.players / 2); i++)
                            TextField(
                              controller: _team1PlayerControllers[i],
                              decoration: InputDecoration(labelText: 'Player ${i + 1} Name', labelStyle: const TextStyle(color: ColorsBets.blackHD)),
                            ),
                        const SizedBox(height: 16),
                        const Text('Team Color', style: TextStyle(color: ColorsBets.blackHD)),
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
                        const Text('Team 2', style: TextStyle(fontSize: 24, color: ColorsBets.blackHD)),
                        TextField(
                          controller: _team2NameController,
                          decoration: const InputDecoration(labelText: 'Team Name', labelStyle: TextStyle(color: ColorsBets.blackHD)),
                        ),
                        if (!widget.isSingleMode)
                          for (int i = 0; i < (widget.players / 2); i++)
                            TextField(
                              controller: _team2PlayerControllers[i],
                              decoration: InputDecoration(labelText: 'Player ${i + 1} Name', labelStyle: const TextStyle(color: ColorsBets.blackHD)),
                            ),
                        const SizedBox(height: 16),
                        const Text('Team Color', style: TextStyle(color: ColorsBets.blackHD)),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTeamsAndNavigateToSettingsPage,
        child: const Icon(Icons.arrow_forward, color: Colors.black),
      ),
    );
  }
}
