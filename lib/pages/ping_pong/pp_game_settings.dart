import 'package:codebets/pages/ping_pong/pp_game_points.dart';
import 'package:flutter/material.dart';

class GameSettingsPage extends StatefulWidget {
  final String team1Name;
  final String team2Name;
  final Color team1Color;
  final Color team2Color;
  final int players;

  const GameSettingsPage({
    Key? key,
    required this.team1Name,
    required this.team2Name,
    required this.team1Color,
    required this.team2Color,
    required this.players,
  }) : super(key: key);

  @override
  _GameSettingsPageState createState() => _GameSettingsPageState();
}



class _GameSettingsPageState extends State<GameSettingsPage> {
  int _numberOfSets = 3;
  int _selectedPointsPerSet = 11;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Number of Sets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _numberOfSets.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (double value) {
                setState(() {
                  _numberOfSets = value.toInt();
                });
              },
              label: '$_numberOfSets Sets',
            ),
            const SizedBox(height: 20),
            const Text(
              'Points per Set',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ToggleButtons(
              isSelected: <bool>[
                _selectedPointsPerSet == 11,
                _selectedPointsPerSet == 21,
              ],
              onPressed: (int index) {
                setState(() {
                  _selectedPointsPerSet = index == 0 ? 11 : 21;
                });
              },
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('11 Points'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('21 Points'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTeamsAndNavigateToPointsPage,
              child: const Text('Start Match'),
            ),
          ],
        ),
      ),
    );
  }
  void _createTeamsAndNavigateToPointsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PointsPage(
          team1Name: widget.team1Name,
          team2Name: widget.team2Name,
          team1Color: widget.team1Color,
          team2Color: widget.team2Color,
          players: widget.players,
          numberOfSets: _numberOfSets,
          pointsPerSet: _selectedPointsPerSet,
        ),
      ),
    );
  }
}
